import mat4;

/**
 * Class representing a single model to be drawn. This can be anything from a
 * particle system to a tree.
 *
 * Anything which is to be drawn should probably be a Model of some flavor.
 */
abstract class Model
{
	public:
		/**
		 * Draw the model using the given camera, projection, and transformation
		 * matrices.
		 *
		 * This is a generic draw function; all other data should be handled
		 * internally by the object.
		 *
		 * Params:
		 * 	cam = Camera matrix for the view currently being rendered
		 * 	proj = Projection matrix for the view currently being rendered
		 * 	trans = Matrix describing transformations on the object
		 */
		abstract void draw(ref Mat4 cam, ref Mat4 proj, ref Mat4 trans);

		/**
		 * This will be called once per frame for frame-based updates on an
		 * individual object.
		 */
		abstract void tick();
}

