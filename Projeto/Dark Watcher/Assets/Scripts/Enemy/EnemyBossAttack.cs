using UnityEngine;
using System.Collections;

public class EnemyBossAttack : MonoBehaviour {

	public GameObject particleHolder;

	public int attackDamage = 10;

	private Vector3[] positions = new Vector3[4];

	private void Awake() {
		positions[0] = Vector3.right + Vector3.forward * 0.5f;
		positions[1] = Vector3.left + Vector3.forward * 0.5f;
		positions[2] = Vector3.right + Vector3.up * 2 + Vector3.forward * 0.5f;
		positions[3] = Vector3.left + Vector3.up * 2 + Vector3.forward * 0.5f;
	}

	public void Attack() {
		StartCoroutine("MoveParticles");
		ParticleSystem[] particles = particleHolder.GetComponentsInChildren<ParticleSystem>();
		for ( int i = 0; i < particles.Length; i++ ) {
			particles[i].Play();
		}
	}

	public void TerminateAttack() {
		StopCoroutine("MoveParticles");
	}

	private IEnumerator MoveParticles() {
		while ( true ) {
			int random = Random.Range(0, positions.Length);
			particleHolder.transform.localPosition = positions[random];
			yield return new WaitForFixedUpdate();
		}
	}

}
