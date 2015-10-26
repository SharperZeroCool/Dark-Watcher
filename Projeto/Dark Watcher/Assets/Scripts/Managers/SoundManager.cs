using UnityEngine;

public class SoundManager : MonoBehaviour {

	public static SoundManager instance = null;

	public float lowPitchRange = 0.85f;

	public float highPitchRange = 1.15f;

	private void Awake() {
		if ( instance == null ) {
			instance = this;

		} else if ( instance != this ) {
			Destroy(gameObject);

		}

		DontDestroyOnLoad(gameObject);

	}

	public void playAtRandomPitch(AudioSource source) {
		playAtRandomPitch(source, lowPitchRange, highPitchRange);
	}

	public void playAtRandomPitch(AudioSource source, float lowPitchRange, float highPitchRange) {
		float randomPitch = Random.Range(lowPitchRange, highPitchRange);
		playAtPitch(source, randomPitch);
	}

	public void playAtPitch(AudioSource source, float pitch) {
		if ( source == null ) {

			return;
		}

		source.pitch = pitch;
		source.Play();

	}

}
