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
</script>

<main id="container">
	<h1>INFO804 TP3 FERNANDEZ Volodia</h1>
	<div id="button-list">
		<a href="/q1"><button>Q1</button></a>
		<a href="/q2"><button>Q2</button></a>
	</div>
</main>

<style>
	#container {
		display: flex;
		flex-direction: column;
		width: 100%;
		align-items: center;
		justify-content: center;
	}

	#button-list {
		background-color: white;
		padding: 20px;
		border-radius: 5px;
		display: flex;
		flex-direction: column;
		align-items: space-between;
	}

	@media(prefers-color-scheme: light) {
		#button-list {
			height: 100px;
			background-color: #213547;
			justify-content: space-between;
		}
	}
</style>
