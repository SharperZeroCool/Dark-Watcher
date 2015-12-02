using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Camera))]
public class CameraFollow : MonoBehaviour {

	public Transform[] targets;

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
		Application.targetFrameRate = 120;


		if ( useDefaultCameraOffset ) {
			transform.position = GetTarget() + new Vector3(18, 2.5f, 0);
			LookAtSubject();
		}

		offset = GetTarget() - transform.position;

	}

	private void Update() {
		UpdateCameraZoom();

		UpdateCameraPosition();

		UpdateCameraRotation();

		UpdateCameraOffset();
	}

	private void UpdateCameraPosition() {
		transform.position = GetTarget() - offset;
	}

	private void UpdateCameraRotation() {
		if ( useMouseRotation )
			transform.RotateAround(GetTarget(), Vector3.up, Input.GetAxis("Mouse X") * mouseSmoothing);
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
		offset = GetTarget() - transform.position;
	}

	private void LookAtSubject() {
		transform.LookAt(GetTarget() + Vector3.up * cameraTargetVerticalOffset);
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

	private Vector3 GetTarget() {
		Vector3 target = Vector3.zero;

		CheckForNewGame();

		for ( int i = 0; i < targets.Length; i++ ) {
			target += targets[i].position;
		}
		target /= targets.Length;
		return target;
	}

	private void CheckForNewGame() {
		bool newGame = false;
		if(targets[0] == null || targets[1] == null) {
			newGame = true;
		}
		if ( newGame ) {
			targets[0] = GameObject.FindGameObjectWithTag("Player").transform;
			targets[1] = GameObject.FindGameObjectWithTag("Player2").transform;
		}
	}

}

