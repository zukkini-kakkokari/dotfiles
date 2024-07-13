// HelloPint2.js (c) 2012 matsuda
// Vertex shader program
const VSHADER_SOURCE = /*glsl*/ `
  // x' = x cos b - y sib b
  // y' = x sin b + y cos b
  // z' = z
  attribute vec4 a_Position; 
  uniform mat4 u_xformMatrix;
  void main() {
	gl_Position = u_xformMatrix * a_Position;
  }
  `;

// Fragment shader program
const FSHADER_SOURCE = /*glsl*/ `
	void main() {
	  gl_FragColor = vec4(0.95, 0.87, 0.74, 1.0);
	}
	`;

// const ANGLE = 90.0;
const Tx = 0.5;
const Ty = 0.5;
const Tz = 0.0;

function main() {
	// Retrieve <canvas> element
	const canvas = document.getElementById("webgl");

	// Get the rendering context for WebGL
	const gl = getWebGLContext(canvas);
	if (!gl) {
		console.log("Failed to get the rendering context for WebGL");
		return;
	}

	// Initialize shaders
	if (!initShaders(gl, VSHADER_SOURCE, FSHADER_SOURCE)) {
		console.log("Failed to intialize shaders.");
		return;
	}

	const n = initVertexBuffers(gl);
	if (n < 0) {
		console.log("Failed to set the positions of the vertices");
		return;
	}

	// const radian = (Math.PI * ANGLE) / 180.0;
	// const cosB = Math.cos(radian);
	// const sinB = Math.sin(radian);

	// biome-ignore format: matrix
	const xformMatrix = new Float32Array([
		1.0, 0.0, 0.0, 0.0,
		0.0, 1.0, 0.0, 0.0,
		0.0, 0.0, 1.0, 0.0,
		Tx,   Ty,  Tz, 1.0,
	]);

	const u_xformMatrix = gl.getUniformLocation(gl.program, "u_xformMatrix");
	gl.uniformMatrix4fv(u_xformMatrix, false, xformMatrix);

	// Specify the color for clearing <canvas>
	gl.clearColor(0.0, 0.0, 0.0, 1.0);
	// Clear <canvas>
	gl.clear(gl.COLOR_BUFFER_BIT);

	gl.drawArrays(gl.TRIANGLES, 0, n);
}

function initVertexBuffers(gl) {
	// biome-ignore format: vertices
	const vertices = new Float32Array([
		 0.0,  0.5, 
		-0.5, -0.5, 
		 0.5, -0.5, 
	]);
	const n = 3;

	const vertexBuffer = gl.createBuffer();
	if (!vertexBuffer) {
		console.log("Failed to create the buffer object");
		return -1;
	}

	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

	const a_Position = gl.getAttribLocation(gl.program, "a_Position");
	if (a_Position < 0) {
		console.log("Failed to get the storage location of a_POSITION");
		return -1;
	}

	gl.vertexAttribPointer(a_Position, 2, gl.FLOAT, false, 0, 0);
	gl.enableVertexAttribArray(a_Position);

	return n;
}
