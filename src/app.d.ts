// See https://kit.svelte.dev/docs/types#app
// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		// interface Locals {}
		// interface PageData {}
		// interface Platform {}
	}
	declare module '*.glb' {
		const src: string;
		export default src;
	}

	declare module '*.ogg' {
		const src: string;
		export default src;
	}

	declare module '*glsl';

	declare module 'konami-code';
}

export { };
