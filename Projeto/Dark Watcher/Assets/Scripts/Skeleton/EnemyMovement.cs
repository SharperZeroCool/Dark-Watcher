using UnityEngine;
using System.Collections;

public class EnemyMovement : MonoBehaviour {

	public Transform target;

	private NavMeshAgent nav;

	private Rigidbody rigidBody;

	private Animator anim;

	private EnemyHealth enemyHealth;

	private void Start() {
		nav = GetComponent<NavMeshAgent>();
		anim = GetComponent<Animator>();
		enemyHealth = GetComponent<EnemyHealth>();
		rigidBody = GetComponent<Rigidbody>();
		if(target == null) {
			target = GameObject.FindGameObjectWithTag("Player").transform;
		}
	}

	private void Update() {
		if ( enemyHealth.IsDead() ) {
			return;

		}
		nav.SetDestination(target.position);

		if ( Vector3.Distance(transform.position, target.position) < 30f ) {
			nav.speed = 5;
			anim.SetBool("Move", true);
		} else {
			nav.speed = 1;
			anim.SetBool("Move", false);
		}
	}

	public void PushBack() {
		rigidBody.AddForce(transform.forward * -1, ForceMode.VelocityChange);
	}
}
