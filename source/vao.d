import derelict.opengl3.gl3;

/**
 * Abstraction for a vertex array object
 */
class Vao
{
	private:
		/// The OpenGL id number for this VAO
		uint vao_id;
		/**
		 * The OpenGL id numbers for the buffers used by this VAO
		 */
		uint[] buffers;
		static uint current_vao;
		size_t num_indices;

		/**
		 * Call at the beginning of each function in order to ensure that this VAO
		 * is bound as intended
		 */
		void bindWrapStart()
		{
			assert(vao_id > 0, "VAO has not been properly initialized!");
			// TODO enable a way to omit generic VAO binding check
			glGetIntegerv(GL_ARRAY_BUFFER_BINDING, cast(int*) &current_vao);
			if (current_vao != vao_id)
			{
				glBindVertexArray(vao_id);
			}
		}

		/**
		 * Call at the end of each function in order to ensure that the previously
		 * bound VAO is still bound.
		 */
		void bindWrapEnd()
		{
			if (current_vao != vao_id)
			{
				glBindVertexArray(current_vao);
			}
		}

	public:
		/// Generates a VAO in the current OpenGL context.
		this()
		{
			glGenVertexArrays(1, &vao_id);
		}

		~this()
		{
			glDeleteVertexArrays(1, &vao_id);
			glDeleteBuffers(buffers.length, buffers.ptr);
		}

		/**
		 * Sets this VAO as active in the current OpenGL context.
		 *
		 * This is not necessary to use the VAO, as checks are done at the entrance
		 * and exit of each function in order to ensure that no function called by
		 * this object modifies the state of any other VAOs. This has been
		 * implemented such that this will respect even VAOs not handled by an
		 * instantiation of this class.
		 */
		void bind()
		{
			glBindVertexArray(vao_id);
			current_vao = vao_id;
		}

		/**
		 * Creates a VBO, loads the given data into that VBO, and associates that
		 * VBO with this VAO.
		 *
		 * If a VBO already exists for the given index, then the data in that VBO
		 * will be overridden with the new data.
		 */
		void loadToBuffer(T)(T ptr, int size, uint index, GLenum type, GLsizei stride)
		{
			bindWrapStart();
			uint vbo = 0;
			// Here we ensure that we aren't creating an extra buffer object
			glGetVertexAttribiv(index, GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING,
					cast(int*) &vbo);
			if (vbo == 0)
			{
				glGenBuffers(1, &vbo);
				buffers ~= vbo;
			}
			glBindBuffer(GL_ARRAY_BUFFER, vbo);
			glBufferData(GL_ARRAY_BUFFER, ptr.length * ptr[0].sizeof, ptr.ptr,
					GL_STATIC_DRAW);
			glVertexAttribPointer(index, size, type, GL_FALSE, stride, null);
			glEnableVertexAttribArray(index);
			bindWrapEnd();
		}

		/**
		 * Creates a VBO, loads the given data into that VBO, and sets that VBO as
		 * the indices VBO.
		 *
		 * If a VBO already exists for indices, then the data in that VBO will be
		 * overridden with the new data.
		 */
		void loadIndices(T)(T indices)
		{
			num_indices = indices.length;
			bindWrapStart();
			uint vbo = 0;
			glGetIntegerv(GL_ELEMENT_ARRAY_BUFFER_BINDING, cast(int*) &vbo);
			if (vbo == 0)
			{
				glGenBuffers(1, &vbo);
				buffers ~= vbo;
			}
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vbo);
			glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length *
					typeof(*indices.ptr).sizeof, indices.ptr, GL_STATIC_DRAW);
			bindWrapEnd();
		}

		@property size_t length()
		{
			return num_indices;
		}
}

