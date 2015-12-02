using UnityEngine;
using System.Collections;

public class CoinBehaviour : CollectableBehaviour {

	public int score;

	protected override void BeCollected(GameObject player) {
		ScoreManager.score += score;
		audioSource.Play();
		CacheManager.DeSpawnGameObject(gameObject);
		Invoke("Disable", 0.5f);
	}

	protected override void Disable() {
		gameObject.SetActive(false);
	}

}
