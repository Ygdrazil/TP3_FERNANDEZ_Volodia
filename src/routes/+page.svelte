<script lang="ts">
	import KeySequence from '$lib/KeySequence';
	import { goto } from '$app/navigation';

	const konamiCode = new KeySequence(
		[
			'ArrowUp',
			'ArrowUp',
			'ArrowDown',
			'ArrowDown',
			'ArrowLeft',
			'ArrowRight',
			'ArrowLeft',
			'ArrowRight',
			'b',
			'a'
		],
		() => {
			goto('/dingus');
		}
	);

	$: sequence = konamiCode.current_sequence;
</script>

<h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>
