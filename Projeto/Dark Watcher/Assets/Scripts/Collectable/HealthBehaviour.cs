using UnityEngine;
using System.Collections;

public class HealthBehaviour : CollectableBehaviour {

	public int healthPoints;

	protected override void BeCollected(GameObject player) {
		if ( IsPlayer1(player.tag) ) {
			player.GetComponent<PlayerHealth>().HealDamage(healthPoints);
		} else if ( IsPlayer2(player.tag) ) {
			player.GetComponent<Player2Health>().HealDamage(healthPoints);
		}
		SoundManager.instance.playAtRandomPitch(audioSource);
		CacheManager.DeSpawnGameObject(gameObject);
		Invoke("Disable", 0.5f);
	}

	protected override void Disable() {
		gameObject.SetActive(false);
	}

}
