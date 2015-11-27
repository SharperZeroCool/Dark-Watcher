using UnityEngine;
using System.Collections;

public abstract class CollectableBehaviour : MonoBehaviour {

	protected AudioSource audioSource;

	protected void Start () {
		audioSource = GetComponent<AudioSource>();
	}

	protected void OnTriggerEnter(Collider other) {
		if ( IsPlayer(other.gameObject.tag) ) {
			BeCollected();
		}
	}

	protected void OnTriggerExit(Collider other) {
		if ( IsPlayer(other.gameObject.tag) ) {
			BeCollected();
		}
	}

	protected abstract void BeCollected();

	protected abstract void Disable();

	private bool IsPlayer(string tag) {
		return tag == "Player";
	}

}
