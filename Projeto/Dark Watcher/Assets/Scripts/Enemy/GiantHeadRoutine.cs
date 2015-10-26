using UnityEngine;
using System.Collections;

public class GiantHeadRoutine : MonoBehaviour {

	public Light[] lights;

	public float minCloseEyesTime;

	public float maxCloseEyesTime;

	public float minOpenEyesTime;

	public float maxOpenEyesTime;

	public float rotationDuration = 1f;

	public bool IsWatching;

	private Quaternion fromRotation;

	private Quaternion toRotation;

	private float startRotationDuration;

	private void Start() {
		IsWatching = true;
		StartCoroutine("Routine");
		fromRotation = transform.rotation;
		toRotation = Quaternion.LookRotation(transform.forward * -1);
		startRotationDuration = rotationDuration;
    }

	private void FixedUpdate() {
		transform.rotation = Quaternion.Lerp(fromRotation, toRotation, Time.fixedDeltaTime * rotationDuration);
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

			ToggleSight();

			yield return new WaitForSeconds(rotationDuration);
		}
	}

	private void ToggleSight() {
		Quaternion rotation = toRotation;
		toRotation = fromRotation;
		fromRotation = rotation;
		rotationDuration = startRotationDuration - (0.01f * ScoreManager.score);
		IsWatching = !IsWatching;
    }

}
