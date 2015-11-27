using UnityEngine;
using System.Collections;

public class MoonRoutine : MonoBehaviour {

	public Light[] lights;

	public float minCloseEyesTime = 5f;

	public float maxCloseEyesTime = 12f;

	public float minOpenEyesTime = 2f;

	public float maxOpenEyesTime = 6f;

	public float initialRotationDuration = 1f;

	public float initialRotationLength = 1f;

	public bool IsWatching;

	private Animator anim;

	private float rotationDuration;

	private bool useOpenEyesTime;

	private void Start() {
		anim = GetComponent<Animator>();
		rotationDuration = initialRotationDuration;
		useOpenEyesTime = false;
		StartCoroutine("Routine");
	}

	private IEnumerator Routine() {
		float waitTime;

		while ( true ) {
			if ( useOpenEyesTime ) {
				waitTime = Random.Range(minOpenEyesTime, maxOpenEyesTime);
			} else {
				waitTime = Random.Range(minCloseEyesTime, maxCloseEyesTime);
			}

			yield return new WaitForSeconds(waitTime);

			ToggleSight();

			useOpenEyesTime = !useOpenEyesTime;

			yield return new WaitForSeconds(initialRotationLength / rotationDuration);

		}
	}

	private void ToggleSight() {
		rotationDuration = initialRotationDuration + (0.01f * ScoreManager.score);
		anim.speed = rotationDuration;
		anim.SetBool("IsWatching", IsWatching);
	}

	private void ToggleLights() {
		IsWatching = !IsWatching;
	}

}
