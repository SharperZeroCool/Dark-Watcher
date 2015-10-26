using UnityEngine;
using System.Collections;

public class CollectableBehaviour : MonoBehaviour {

	public int score;

	private AudioSource audioSource;

	private BoxCollider boxCollider;

	private MeshRenderer mesh;

	void Start () {
		audioSource = GetComponent<AudioSource>();
		boxCollider = GetComponent<BoxCollider>();
		mesh = GetComponentInChildren<MeshRenderer>();
	}

	private void OnTriggerEnter(Collider other) {
		if ( IsPlayer(other.gameObject.tag) ) {
			CollectCoin();
		}
	}

	private void OnTriggerExit(Collider other) {
		if ( IsPlayer(other.gameObject.tag) ) {
			CollectCoin();
		}
	}

	private void CollectCoin() {
		ScoreManager.score += score;
		audioSource.Play();
		boxCollider.enabled = false;
		mesh.enabled = false;
		Invoke("DisableCoin", 0.5f);
	}
	
	private void DisableCoin() {
		gameObject.SetActive(false);
	}

	private bool IsPlayer(string tag) {
		return tag == "Player";
	}

}
