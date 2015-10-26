using UnityEngine;
using System.Collections;

public class EnemyAttack : MonoBehaviour {

	public float timeBetweenAttacks = 0.5f;

	public int attackDamage = 10;

	private GameObject player;

	private PlayerHealth playerHealth;

	private EnemyHealth enemyHealth;

	private bool playerInRange;

	private float timer;

	private void Awake() {
		player = GameObject.FindGameObjectWithTag("Player");
		playerHealth = player.GetComponent<PlayerHealth>();
		enemyHealth = GetComponent<EnemyHealth>();
	}

	private void Update() {
		timer += Time.deltaTime;
		if ( timer >= timeBetweenAttacks && playerInRange && enemyHealth.currentHealth > 0 ) {
			Attack();
		}

	}

	private void Attack() {
		timer = 0f;

		if ( playerHealth.currentHealth > 0 && playerHealth.unprotected) {
			playerHealth.TakeDamage(attackDamage, false);
		}
	}


	private void OnCollisionEnter(Collision other) {
		if ( other.gameObject == player ) {
			playerInRange = true;
		}
	}


	private void OnCollisionExit(Collision other) {
		if ( other.gameObject == player ) {
			playerInRange = false;
		}
	}

}
