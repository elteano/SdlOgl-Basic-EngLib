import core.stdc.string;
import std.algorithm;

struct Vec4
{
	alias m this;

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

	void set(ref float[4] nm)
	{
		m = nm;
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
}

