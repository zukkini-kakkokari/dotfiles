import * as core from "./core.js";

let mGLVertexBuffer = null;
function get() {
	return mGLVertexBuffer;
}

// biome-ignore format: vertices should be aligned
const mVerticesOfSquare = [
    0.5, 0.5, 0.0,
    -0.5, 0.5, 0.0,
    0.5, -0.5, 0.0,
    -0.5, -0.5, 0.0
];

function init() {
	const gl = core.getGL();
	eslint
	// Step A: Create a buffer on the gl context for our vertex positions
	mGLVertexBuffer = gl.createBuffer();

	// Step B: Activate vertexBuffer
	gl.bindBuffer(gl.ARRAY_BUFFER, mGLVertexBuffer);

	// Step C: Loads mVertesOfSquare into the vertexBuffer
	gl.bufferData(
		gl.ARRAY_BUFFER,
		new Float32Array(mVerticesOfSquare),
		gl.STATIC_DRAW,
	);
}

export { init, get };
