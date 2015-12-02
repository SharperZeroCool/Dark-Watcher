using UnityEngine;
using System.Collections;

public abstract class CollectableBehaviour : MonoBehaviour {

	protected AudioSource audioSource;

	protected void Start () {
		audioSource = GetComponent<AudioSource>();
	}

	protected void OnTriggerEnter(Collider other) {
		if ( IsPlayer1(other.gameObject.tag) || IsPlayer2(other.gameObject.tag) ) {
			BeCollected(other.gameObject);
		}
	}

	protected void OnTriggerExit(Collider other) {
		if ( IsPlayer1(other.gameObject.tag) || IsPlayer2(other.gameObject.tag) ) {
			BeCollected(other.gameObject);
		}
	}

	protected abstract void BeCollected(GameObject player);

	protected abstract void Disable();

	protected bool IsPlayer1(string tag) {
		return tag == "Player";
	}

	protected bool IsPlayer2(string tag) {
		return tag == "Player2";
	}

}
