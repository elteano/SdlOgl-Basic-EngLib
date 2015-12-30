import core.stdc.string;
import vec4;

/**
 * 4x4 column-major matrix for use with OpenGL.
 */
struct Mat4
{
	private:
		float[16] m;

	public:
		version(NONE)
		{
			this()
			{
				memset(m.ptr, 0, 16);
			}
		}

		/// Initializes all values in the matrix to the given value
		this(float all)
		{
			foreach (ref v; m)
			{
				v = all;
			}
		}

		void set(float m00, float m10, float m20, float m30,
				float m01, float m11, float m21, float m31,
				float m02, float m12, float m22, float m32,
				float m03, float m13, float m23, float m33)
		{
			m[0] = m00;
			m[1] = m10;
			m[2] = m20;
			m[3] = m30;

			m[4] = m01;
			m[5] = m11;
			m[6] = m21;
			m[7] = m31;

			m[8] = m02;
			m[9] = m12;
			m[10] = m22;
			m[11] = m32;

			m[12] = m03;
			m[13] = m13;
			m[14] = m23;
			m[15] = m33;
		}

		void set(float[16] nm)
		{
			m = nm;
		}

		/// Sets this matrix to the identity matrix
		void identity()
		{
			set(1, 0, 0, 0,
					0, 1, 0, 0,
					0, 0, 1, 0,
					0, 0, 0, 1);
		}

		Mat4 mult(ref Mat4 o)
		{
			Mat4 n = Mat4(0.0f);
			for (size_t column = 0; column < 4; ++column)
			{
				for (size_t row = 0; row < 4; ++row)
				{
					for (size_t pair = 0; pair < 4; ++pair)
					{
						n[column * 4 + row] += m[row + pair * 4] * o[pair + column * 4];
					}
				}
			}
			return n;
		}

		Vec4 mult(ref Vec4 v)
		{
			Vec4 n;
			for (size_t row = 0; row < 4; ++row)
			{
				n[row] = v[0] * m[row] + v[1] * m[row + 4] + v[2] * m[row + 8] + v[3] *
					m[row + 12];
			}
			return n;
		}

		bool equals(ref Mat4 o)
		{
			for (size_t i = 0; i < 16; ++i)
			{
				if (m[i] != o[i])
				{
					return false;
				}
			}
			return true;
		}

		auto opBinary(string op)(ref T o)
		{
			static if (op == "*") return mult(o);
			else static assert(0, "Operator "~op~" not implemented for Mat4.");
		}

		ref float opIndex(size_t i)
		{
			//static assert(i < 16 && i >= 0, "Mat4 index out of range.");
			return m[i];
		}

		ref float opIndex(size_t col, size_t row)
		{
			return m[col + row * 4];
		}

		void opAssign(ref Mat4 o)
		{
			m[] = o.m;
		}

		bool opEquals(ref Mat4 o)
		{
			return equals(o);
		}

		@property auto ptr()
		{
			return m.ptr;
		}
}

