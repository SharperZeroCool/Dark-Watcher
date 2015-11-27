using UnityEngine;
using System.Collections;
using ParticlePlayground;

public class EnemyAttack : MonoBehaviour {

	public PlaygroundParticlesC particles;

	public int attackDamage = 3;

	public void Attack() {
		particles.enabled = true;
		StartCoroutine("DealDamage");
	}

	public void TerminateAttack() {
		particles.enabled = false;
		StopCoroutine("DealDamage");
	}

	private IEnumerator DealDamage() {
		while ( true ) {
			RaycastHit hit;

			if ( Physics.Raycast(transform.position + Vector3.up, transform.forward, out hit, 10f) ) {
				if ( hit.transform.gameObject.tag == "Player" ) {
					hit.transform.gameObject.GetComponent<PlayerHealth>().TakeDamage(attackDamage, false);
				}

			}
			yield return new WaitForFixedUpdate();
		}
	}

}
