<script lang="ts">
	import WebGL from 'three/examples/jsm/capabilities/WebGL';

	import * as THREE from 'three';
	import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

	import { onMount } from 'svelte';

	import earthMapUrl from '$lib/assets/images/earth_atmos_2048.jpg';
	import earthSpecularMapUrl from '$lib/assets/images/earth_specular_2048.jpg';
	import earthNormalMapUrl from '$lib/assets/images/earth_normal_2048.jpg';
	import earthEmissiveMapUrl from '$lib/assets/images/earth_lights_2048.png';
	import moonMapUrl from '$lib/assets/images/moon_1024.jpg';
	import sunMapUrl from '$lib/assets/images/2k_sun.jpg';
	import cloudMapUrl from '$lib/assets/images/cloud.png';
	import sunVertexShader from '$lib/assets/shaders/sun/vertex.glsl';
	import sunFragmentShader from '$lib/assets/shaders/sun/fragment.glsl';

	import posXMapUrl from '$lib/assets/images/MilkyWay/posx.jpg';
	import negXMapUrl from '$lib/assets/images/MilkyWay/negx.jpg';
	import posYMapUrl from '$lib/assets/images/MilkyWay/posy.jpg';
	import negYMapUrl from '$lib/assets/images/MilkyWay/negy.jpg';
	import posZMapUrl from '$lib/assets/images/MilkyWay/posz.jpg';
	import negZMapUrl from '$lib/assets/images/MilkyWay/negz.jpg';
	import { Vector3 } from 'three';

	// Checks that your browser supports WebGL.
	if (!WebGL.isWebGLAvailable) {
		const warning = WebGL.getWebGLErrorMessage();
		document.getElementById('container')?.replaceChildren(warning);
	}

	var renderer: THREE.WebGLRenderer;
	var scene: THREE.Scene;
	var camera: THREE.Camera;
	var controls: OrbitControls;

	var sunGroup: THREE.Group;
	var earthOrbit: THREE.Group;
	var earthGroup: THREE.Group;
	var moonGroup: THREE.Group;
	var sun: THREE.Mesh;
	var earth: THREE.Mesh;
	var moon: THREE.Mesh;

	var uniforms: any;
	var light: THREE.PointLight;

	var curTime = Date.now();

	// This function is called whenever the document is loaded
	function init() {
		// Get display canvas
		var canvas = document.getElementById('webglcanvas') as HTMLCanvasElement;
		console.log(canvas);

		// Create the Three.js renderer and attach it to our canvas
		renderer = new THREE.WebGLRenderer({
			canvas: canvas,
			antialias: true
		});
		renderer.shadowMap.enabled = true;
		// rendu coûteux mais plus joli (default: THREE.PCFShadowMap)
		renderer.shadowMap.type = THREE.PCFSoftShadowMap;

		// Set the viewport size
		renderer.setSize(canvas.width, canvas.height);
		// Create a new Three.js scene
		scene = new THREE.Scene();
		// Add  a camera so we can view the scene
		camera = new THREE.PerspectiveCamera(45, canvas.width / canvas.height, 1, 4000);

		// Add background
		var bg_urls = [posXMapUrl, negXMapUrl, posYMapUrl, negYMapUrl, posZMapUrl, negZMapUrl];

		var textureCube = new THREE.CubeTextureLoader().load(bg_urls);
		textureCube.format = THREE.RGBAFormat;
		scene.background = textureCube;

		// Add a white point light
		light = new THREE.PointLight(0xffffff, 1.5);
		light.castShadow = true;
		// On peut aussi paramétrer la qualité du calcul
		light.shadow.mapSize.width = 512; // default
		light.shadow.mapSize.height = 512; // default
		light.shadow.camera.near = 0.5; // default
		light.shadow.camera.far = 50;

		const textureLoader = new THREE.TextureLoader();

		uniforms = {
			uSunPos: { value: light.position },
			texture1: { value: textureLoader.load(earthMapUrl) },
			texture2: { value: textureLoader.load(earthEmissiveMapUrl) }
		};

		uniforms['texture1'].value.wrapS = uniforms['texture1'].value.wrapT = THREE.RepeatWrapping;
		uniforms['texture2'].value.wrapS = uniforms['texture2'].value.wrapT = THREE.RepeatWrapping;

		controls = new OrbitControls(camera, renderer.domElement);
		controls.enableDamping = true; // an animation loop is required when either damping or auto-rotation are enabled
		controls.dampingFactor = 0.25;
		controls.screenSpacePanning = false;
		controls.minDistance = 2;
		controls.maxDistance = 20;

		var moonMap = new THREE.TextureLoader().load(moonMapUrl);

		const earthMaterial = new THREE.ShaderMaterial({
			uniforms: uniforms,
			vertexShader: sunVertexShader,
			fragmentShader: sunFragmentShader
		});

		var sunMap = new THREE.TextureLoader().load(sunMapUrl);

		// // Now, create a Basic material; pass in the map
		var sunMaterial = new THREE.MeshBasicMaterial({ map: sunMap });
		sunMaterial.color = new THREE.Color('yellow');

		var moonMaterial = new THREE.MeshPhongMaterial({ map: moonMap });

		// Create the Sun geometry
		var sunGeometry = new THREE.SphereGeometry(2, 32, 16);

		sun = new THREE.Mesh(sunGeometry, sunMaterial);

		// Create the earth geometry
		var earthGeometry = new THREE.SphereGeometry(1, 32, 16);

		// And put the geometry and material together into a mesh
		earth = new THREE.Mesh(earthGeometry, earthMaterial);

		//Create the Moon geometry
		var moonGeometry = new THREE.SphereGeometry(0.2, 16, 8);

		moon = new THREE.Mesh(moonGeometry, moonMaterial);

		moon.position.x = 2;

		moonGroup = new THREE.Group();
		moonGroup.add(moon);

		earthGroup = new THREE.Group();
		earthGroup.add(earth);
		earthGroup.add(moonGroup);

		earthGroup.position.z = 5;

		earthOrbit = new THREE.Group();
		earthOrbit.add(earthGroup);

		sunGroup = new THREE.Group();
		sunGroup.add(sun);
		sunGroup.add(earthOrbit);

		earth.castShadow = true;
		earth.receiveShadow = true;
		moon.castShadow = true;
		moon.receiveShadow = true;

		//scene.add(light);
		sunGroup.add(light);

		// Finally, add the mesh to our scene
		scene.add(sunGroup);
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

		var angle = fracTime * Math.PI * 2;
		// Notez que l'axe y est l'axe "vertical" usuellement.
		earthOrbit.rotation.y += angle / 50; // la terre tourne en 365 jours
		earth.rotation.set(0, earth.rotation.y + angle / 28, 0); // et en un jour sur elle-même
		moonGroup.rotation.y += angle / 10; // la lune tourne en 28 jours autour de la terre
		moon.rotation.y += angle / 28; // et en 28 jours aussi sur elle-même pour faire face à la terre

		controls.update();
		controls.target = new THREE.Vector3().setFromMatrixPosition(earth.matrixWorld);
	}
	onMount(() => {
		init();
		run();
	});
</script>

<main id="container">
	<h1>Question 2</h1>
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
