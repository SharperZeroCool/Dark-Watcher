using UnityEngine;

public class GameOverManager : MonoBehaviour {

	public PlayerHealth playerHealth;

	public Player2Health player2Health;

	private Animator anim;

	public void RestartLevel() {
		Application.LoadLevel(Application.loadedLevel);
	}

	private void Awake() {
		anim = GetComponent<Animator>();
	}

	private void Update() {
		if ( !playerHealth.isAlive() || !player2Health.isAlive() ) {
			anim.SetTrigger("GameOver");
		}
	}
}
