using UnityEngine;
using System.Collections;

public class GiantHeadRoutine : MonoBehaviour {

	public Light[] lights;

	public float minCloseEyesTime;

	public float maxCloseEyesTime;

	public float minOpenEyesTime;

	public float maxOpenEyesTime;

	public bool IsWatching;

	private Animator anim;

	private float animTime;

	private void Start() {
		anim = GetComponent<Animator>();
		IsWatching = true;
		animTime = 1f;
		StartCoroutine("Routine");
	}

	public void TurnLightsOff() {
		ToggleLights(false);
	}

	public void TurnLightsOn() {
		ToggleLights(true);
	}

	private void ToggleLights(bool b) {
		for ( int i = 0; i < lights.Length; i++ ) {
			lights[i].enabled = b;
		}
		IsWatching = b;
	}

	private IEnumerator Routine() {
		float waitTime;

		while ( true ) {
			if ( IsWatching ) {
				waitTime = Random.Range(minOpenEyesTime, maxOpenEyesTime);
			} else {
				waitTime = Random.Range(minCloseEyesTime, maxCloseEyesTime);
			}

			yield return new WaitForSeconds(waitTime);

			ToggleEyes();

			yield return new WaitForSeconds(animTime);
		}
	}

	private void ToggleEyes() {
		anim.speed = 1f + (0.01f * ScoreManager.score);
		anim.SetBool("IsWatching", !IsWatching);
	}

}
