using UnityEngine;
using System.Collections;

public class EnemyBackgroundMovement : MonoBehaviour {

	public Transform[] targets;

	private NavMeshAgent nav;

	private Animator anim;

	private Transform currentTarget;

	private bool isAttacking;

	private float timer;

	private void Start() {
		nav = GetComponent<NavMeshAgent>();
		anim = GetComponent<Animator>();
		isAttacking = false;
		timer = 0f;
		ChooseNewTarget();
	}

	private void Update() {
		if ( isAttacking ) {
			timer += Time.deltaTime;

			if ( timer >= 1.1f ) {
				ResumeMoving();
				timer = 0f;
			}
			return;
		}
		nav.SetDestination(currentTarget.position);

		if ( HasArrived() ) {
			StopMoving();
			anim.SetTrigger("Attack");
			ChooseNewTarget();
		}
	}

	private void ChooseNewTarget() {
		int randomIndex = 0;
		do {
			randomIndex = Random.Range(0, targets.Length);
		} while ( currentTarget == targets[randomIndex] );
		currentTarget = targets[randomIndex];
	}

	private bool HasArrived() {
		return Vector3.Distance(transform.position, currentTarget.position) < 20f;
	}

	private void StopMoving() {
		nav.Stop();
		isAttacking = true;
	}

	private void ResumeMoving() {
		nav.Resume();
		isAttacking = false;
	}

}
