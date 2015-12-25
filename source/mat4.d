import core.stdc.string;

class Mat4
{
	alias m this;

	private:
		float[16] m;

	public:
		this()
		{
			memset(m.ptr, 0, 16);
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

		void set(Mat4 o)
		{
			m = o.m;
		}

		/// Sets this matrix to the identity matrix
		void identity()
		{
			set(1, 0, 0, 0,
					0, 1, 0, 0,
					0, 0, 1, 0,
					0, 0, 0, 1);
		}

		void mult(ref Mat4 o)
		{
			Mat4 n = new Mat4();
			for (size_t column = 0; column < 4; ++column)
			{
				for (size_t row = 0; row < 4; ++row)
				{
					for (size_t pair = 0; pair < 4; ++pair)
					{
						n[column + row * 4] += m[row * 4 + pair] * o[pair * 4 + column];
					}
				}
			}
		}

		auto opBinary(string op)(ref T o)
		{
			static if (op == "*") return mult(o);
			else static assert(0, "Operator "~op~" not implemented for Mat4.");
		}
}

