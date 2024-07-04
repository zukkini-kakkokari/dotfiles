import * as vertexBuffer from "./vertex_buffer";
import * as simpleShader from "./shader_support";

let mGL = null; // Convention: variable in a module: mName
function getGL() {
	return mGL;
}

function initWebGL(htmlCanvasID) {
	const canvas = document.getElementById(htmlCanvasID);

	mGL = canvas.getContext("webgl2");

	if (mGL === null) {
		document.write("<br><b>WebGL 2 is not supported!</b>");
		return;
	}
	mGL.clearColor(0.0, 0.8, 0.0, 1.0); // set the color to be cleared

	// 1. Initialize buffer with vertex positions for the unit square
	vertexBuffer.init();

	// 2. Now load and compile the vertex and fragment shaders
	simpleShader.init("VertexShader", "FragmentShader");
}

function drawSquare() {
	// Step A: Activate the shader
	simpleShader.activate();

	// Step B: Draw with the above settings
	mGL.drawArrays(mGL.TRIANGLE_STRIP, 0, 4);
}

function clearCanvas() {
	mGL.clear(mGL.COLOR_BUFFER_BIT);
}

window.onload = () => {
	initWebGL("GLCanvas"); // Binds mGL context to WebGL functionality
	clearCanvas(); // Clears the GL area
	drawSquare(); // Draws one square
};

export { getGL };
