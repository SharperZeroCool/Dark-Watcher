using UnityEngine;
using System.Collections;
using Colorful;

[RequireComponent(typeof(Camera))]
public class EffectsHandler : MonoBehaviour {

	public static EffectsHandler instance = null;

	private const bool ENABLED = true;

	private const bool DISABLED = false;

	private void Awake() {
		if ( instance == null ) {
			instance = this;

		} else if ( instance != this ) {
			Destroy(gameObject);

		}

		DontDestroyOnLoad(gameObject);

	}

	public void EnableDamageEffects() {
		SetDamageEffectsTo(ENABLED);
	}

	public void DisableDamageEffects() {
		SetDamageEffectsTo(DISABLED);
	}

	public void EnableProtectionEffects() {
		SetProtectionEffectsTo(ENABLED);
    }

	public void DisableProtectionEffects() {
		SetProtectionEffectsTo(DISABLED);
	}

	private void SetDamageEffectsTo(bool newState) {
		GetComponent<RadialBlur>().enabled = newState;
		GetComponent<LensDistortionBlur>().enabled = newState;
		GetComponent<GrainyBlur>().enabled = newState;
	}

	private void SetProtectionEffectsTo(bool newState) {
		GetComponent<AudioSource>().pitch = newState ? -0.5f : 1f;
		GetComponent<Wiggle>().enabled = newState;
		GetComponent<Technicolor>().enabled = newState;
	}

}
