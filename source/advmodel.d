import mat4;
import model;
import shader;
import vao;

import derelict.opengl3.gl3;

class AdvancedModel : Model
{
	private:
		ShaderProgram * shader_prog;
		Vao * arrayobj;

	public:
		this(ShaderProgram * shad)
		{
			shader_prog = shad;
		}

		void setVao(Vao * vao)
		{
			arrayobj = vao;
		}

		override void draw(ref Mat4 cam, ref Mat4 proj, ref Mat4 trans)
		{
			shader_prog.bind();
			arrayobj.bind();

			// All data is drawn from the VAO
			glDrawElements(GL_TRIANGLES, arrayobj.length, GL_UNSIGNED_SHORT, null);

			ShaderProgram.unbind();
			glBindVertexArray(0);
		}

		override void tick()
		{
		}

		@property const(Vao *) vao()
		{
			return arrayobj;
		}
}

