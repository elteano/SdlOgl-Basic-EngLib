import derelict.opengl3.gl3;
import model;
import mat4;
import sgraph;

/**
 * Class describing an OpenGL scene which may be rendered.
 */
class Scene
{
	private:
		Node * root;

	public:
		void draw(ref Mat4 cam, ref Mat4 proj)
		{
			Mat4 trans;
			trans.identity();
			root.draw(cam, proj, trans);
		}
}

