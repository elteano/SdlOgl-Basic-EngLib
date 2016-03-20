import mat4;
import vao;
import shader;
import model;
import derelict.opengl3.gl3;

/**
 * Model which is defined by a set of vertices and a texture.
 */
class StandardModel : Model
{
	private:
		Vao vao;
		/**
		 * Shader program to be used by all StandardModels.
		 * It merely draws a set of vertices with a given texture, transformed by
		 * the given camera and projection matrices.
		 */
		static ShaderProgram shader_prog;
		GLsizei num_elements;

	public:
		this(float[] vertices, ushort[] indices)
		{
			vao.loadToBuffer(vertices, 3, 0, GL_FLOAT, 0);
			vao.loadIndices(indices);
		}

		override
			void draw(ref Mat4 cam, ref Mat4 proj, ref Mat4 trans)
			{
				shader_prog.bind();
				vao.bind();

				// All data is drawn from the VAO
				glDrawElements(GL_TRIANGLES, num_elements, GL_UNSIGNED_SHORT, null);

				ShaderProgram.unbind();
				glBindVertexArray(0);
			}

		override
			void tick()
			{
				// empty
			}
}

