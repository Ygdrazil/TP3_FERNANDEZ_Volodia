<script lang="ts">
	import WebGL from 'three/examples/jsm/capabilities/WebGL';

	import * as THREE from 'three';

	import { onMount } from 'svelte';

	import WebglLogo from '$lib/assets/images/webgl-logo-256.jpg';

	// Checks that your browser supports WebGL.
	if (!WebGL.isWebGLAvailable) {
		const warning = WebGL.getWebGLErrorMessage();
		document.getElementById('container')?.replaceChildren(warning);
	}

	var renderer: THREE.WebGLRenderer;
	var scene: THREE.Scene;
	var camera: THREE.Camera;
	var cube: THREE.Mesh;
	var curTime = Date.now();

	// This function is called whenever the document is loaded
	function init() {
		// Get display canvas
		var canvas = document.getElementById('webglcanvas') as HTMLCanvasElement;
		console.log(canvas);

		// Create the Three.js renderer and attach it to our canvas
		renderer = new THREE.WebGLRenderer({ canvas: canvas, antialias: true });
		// Set the viewport size
		renderer.setSize(canvas.width, canvas.height);
		// Create a new Three.js scene
		scene = new THREE.Scene();
		// Add  a camera so we can view the scene
		camera = new THREE.PerspectiveCamera(45, canvas.width / canvas.height, 1, 4000);
		// Create a texture-mapped cube and add it to the scene
		// First, create the texture map
		var map = new THREE.TextureLoader().load(WebglLogo);

		// Now, create a Basic material; pass in the map
		var material = new THREE.MeshBasicMaterial({ map: map });

		// Create the cube geometry
		var geometry = new THREE.BoxGeometry(2, 2, 2);

		// And put the geometry and material together into a mesh
		cube = new THREE.Mesh(geometry, material);

		// Move the mesh back from the camera and tilt it toward the viewer
		cube.position.z = -8;
		cube.rotation.x = Math.PI / 5;
		cube.rotation.y = Math.PI / 5;

		// Finally, add the mesh to our scene
		scene.add(cube);
	}

	// This function is called regularly to update the canvas webgl.
	function run() {
		// Ask to call again run
		requestAnimationFrame(run);

		// Render the scene
		render();

		// Calls the animate function if objects or camera should move
		animate();
	}

	// This function is called regularly to take care of the rendering.
	function render() {
		// Render the scene
		renderer.render(scene, camera);
	}

	// This function is called regularly to update objects.
	function animate() {
		// Computes how time has changed since last display
		var now = Date.now();
		var deltaTime = now - curTime;
		curTime = now;
		var fracTime = deltaTime / 1000; // in seconds
		// Now we can move objects, camera, etc.
		// Example: rotation cube
		var angle = 0.1 * Math.PI * 2 * fracTime; // one turn per 10 second.
		cube.rotation.y += angle;
	}
	onMount(() => {
		init();
		run();
	});
</script>

<main id="container">
	<h1>Question 1</h1>
	<canvas id="webglcanvas" width="600" height="500" />
</main>

<style>
	#webglcanvas {
		border: none;
		background-color: black;
	}

	#container {
		display: flex;
		flex-direction: column;
		width: 100%;
		align-items: center;
		justify-content: center;
	}
</style>
