using UnityEngine;
using System.Collections;

public class CCPlayerMovement2D : CCPlayerMovement {

	private void Update() {
		bool jumpPressed = Input.GetButtonDown("Jump");

		if ( jumpPressed && IsAllowedToJump() ) {
			jump = true;
			hasDoubleJumped = false;
		} else if ( jumpPressed && IsAllowedToDoubleJump() ) {
			doubleJump = true;
			hasDoubleJumped = true;
		}

	}

	private void FixedUpdate() {

		ResetFrameVariables();

		FreezeXPosition();

		if ( !HasHorizontalMovement() && characterController.isGrounded ) {
			SlowDownGround();

		}

		horizontalAxis = Input.GetAxisRaw("Horizontal");
		verticalAxis = Input.GetAxisRaw("Vertical");
		jumpButton = Input.GetButton("Jump");
		runningButton = Input.GetButton("Sprint");

		if( !IsShielded() ) {

			Move();
			Flip();
			Jump();

		}
		

		if ( ShouldApplyGravity() ) {
			Gravity();
		}

		if ( characterController.isGrounded ) {
			hasDoubleJumped = false;
		}

		LimitHorizontalSpeed();
		LimitVerticalSpeed();

		characterController.Move(movement * Time.fixedDeltaTime);

		Animate();

	}

	private void Move() {
		if ( isInWater || isInWaterSurface ) {
			Swim();
			return;
		}

		if ( characterController.isGrounded ) {
			GroundMovement();
		} else {
			AirMovement();
		}

	}

	private void Flip() {
		if ( HasHorizontalMovement() ) {
			float ratio = horizontalAxis + transform.forward.z;

			if ( ratio >= -1 && ratio <= 1 ) {
				Quaternion rotation = Quaternion.LookRotation(transform.forward * -1);
				transform.rotation = rotation;

				movement.z = 0;
			}
		}
	}

	private void Gravity() {
		movement.y -= gravity * Time.fixedDeltaTime;
	}

	private void LimitHorizontalSpeed() {
		float maxSpeed;

		if ( runningButton ) {
			maxSpeed = base.maxRunningSpeed;
		} else {
			maxSpeed = base.maxSpeed;
		}

		if ( isInWater || isInWaterSurface ) {
			maxSpeed = base.maxSwimSpeed;
		} else if ( !characterController.isGrounded ) {
			maxSpeed = base.maxMidAirSpeed;
		}


		if ( Mathf.Abs(movement.z) > maxSpeed ) {
			movement.z = maxSpeed * transform.forward.z;
		}
	}

	private void LimitVerticalSpeed() {
		if ( IsGrabbingWall() && movement.y < maxSlideDownSpeed ) {
			movement.y += slideDownSpeed * Time.fixedDeltaTime;
			if ( movement.y >= maxSlideDownSpeed ) {
				movement.y = maxSlideDownSpeed;
			}
		}
	}

	private void Swim() {
		if ( HasHorizontalMovement() ) {
			HorizontalMovement(swimHorizontalSpeed);
		} else {
			SlowDownHorizontalSpeedSwim();
		}

		if ( HasVerticalMovement() ) {
			if ( !isInWater && verticalAxis > 0 ) {
				return;
			}
			VerticalMovement(swimVerticalSpeed);
		} else {
			SlowDownVerticalSpeed();
		}

	}

	private void GroundMovement() {
		float speed;

		movement.y = 0;

		if ( runningButton ) {
			speed = base.runningSpeed;
		} else {
			speed = base.speed;
		}

		HorizontalMovement(speed);

	}

	private void AirMovement() {
		if ( !HasHorizontalMovement() ) {
			SlowDownHorizontalSpeedMidAir();
			return;

		}

		movement.z += horizontalAxis * Time.fixedDeltaTime * midAirMovSpeed;
	}

	private void SlowDownHorizontalSpeedSwim() {
		SlowDownHorizontalSpeed(waterMovementLost);
	}

	private void SlowDownHorizontalSpeedMidAir() {
		if ( Mathf.Abs(movement.z) > 1 ) {
			SlowDownHorizontalSpeed(mirAirMovementLost);
		}
	}

	private void SlowDownHorizontalSpeed(float amount) {
		movement.z -= movement.z / Mathf.Abs(movement.z) * Time.fixedDeltaTime * amount;
	}

	private void SlowDownVerticalSpeed() {
		if ( Mathf.Abs(movement.y) > 1 ) {
			movement.y -= movement.y / Mathf.Abs(movement.y) * Time.fixedDeltaTime * midAirMovSpeed;
		}
	}

	private void SlowDownGround() {
		movement.z = 2 * transform.forward.z * Time.fixedDeltaTime;
	}

	private void HorizontalMovement(float speed) {
		movement.z += horizontalAxis * speed;
	}

	private void VerticalMovement(float speed) {
		movement.y += verticalAxis * speed;
	}

	private void FreezeXPosition() {
		Vector3 position = transform.position;
		position.x = 0;
		transform.position = position;
	}
}
