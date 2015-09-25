using UnityEngine;

public class GameOverManager : MonoBehaviour {

	public PlayerHealth playerHealth;

	private Animator anim;

	private void Awake() {
		anim = GetComponent<Animator>();
	}

	private void Update() {
		if ( !playerHealth.isAlive() ) {
			anim.SetTrigger("GameOver");
		}
	}
}
