import std.stdio;
import derelict.opengl3.gl;
import derelict.opengl3.gl3;
import derelict.sdl2.sdl;
import mat4;

void main(string[] args)
{
	DerelictGL.load();
	DerelictGL3.load();
	DerelictSDL2.load();

	// Set up SDL context here
	SDL_Init(SDL_INIT_VIDEO);
	auto window = SDL_CreateWindow("Testing Window", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 640,
			480, SDL_WINDOW_OPENGL);
	auto context = SDL_GL_CreateContext(window);

	DerelictGL3.reload();

	SDL_Delay(1000);
}

