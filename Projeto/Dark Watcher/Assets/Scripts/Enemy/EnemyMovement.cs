using UnityEngine;
using System.Collections;

public class EnemyMovement : MonoBehaviour {

	public Transform target;

	public AudioSource attackSound;

	public float timeBetweenAttacks;

	public bool growl;

	public AudioSource growlSound;

	public float growlInterval;

	public float growlPercenteChance;

	public AudioSource[] stepSounds;

	private NavMeshAgent nav;

	private Animator anim;

	private EnemyHealth enemyHealth;

	private bool isAttacking;

	private float timer;

	private void Start() {
		nav = GetComponent<NavMeshAgent>();
		anim = GetComponent<Animator>();
		enemyHealth = GetComponent<EnemyHealth>();
		isAttacking = false;
		timer = 0f;
		if ( growl ) {
			StartCoroutine("Growl");
		}
	}

	private void Update() {
		if ( isAttacking ) {
			timer += Time.deltaTime;

			if ( timer >= timeBetweenAttacks ) {
				ResumeMoving();
				timer = 0f;
			}
			return;
		}
		if ( enemyHealth.IsDead() ) {
			return;

		}
		nav.SetDestination(target.position);

		RaycastHit hit;

		if ( Physics.Raycast(transform.position + Vector3.up, transform.forward, out hit, 10f) ) {
			if ( hit.transform.gameObject.tag == "Player" || hit.transform.gameObject.tag == "Player2" ) {
				StopMoving();
				anim.SetTrigger("Attack");

			}

		}

		FreezeXPosition();
	}

	public void playRandomStepSound() {
		int randomIndex = Random.Range(0, stepSounds.Length);
		SoundManager.instance.playAtRandomPitch(stepSounds[randomIndex]);
	}

	public void playAttackSound() {
		SoundManager.instance.playAtRandomPitch(attackSound);
	}

	private IEnumerator Growl() {
		while ( true ) {
			int random = Random.Range(0, 100);

			if ( random <= growlPercenteChance ) {
				growlSound.Play();
			}

			yield return new WaitForSeconds(growlInterval);
		}
	}

	private void StopMoving() {
		nav.Stop();
		isAttacking = true;
	}

	private void ResumeMoving() {
		nav.Resume();
		isAttacking = false;
	}

	private void FreezeXPosition() {
		Vector3 position = transform.position;
		position.x = 0;
		transform.position = position;
	}

}
