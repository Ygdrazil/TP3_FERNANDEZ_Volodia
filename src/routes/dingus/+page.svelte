<script lang="ts">
	import WebGL from 'three/examples/jsm/capabilities/WebGL';

	import * as THREE from 'three';
	import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';

	import { onMount } from 'svelte';
	import dingusModel from '$lib/assets/models/dingus_the_cat.glb';
	import dingusMusic from '$lib/assets/sounds/dingus_theme.ogg';

	// Checks that your browser supports WebGL.
	if (!WebGL.isWebGLAvailable) {
		const warning = WebGL.getWebGLErrorMessage();
		document.getElementById('container')?.replaceChildren(warning);
	}

	const Gloader = new GLTFLoader();

	var renderer: THREE.WebGLRenderer;
	var scene: THREE.Scene;
	var camera: THREE.Camera;
	var curTime = Date.now();
	var dingus: THREE.Group;
	var light: THREE.Light;

	// This function is called whenever the document is loaded
	function init() {
		Gloader.load(dingusModel, function (gltf) {
			dingus = gltf.scene;
			scene.add(dingus);
		});

		// Get display canvas
		var canvas = document.getElementById('webglcanvas') as HTMLCanvasElement;

		// Create the Three.js renderer and attach it to our canvas
		renderer = new THREE.WebGLRenderer({
			canvas: canvas,
			antialias: true
		});
		// Set the viewport size
		renderer.setSize(canvas.width, canvas.height);
		// Create a new Three.js scene
		scene = new THREE.Scene();

		scene.background = new THREE.Color(1, 1, 1);

		// Add  a camera so we can view the scene
		camera = new THREE.PerspectiveCamera(45, canvas.width / canvas.height, 1, 4000);

		const audioListener = new THREE.AudioListener();

		camera.add(audioListener);

		const dingusSound = new THREE.Audio(audioListener);
		dingusSound.loop = true;
		dingusSound.setVolume(0.3);
		scene.add(dingusSound);

		const audioLoader = new THREE.AudioLoader();

		audioLoader.load(dingusMusic, (audioBuffer) => {
			dingusSound.setBuffer(audioBuffer);
			dingusSound.play();
		});

		camera.position.z = 40;
		camera.position.y = 18;
		camera.rotation.x = -0.2;

		light = new THREE.PointLight(0xffffff, 2);
		light.position.y = 15;
		scene.add(light);
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

		if (dingus) dingus.rotation.y -= angle * 2;

		light.position.x = camera.position.x;
		light.position.y = camera.position.y;
		light.position.z = camera.position.z;
	}
	onMount(() => {
		init();
		run();
	});
</script>

<main id="container">
	<h1>Dingus Time</h1>
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
