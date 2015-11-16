using UnityEngine;
using System.Collections;

public class CameraFollow : MonoBehaviour {

	public Transform target;

	public bool useDefaultCameraOffset;

	public bool useMouseRotation;

	public bool useMouseZoom;

	public bool updateCameraTargetVerticalOffset;

	public float mouseSmoothing = 5f;

	public float cameraMinimumZoomDistance = 50f;

	public float cameraMaximumZoomDistance = 200f;

	public float cameraTargetVerticalOffset = 3f;

	private Vector3 offset;

	private void Start() {
		Application.targetFrameRate = -1;
		if ( target == null ) {
			target = GameObject.FindGameObjectWithTag("Player").transform;
		}

		if ( useDefaultCameraOffset ) {
			transform.position = target.position + new Vector3(12, 2.5f, 0);
			LookAtSubject();
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
		LookAtSubject();
	}

	private void UpdateCameraZoom() {
		if ( !useMouseZoom )
			return;

		float scrollWheel = Input.GetAxis("Mouse ScrollWheel");

		if ( ZoomIn(scrollWheel) ) {
			if ( CanZoomIn() ) {
				float cameraZoom = 0.9f;
				offset *= cameraZoom;

				if ( TooMuchZoom() ) {
					cameraZoom = CalculateExcessZoom();
					offset *= cameraZoom;

				} else if ( updateCameraTargetVerticalOffset ) {
					cameraTargetVerticalOffset *= CalculateCameraTargetVerticalOffset(cameraZoom);
				}
			}

		} else if ( ZoomOut(scrollWheel) ) {
			if ( CanZoomOut() ) {
				float cameraZoom = 1.1f;
				offset *= cameraZoom;

				if ( TooLittleZoom() ) {
					cameraZoom = CalculateMissingZoom();
					offset *= cameraZoom;

				} else if ( updateCameraTargetVerticalOffset ) {
					cameraTargetVerticalOffset *= CalculateCameraTargetVerticalOffset(cameraZoom);
				}
			}


		}
	}

	private void UpdateCameraOffset() {
		offset = target.position - transform.position;
	}

	private void LookAtSubject() {
		transform.LookAt(target.position + Vector3.up * cameraTargetVerticalOffset);
	}

	private bool ZoomIn(float scrollWheel) {
		return scrollWheel > 0f;
	}

	private bool ZoomOut(float scrollWheel) {
		return scrollWheel < 0f;
	}

	private bool CanZoomIn() {
		return offset.sqrMagnitude > cameraMinimumZoomDistance;
	}

	private bool CanZoomOut() {
		return offset.sqrMagnitude < cameraMaximumZoomDistance;
	}

	private bool TooMuchZoom() {
		return !CanZoomIn();
	}

	private bool TooLittleZoom() {
		return !CanZoomOut();
	}

	private float CalculateCameraTargetVerticalOffset(float cameraZoom) {
		return 1 - (1 - cameraZoom) / 2;
	}

	private float CalculateExcessZoom() {
		return (1 - offset.sqrMagnitude / cameraMinimumZoomDistance) / 2 + 1;
	}

	private float CalculateMissingZoom() {
		return (1 - offset.sqrMagnitude / cameraMaximumZoomDistance) / 2 + 1;
	}

}

