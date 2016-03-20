import model;
import mat4;

/**
 * Node within a scene graph.
 */
abstract class Node
{
	private:
	public:
		/**
		 * Draw this node with the given camera, projection, and transformation
		 * matrices.
		 *
		 * Params:
		 * 	cam = Matrix describing the transformation from world coordinates to
		 * 	camera coordinates.
		 * 	proj = Matrix describing the transformation from camera coordinates to
		 * 	the view space.
		 * 	trans = Matrix describing the transformation from object coordinates to
		 * 	world coordinates.
		 */
		void draw(ref Mat4 cam, ref Mat4 proj, ref Mat4 trans);
}

/**
 * Node containing some number of children. Calls to draw this node will be
 * propagated to these children.
 */
class GroupNode : Node
{
	private:
		Node[] children;

	public:
		void addChild(Node n)
		{
			children ~= n;
		}

		override void draw(ref Mat4 cam, ref Mat4 proj, ref Mat4 trans)
		{
			foreach (ref child ; children)
			{
				child.draw(cam, proj, trans);
			}
		}
}

/**
 * Node which modifies the transformation matrix to be used by its children.
 */
class TransformNode : GroupNode
{
	private:
		Mat4 transformation;

	public:
		override void draw(ref Mat4 cam, ref Mat4 proj, ref Mat4 trans)
		{
			Mat4 new_trans = trans * transformation;
			super.draw(cam, proj, new_trans);
		}
}

/**
 * Node which contains a single model to be rendered.
 */
class ModelNode : Node
{
	private:
		Model* m;

	public:
		this(Model* m)
		{
			this.m = m;
		}

		override void draw(ref Mat4 cam, ref Mat4 proj, ref Mat4 trans)
		{
			m.draw(cam, proj, trans);
		}
}

/**
 * Node which may or may not be drawn, as per runtime specification.
 */
class ToggleNode : GroupNode
{
	private:
		bool drawme;

	public:
		void setDraw(bool d)
		{
			drawme = d;
		}

		override void draw(ref Mat4 cam, ref Mat4 proj, ref Mat4 trans)
		{
			if (drawme)
			{
				super.draw(cam, proj, trans);
			}
		}
}

