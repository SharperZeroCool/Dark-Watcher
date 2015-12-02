using UnityEngine;
using System.Collections;

public class MoonMovement : MonoBehaviour {

	private Transform target;

	private void Start() {
		target = Camera.main.transform;
	}

	void FixedUpdate() {
		Vector3 targetPosition = target.position;
		Vector3 currentPosition = transform.position;
		transform.position = new Vector3(currentPosition.x, targetPosition.y + 170, targetPosition.z - 95);
	}

}
