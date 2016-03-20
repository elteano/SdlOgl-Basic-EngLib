import derelict.opengl3.gl3;

class Texture
{
	protected:
		/// This texture's OpenGL handle.
		uint texid;

	public:
		this()
		{
			glGenTextures(1, &texid);
		}

		/**
		 * Binds this texture to the given texture number. The active texture after
		 * this function call should not be assumed to be at any particular value.
		 */
		void bind(uint texnum)
		{
			glActiveTexture(GL_TEXTURE0 + texnum);
			glBindTexture(GL_TEXTURE_2D, texid);
		}

		/**
		 * Unbinds the texture at the given texture number. The active texture
		 * after this function call should not be assumed to be at any particular
		 * value.
		 */
		static void unbind(uint texnum)
		{
			glActiveTexture(GL_TEXTURE0 + texnum);
			glBindTexture(GL_TEXTURE_2D, 0);
		}
}

