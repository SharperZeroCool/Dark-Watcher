using UnityEngine;

public class PlayerShooting : MonoBehaviour {

	public float damage;

	private Animator anim;

	private AudioSource attackAudioSource;

	private bool canAttack = true;

	private bool oddAttack = true;

	private void Start() {
		anim = GetComponent<Animator>();
		AudioSource[] sources = GetComponents<AudioSource>();
		for ( int i = 0; i < sources.Length; i++ ) {
			if ( sources[i].clip.name == "Attack" ) {
				attackAudioSource = sources[i];
			}
		}
	}

	private void Update() {
		if ( Input.GetButton("Fire1") ) {
			if ( canAttack && Time.timeScale != 0 ) {
				Attack();
			}
		}
	}

	private void Attack() {
		RaycastHit hit;

		if ( Physics.Raycast(transform.position, transform.forward, out hit, 5f) ) {
			if ( hit.transform.gameObject.tag == "Skeleton" ) {
				hit.transform.gameObject.GetComponent<EnemyHealth>().TakeDamage(damage, hit.transform.position);
				ScoreManager.score += 5;
			}

		}

		SoundManager.instance.playAtRandomPitch(attackAudioSource);
		playAnimation();
		canAttack = false;
	}

	private void playAnimation() {
		if ( oddAttack ) {
			anim.SetTrigger("Attack First");
		} else {
			anim.SetTrigger("Attack Second");
		}
		oddAttack = !oddAttack;

	}

	public void AllowAttack() {
		canAttack = true;
	}

}
