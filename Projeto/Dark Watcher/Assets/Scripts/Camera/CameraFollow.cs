using UnityEngine;
using System.Collections;

public class CameraFollow : MonoBehaviour {

	public Transform target;

	public bool useDefaultCameraOffset;

	public bool useMouseRotation;

	public bool useMouseZoom;

	public float mouseSmoothing = 5f;

	public float cameraMinimumZoomDistance = 50f;

	public float cameraMaximumZoomDistance = 200f;

	private Vector3 offset;

	private void Start() {
		Application.targetFrameRate = -1;
		if ( target == null ) {
			target = GameObject.FindGameObjectWithTag("Player").transform;
		}

		if ( useDefaultCameraOffset ) {
			transform.position = target.position + new Vector3(8, 6, 0);
			transform.LookAt(target.position + Vector3.up * 3);
		}

		offset = target.position - transform.position;

	}

	private void Update() {
		UpdateCameraZoom();

		UpdateCameraPosition();

		UpdateCameraRotation();

		UpdateCameraOffset();
	}

	private void UpdateCameraPosition() {
		transform.position = target.position - offset;
	}

	private void UpdateCameraRotation() {
		if ( useMouseRotation )
			transform.RotateAround(target.position, Vector3.up, Input.GetAxis("Mouse X") * mouseSmoothing);
	}

	private void UpdateCameraZoom() {
		if ( !useMouseZoom )
			return;

		float scrollWheel = Input.GetAxis("Mouse ScrollWheel");

		if ( ZoomIn(scrollWheel) ) {
			if ( offset.sqrMagnitude > cameraMinimumZoomDistance )
				offset *= 0.9f;

		} else if ( ZoomOut(scrollWheel) ) {
			if ( offset.sqrMagnitude < cameraMaximumZoomDistance )
				offset *= 1.1f;

		}
	}

	private void UpdateCameraOffset() {
		offset = target.position - transform.position;
	}

	private bool ZoomIn(float scrollWheel) {
		return scrollWheel > 0f;
	}

	private bool ZoomOut(float scrollWheel) {
		return scrollWheel < 0f;
	}

}

