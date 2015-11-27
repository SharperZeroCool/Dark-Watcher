using UnityEngine;

public class PlayerAttack : MonoBehaviour {

	public ParticleSystem[] attackParticles;

	public AudioSource attackAudioSource;

	public float damage;

	private Animator anim;

	private PlayerHealth playerHealth;

	private bool canAttack = true;

	private bool oddAttack = true;

	private void Start() {
		anim = GetComponent<Animator>();
		playerHealth = GetComponent<PlayerHealth>();
	}

	private void Update() {
		if ( Input.GetButton("Fire1") ) {
			if ( canAttack && Time.timeScale != 0 && playerHealth.unprotected ) {
				Attack();
			}
		}
	}

	public void AllowAttack() {
		canAttack = true;
	}

	private void Attack() {
		RaycastHit hit;

		if ( Physics.Raycast(transform.position, transform.forward, out hit, 5f) ) {
			if ( hit.transform.gameObject.tag == "Enemy Boss" || hit.transform.gameObject.tag == "Enemy Mage" ) {
				hit.transform.gameObject.GetComponent<EnemyHealth>().TakeDamage(damage, hit.transform.position);
				if ( hit.transform.gameObject.tag == "Enemy Boss" ) {
					ScoreManager.score += 10;
				} else {
					ScoreManager.score += 5;
				}

			}

		}

		SoundManager.instance.playAtRandomPitch(attackAudioSource);
		playAnimation();
		canAttack = false;
	}

	private void playAnimation() {
		if ( oddAttack ) {
			anim.SetTrigger("Attack First");
			for ( int i = 0; i < attackParticles.Length; i++ ) {
				attackParticles[i].Play();
				/*ParticleSystem.Particle[] myArray = new ParticleSystem.Particle[attackParticles[i].particleCount];
				int count = attackParticles[i].GetParticles(myArray);
				for ( int j = 0; j < count; j++ ) {
					myArray[j].axisOfRotation = Vector3.forward;
				}*/
			}
		} else {
			anim.SetTrigger("Attack Second");
			for ( int i = 0; i < attackParticles.Length; i++ ) {
				attackParticles[i].Play();
				/*ParticleSystem.Particle[] myArray = new ParticleSystem.Particle[attackParticles[i].particleCount];
				int count = attackParticles[i].GetParticles(myArray);
				for ( int j = 0; j < count; j++ ) {
					myArray[j].axisOfRotation = Vector3.forward;
				}*/
			}
		}
		oddAttack = !oddAttack;

	}

}
