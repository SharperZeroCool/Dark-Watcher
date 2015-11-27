using UnityEngine;
using System.Collections;

public class HealthBehaviour : CollectableBehaviour {

	public PlayerHealth playerHealth;

	public int healthPoints;

	protected override void BeCollected() {
		playerHealth.HealDamage(healthPoints);
		SoundManager.instance.playAtRandomPitch(audioSource);
		CacheManager.DeSpawnGameObject(gameObject);
		Invoke("Disable", 0.5f);
	}

	protected override void Disable() {
		gameObject.SetActive(false);
	}

}
