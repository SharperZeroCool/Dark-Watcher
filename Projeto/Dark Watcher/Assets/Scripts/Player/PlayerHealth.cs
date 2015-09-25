using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using UnityStandardAssets.ImageEffects;

public class PlayerHealth : MonoBehaviour {

	public Material protectedMaterial;

	public Transform[] eyes;

	public GiantHeadRoutine routine;

	public Slider healthSlider;

	public Image damageImage;

	public Color flashColour = new Color(1f, 0f, 0f, 0.01f);

	public AudioSource audioSource;

	public int startingHealth = 100;

	public float currentHealth;

	public float flashSpeed = 5f;

	private Dictionary<SkinnedMeshRenderer, Material[]> meshMaterialMap = new Dictionary<SkinnedMeshRenderer, Material[]>();

	private SkinnedMeshRenderer[] meshes;

	private Animator anim;

	private CCPlayerMovement2D playerMovement;

	private ParticleSystem particles;

	private bool deathTriggered;

	private bool damaged;

	private bool unprotected;

	private bool hasPlayedAudio;

	private void Awake() {
		anim = GetComponent<Animator>();
		playerMovement = GetComponent<CCPlayerMovement2D>();
		particles = GetComponentInChildren<ParticleSystem>();
		meshes = GetComponentsInChildren<SkinnedMeshRenderer>();

		for ( int i = 0; i < meshes.Length; i++ ) {
			meshMaterialMap[meshes[i]] = meshes[i].materials;
		}

		currentHealth = startingHealth;
		damageImage.color = Color.clear;
		damaged = false;
		unprotected = true;
		hasPlayedAudio = false;
	}

	private void FixedUpdate() {
		CheckIfProtected();

		CheckIfUnderSight();
		if ( damaged && isAlive() ) {
			if ( !hasPlayedAudio ) {
				audioSource.Play();
				hasPlayedAudio = true;
				Camera.main.GetComponent<ScreenOverlay>().enabled = true;
			}
			damageImage.color = flashColour;
		} else {
			hasPlayedAudio = false;
			damageImage.color = Color.Lerp(damageImage.color, Color.clear, flashSpeed * Time.deltaTime);
			Camera.main.GetComponent<ScreenOverlay>().enabled = false;
		}
		damaged = false;
	}

	public void RestartLevel() {
		Application.LoadLevel(Application.loadedLevel);
	}

	public bool isAlive() {
		return currentHealth > 0;
	}

	private void CheckIfProtected() {
		unprotected = !Input.GetButton("Fire2");

		if ( !unprotected && isAlive() ) {
			ProtectPlayer();
		} else {
			RemoveProtection();
		}
	}

	private void ProtectPlayer() {
		for ( int i = 0; i < meshes.Length; i++ ) {
			meshes[i].material = protectedMaterial;
		}
		Camera.main.GetComponent<AudioSource>().pitch = -0.5f;
		Camera.main.GetComponent<SepiaTone>().enabled = true;
		Camera.main.GetComponent<MotionBlur>().blurAmount = 1f;
		particles.Stop();
	}

	private void RemoveProtection() {
		for ( int i = 0; i < meshes.Length; i++ ) {
			meshes[i].materials = meshMaterialMap[meshes[i]];
		}
		Camera.main.GetComponent<AudioSource>().pitch = 1;
		Camera.main.GetComponent<SepiaTone>().enabled = false;
		Camera.main.GetComponent<MotionBlur>().blurAmount = 0.1f;
		particles.Play();
	}

	private void CheckIfUnderSight() {
		if ( !routine.IsWatching || !unprotected ) {
			return;
		}
		RaycastHit hit;
		for ( int i = 0; i < eyes.Length; i++ ) {
			if ( Physics.Raycast(transform.position, eyes[i].position, out hit) ) {
				if ( hit.transform.gameObject.tag == "GiantHead" ) {
					TakeDamage(1f);
					break;
				}
			}
		}
	}

	private void TakeDamage(float amount) {
		damaged = true;

		currentHealth -= amount;
		healthSlider.value = currentHealth;

		if ( !isAlive() && !deathTriggered ) {
			Death();
		}

	}


	private void Death() {
		deathTriggered = true;
		anim.SetTrigger("Die");
		playerMovement.enabled = false;
		particles.Stop();
	}

}
