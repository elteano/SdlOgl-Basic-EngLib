import scene;
import derelict.opengl3.gl3;
import derelict.sdl2.sdl;

/**
 * Object for handling an SDL-based window which contains and displays an OpenGL
 * context.
 */
struct RenderWindow
{
	private:
		SDL_Window* window;
		SDL_GLContext context;
		Scene * scene;
		void delegate() drawFunc;

	public:
		this(string title, int width, int height)
		{
			window = SDL_CreateWindow(title.dup.ptr, SDL_WINDOWPOS_CENTERED,
					SDL_WINDOWPOS_CENTERED, width, height, SDL_WINDOW_OPENGL);
		}

		~this()
		{
			recycle();
		}

		void setDrawFunc(void delegate() func)
		{
			drawFunc = func;
		}

		void render()
		{
			int width, height;
			SDL_GetWindowSize(window, &width, &height);
			glViewport(0, 0, width, height);
			if (drawFunc)
			{
				drawFunc();
				SDL_GL_SwapWindow(window);
			}
		}

		void recycle()
		{
			if (window !is null)
			{
				SDL_GL_DeleteContext(context);
				SDL_DestroyWindow(window);
				window = null;
			}
		}
}

