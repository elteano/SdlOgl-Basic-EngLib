import derelict.opengl3.gl3;
import std.stdio;

/**
 * Abstraction for shader programs. Handles the reading of files, binding to
 * the OpenGL context, obtaining attribute / uniform locations, etc.
 */
class ShaderProgram
{
	private:
		Shader* geom_shad;
		Shader* tess_control_shad;
		Shader* tess_eval_shad;
		Shader* frag_shad;
		Shader* vert_shad;

		/// ID of the current program
		uint prog_id;

		// Static because I'm not yet concerned about thread safety.
		/**
		 * Program which was previously in use when a call to a function of this
		 * class has been called.
		 */
		static uint prev_prog;

		/**
		 * Function to be called at the beginning of each function to ensure that
		 * no other shaders are affected by calls on a particular object.
		 */
		void preFun()
		{
			glGetIntegerv(GL_CURRENT_PROGRAM, cast(int*) prev_prog);
			if (prev_prog != prog_id)
			{
				glUseProgram(prog_id);
			}
		}

		/**
		 * Function to be called at the end of each function to ensure that calls
		 * to this object return the OpenGL current shader state to how it was
		 * before the function call.
		 */
		void postFun()
		{
			if (prev_prog != prog_id)
			{
				glUseProgram(prev_prog);
			}
		}

		void link()
		{
			glLinkProgram(prog_id);
		}

		/**
		 * Attaches the shader object to this program, if it exists.
		 */
		void prepShader(Shader* s)
		{
			if (s !is null)
			{
				s.attachToProg(prog_id);
			}
		}

		/**
		 * Explicitly destroys a shader object. This should be called after the
		 * shader program has been linked so as to free up OpenGL resources.
		 */
		void cleanShader(ref Shader * s)
		{
			if (s !is null)
			{
				s.dispose();
				destroy(s);
				s = null;
			}
		}

	public:
		/**
		 * Allocates a shader program from the OpenGL context.
		 */
		this()
		{
			prog_id = glCreateProgram();
		}

		~this()
		{
		}

		/**
		 * Uses the stored information to prep the shader.
		 */
		void setup()
		{
		}

		static void unbind()
		{
			glUseProgram(0);
			prev_prog = 0;
		}

		/**
		 * Loads the shader from the given file and preps it for use in this
		 * program as the geometry shader.
		 */
		void setGeometryShader(string fname)
		{
			if (geom_shad !is null)
			{
				geom_shad.dispose();
			}
			geom_shad = new Shader(fname, GL_GEOMETRY_SHADER);
		}

		/**
		 * Loads the shader from the given file and preps it for use in this
		 * program as the tesselation control shader.
		 */
		void setTessControlShader(string fname)
		{
			if (tess_control_shad !is null)
			{
				tess_control_shad.dispose();
			}
			tess_control_shad = new Shader(fname, GL_TESS_CONTROL_SHADER);
		}

		/**
		 * Loads the shader from the given file and preps it for use in this
		 * program as the tesselation evaluation shader.
		 */
		void setTessEvalShader(string fname)
		{
			if (tess_eval_shad !is null)
			{
				tess_eval_shad.dispose();
			}
			tess_eval_shad = new Shader(fname, GL_TESS_EVALUATION_SHADER);
		}

		/**
		 * Loads the shader from the given file and preps it for use in this
		 * program as the fragment shader.
		 */
		void setFragmentShader(string fname)
		{
			if (frag_shad !is null)
			{
				frag_shad.dispose();
			}
			frag_shad = new Shader(fname, GL_FRAGMENT_SHADER);
		}

		/**
		 * Loads the shader from the given file and preps it for use in this
		 * program as the vertex shader.
		 */
		void setVertexShader(string fname)
		{
			if (vert_shad !is null)
			{
				vert_shad.destroy();
			}
			vert_shad = new Shader(fname, GL_VERTEX_SHADER);
		}

		/**
		 * Sets this shader as active within the current OpenGL context.
		 */
		void bind()
		{
			glUseProgram(prog_id);
		}

		/**
		 * Gets the location of a uniform input variable in this shader program.
		 */
		uint getUniform(string var)
		{
			return glGetUniformLocation(prog_id, var.ptr);
		}
}

/**
 * Struct for individual shaders for use by a program.
 *
 * Don't confuse this with a shader program. This program represents one part
 * of the entire shader program (such as the vertex shader or the fragment
 * shader).
 */
struct Shader
{
	private:
		uint shad_id;
		string error_text;

	public:
		/**
		 * Create a shader from the given file with the given file type. The shader
		 * is compiled during this step.
		 */
		this(string fname, uint shad_type)
		{
			char[] shad_text = loadFile(fname);
			shad_id = glCreateShader(shad_type);
			const char* text_ptr = shad_text.ptr;
			glShaderSource(shad_id, 1, &text_ptr, null);
			glCompileShader(shad_id);
		}

		/**
		 * Cleans up the OpenGL resources used by the shader. It is best to either
		 * call dispose() manually or destroy references to this struct manually to
		 * ensure that OpenGL resources are freed as soon as possible.
		 */
		~this()
		{
			dispose();
		}

		/**
		 * Attach this shader to the given program.
		 *
		 * The shader will not remember that it has been attached to the given
		 * program.
		 */
		void attachToProg(uint prog)
		{
			glAttachShader(prog, shad_id);
		}

		/**
		 * Disposes of the OpenGL resource for this shader. This will invalidate
		 * this shader struct, so be sure to not do this until after its usefulness
		 * has been done.
		 *
		 * It is good practice to call this function when the shader is no longer
		 * necessary (that is, after it has been linked to a shader program), as it
		 * will free the OpenGL resources used by this shader object. This will
		 * also be done by the garbage collector if not done manually, although
		 * there is no guarantee when the garbage collector will do so.
		 */
		void dispose()
		{
			if (shad_id > 0)
			{
				glDeleteShader(shad_id);
				shad_id = -1;
			}
		}

		/**
		 * State of whether this shader object has generated any errors.
		 */
		@property bool hasError()
		{
			return (error_text.length > 0);
		}

		/**
		 * Error text generated by this shader.
		 */
		@property string error()
		{
			return error_text;
		}
}

private:
/**
 * Loads up a file into a string. This string will be zero-terminated so that
 * lengths do not need to be passed to OpenGL.
 */
char[] loadFile(string fname)
{
	char[] build;
	auto f = new File(fname);
	// Reserve enough space to hold the entire file, plus a null character
	build.reserve(cast(size_t) f.size + 1);
	foreach (ref line ; f.byLine())
	{
		build ~= line.dup;
	}
	build ~= '\0';
	return build;
}

