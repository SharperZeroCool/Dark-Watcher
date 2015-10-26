using UnityEngine;
using System.Collections;

public class EnemyHealth : MonoBehaviour {

	public int startingHealth = 100;

	public float currentHealth;

	public float sinkSpeed = 2.5f;

	//public AudioClip deathClip;

	private EnemyMovement enemyMovement;

	//private Animator anim;

	private AudioSource[] enemyAudio;

	//private ParticleSystem hitParticles;

	//private ParticleSystem deathParticles;

	private CapsuleCollider capsuleCollider;

	private Rigidbody enemyRigidBody;

	private bool isSinking;

	private void Awake() {
		//anim = GetComponent <Animator> ();
		enemyAudio = GetComponents <AudioSource> ();
		//hitParticles = GetComponentInChildren <ParticleSystem> ();
		capsuleCollider = GetComponent<CapsuleCollider>();
		enemyMovement = GetComponent<EnemyMovement>();
		currentHealth = startingHealth;
		enemyRigidBody = GetComponent<Rigidbody>();

	}


	private void Update() {
		if ( isSinking ) {
			transform.Translate(-Vector3.up * sinkSpeed * Time.deltaTime);
		}
	}

	public void StartSinking() {
		isSinking = true;
	}

	public void TakeDamage(float amount, Vector3 hitPoint) {
		if ( IsDead() ) {
			return;

		}

		SoundManager.instance.playAtRandomPitch(enemyAudio[Random.Range(0, enemyAudio.Length - 1)]);

		//hitParticles.transform.position = hitPoint;

		//hitParticles.Play();

		Death();


	}

	public bool IsDead() {
		return currentHealth <= 0;
	}

	private IEnumerator PushBack(Vector3 target) {

		Vector3 pushBack = transform.position - (target - transform.position) * 4;

		pushBack.y = 0;

		float overTime = 0.3f;

		float startTime = Time.time;

		while ( Time.time < startTime + overTime ) {
			transform.position = Vector3.Lerp(transform.position, pushBack, (Time.time - startTime) / overTime);
			yield return null;
		}
		transform.position = pushBack;

	}

	private void Death() {
		GetComponent<NavMeshAgent>().enabled = false;
		GetComponent<EnemyAttack>().enabled = false;
		GetComponent<EnemyMovement>().enabled = false;
		capsuleCollider.enabled = false;
		enemyRigidBody.isKinematic = true;
		StartSinking();
		Invoke("Disable", 2f);
	}

	private void Disable() {
		gameObject.SetActive(false);
	}

}
