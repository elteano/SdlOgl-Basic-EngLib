import core.stdc.string;
import std.algorithm;

struct Vec4
{
	private:
		float[4] m;

	public:
		version(NONE)
		{
			this()
			{
				memset(m.ptr, 0, 4);
			}
		}

		/**
		 * Initializes the vector with the given float array.
		 *
		 * Only the first four elements will be used. If the array has less than
		 * four elements, than the rest will be filled with zeroes.
		 */
		this(float[] ms...)
		{
			size_t end = min(ms.length, 4);
			for (size_t i = 0; i < end; ++i)
			{
				m[i] = ms[i];
			}
			for (; end < 4; ++end)
			{
				m[end] = 0;
			}
		}

		/**
		 * Sets the vector values to match the given array.
		 */
		void set(ref float[4] nm)
		{
			m[] = nm;
		}

		/**
		 * Calculates the dot product of the two vectors
		 */
		float dot(ref Vec4 o)
		{
			return m[0] * o[0] + m[1] * o[1] + m[2] * o[2] + m[3] * o[3];
		}

		/**
		 * Calculates the dot product of the two vectors, ignoring the fourth element
		 * of each
		 */
		float dot_3(ref Vec4 o)
		{
			return m[0] * o[0] + m[1] * o[1] + m[2] * o[2];
		}

		/**
		 * Calculates the cross product using only the first three elements of each
		 * vector. The fourth element is the product of the fourth elements of each
		 * vector.
		 */
		ref auto cross_3(ref Vec4 o)
		{
			float m0 = m[1] * o.m[2] - m[2] * o.m[1];
			float m1 = m[2] * o.m[0] - m[0] * o.m[2];
			float m2 = m[0] * o.m[1] - m[1] * o.m[0];

			return Vec4(m0, m1, m2, m[3] * o.m[3]);
		}

		/**
		 * Divides all elements by the last element so that the last element is 1.
		 * If the last element is zero, then the elements are unchanged.
		 */
		ref auto dehomogenize()
		{
			auto b = Vec4();
			if (m[3] != 0)
			{
				b[0] = m[0] / m[3];
				b[1] = m[1] / m[3];
				b[2] = m[2] / m[3];
			}
			else
			{
				b.m = m;
			}
			return b;
		}

		ref float opIndex(size_t i)
		{
			return m[i];
		}

		/**
		 * Gets the pointer for the values in the vector for use with OpenGL. This
		 * should not be used for modification of the values, as this pointer may
		 * not stay consistent with the internally used pointer.
		 */
		@property auto ptr()
		{
			return m.ptr;
		}
}

