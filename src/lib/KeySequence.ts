import { browser } from '$app/environment';

export default class KeySequence {
	private key_sequence: string[];
	private completion_function: () => void;
    current_sequence: string[];

	constructor(key_sequence: string[], completion_function: () => void) {
		this.key_sequence = key_sequence;
		this.current_sequence = new Array(this.key_sequence.length);

        this.completion_function = completion_function;

		if (browser) {
            // https://stackoverflow.com/a/59827112
			document.onkeydown = (event) => {
				this.current_sequence.shift(); // remove the oldest item from the start of the array
				this.current_sequence.push(event.key); // push the newest item to the end
				if (this.compareSequences(key_sequence, this.current_sequence)) this.completion_function();
			};
		}
	}

    // https://stackoverflow.com/a/59827112
	private compareSequences = (seq1: string[], seq2: string[]) => {
		if (seq1.length !== seq2.length) return false;
		for (let i = 0; i < seq1.length; i++) {
			if (seq1[i] !== seq2[i]) return false;
		}
		return true;
	};
}
