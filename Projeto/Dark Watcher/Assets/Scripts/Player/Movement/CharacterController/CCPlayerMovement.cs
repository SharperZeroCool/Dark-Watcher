using UnityEngine;
using System.Collections;

public class CCPlayerMovement : MonoBehaviour {

	public float speed = 0.3f;

	public float runningSpeed = 0.5f;

	public float midAirSpeed = 5f;

	public float mirAirMovementLost = 5f;

	public float wallJumpSpeed = 15f;

	public float slideDownSpeed = 80f;

	public float swimHorizontalSpeed = 0.5f;

	public float swimVerticalSpeed = 2f;

	public float waterMovementLost = 10f;

	public float maxSpeed = 10f;

	public float maxRunningSpeed = 18f;

	public float maxMidAirSpeed = 12f;

	public float maxSlideDownSpeed = -5f;

	public float maxSwimSpeed = 4f;

	public float jumpHeight = 10f;

	public float normalGravity = 20f;

	public float jumpGravity = 9.8f;

	protected Vector3 movement;

	protected CharacterController characterController;

	protected float horizontalAxis;

	protected float verticalAxis;

	protected bool jumpButton;

	protected bool jump;

	protected bool doubleJump;

	protected bool hasDoubleJumped;

	protected bool runningButton;

	protected float midAirMovSpeed;

	protected float gravity;

	protected bool isInWater;

	protected bool isInWaterSurface;

	protected bool canCheckForLanding;

	private Vector3 jumpDirection;

	private Animator anim;

	private bool isFacingWall;

	private void Start() {
		movement = Vector3.zero;
		characterController = GetComponent<CharacterController>();
		anim = GetComponent<Animator>();
		jumpDirection = Vector3.up;
		isInWater = false;
		isInWaterSurface = false;
		midAirMovSpeed = midAirSpeed;
		gravity = normalGravity;
	}

	protected void Jump() {
		if ( jump || doubleJump ) {
			jump = false;
			doubleJump = false;

			movement.y = jumpDirection.y * jumpHeight;

			if ( IsGrabbingWall() ) {
				movement.z = jumpDirection.z;
			} else {
				movement.z += jumpDirection.z;
			}


			isFacingWall = false;
			isInWaterSurface = false;

			JumpAnimation();

			Invoke("CheckForLanding", 0.8f);

		}

		if ( jumpButton ) {
			gravity = jumpGravity;
		} else {
			gravity = normalGravity;
		}

		jumpDirection = Vector3.up;

	}

	protected void JumpAnimation() {
		canCheckForLanding = false;
        anim.SetTrigger("Jump");
	}

	protected void LandAnimation() {
		canCheckForLanding = false;
        anim.SetTrigger("Grounded");
	}

	protected void ResetFrameVariables() {
		isFacingWall = Physics.Raycast(transform.position, transform.forward, 1);
	}

	protected bool HasHorizontalMovement() {
		return horizontalAxis != 0 && !IsShielded();
	}

	protected bool HasVerticalMovement() {
		return verticalAxis != 0 && !IsShielded();
	}

	protected bool IsAllowedToJump() {
		return characterController.isGrounded || IsGrabbingWall() || isInWaterSurface;
	}

	protected bool IsAllowedToDoubleJump() {
		return !jump && !hasDoubleJumped && !isInWater && !characterController.isGrounded;
	}

	protected bool ShouldApplyGravity() {
		return !isInWater && !isInWaterSurface;
	}

	protected bool IsGrabbingWall() {
		return isFacingWall && HasHorizontalMovement();
	}

	protected bool IsShielded() {
		return Input.GetButton("Fire2");
	}

	protected void Animate() {
		bool isWalking = HasHorizontalMovement();
		if ( isWalking ) {
			if ( runningButton ) {
				anim.speed = 1.5f;
			} else {
				anim.speed = 1f;
			}
		}
		anim.SetBool("IsWalking", isWalking);
	}

	private void OnControllerColliderHit(ControllerColliderHit other) {
		if ( other.gameObject.tag == "Wall" ) {

			isFacingWall = Physics.Raycast(transform.position, transform.forward, 1);

			if ( IsGrabbingWall() ) {
				jumpDirection = Vector3.up * 0.9f + transform.forward * -6;
				midAirMovSpeed = wallJumpSpeed;
			}

		} else {
			midAirMovSpeed = midAirSpeed;
		}
	}

	private void OnTriggerEnter(Collider other) {
		if ( other.gameObject.tag == "Water" ) {
			movement *= 0.2f;
			isInWater = true;
		}

	}

	private void OnTriggerStay(Collider other) {
		if ( other.gameObject.tag == "Water" ) {
			movement.y = 0.4f;
			isInWater = true;
		}
	}

	private void OnTriggerExit(Collider other) {
		if ( other.gameObject.tag == "Water" ) {
			movement.y = 0;
			isInWater = false;
			isInWaterSurface = true;
		}
	}

	private void CheckForLanding() {
		canCheckForLanding = true;
	}


}
