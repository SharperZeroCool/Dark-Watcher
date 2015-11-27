using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;

public class PlayerHealth : MonoBehaviour {

	public Material protectedMaterial;

	public Transform[] eyes;

	public MoonRoutine moonRoutine;

	public Slider healthSlider;

	public Text healthText;

	public Image damageImage;

	public Color flashColour = new Color(1f, 0f, 0f, 0.01f);

	public AudioSource moonAttackAudioSource;

	public AudioSource[] damageAudioSource;

	public int startingHealth = 100;

	public float currentHealth;

	public float flashFor = 3f;

	public float flashSpeed = 5f;

	public bool unprotected;

	private Dictionary<SkinnedMeshRenderer, Material[]> meshMaterialMap = new Dictionary<SkinnedMeshRenderer, Material[]>();

	private SkinnedMeshRenderer[] meshes;

	private Animator anim;

	private CCPlayerMovement2D playerMovement;

	private MeshExploder[] meshExploders;

	private bool deathTriggered;

	private bool damaged;

	private bool hasPlayedAudio;

	private bool moonAttack;

	private bool flashing;

	private void Awake() {
		anim = GetComponent<Animator>();
		playerMovement = GetComponent<CCPlayerMovement2D>();
		meshExploders = GetComponentsInChildren<MeshExploder>();
		LoadProtectionMaterials();

		currentHealth = startingHealth;
		damageImage.color = Color.clear;
		damaged = false;
		unprotected = true;
		hasPlayedAudio = false;
		moonAttack = false;
		flashing = false;
	}

	private void FixedUpdate() {
		CheckIfProtected();

		CheckIfUnderSight();
		if ( damaged && isAlive() ) {
			if ( !hasPlayedAudio && moonAttack ) {
				moonAttackAudioSource.Play();
				hasPlayedAudio = true;
				Camera.main.GetComponent<EffectsHandler>().EnableDamageEffects();
			}
			damageImage.color = flashColour;
		} else {
			hasPlayedAudio = false;
			damageImage.color = Color.Lerp(damageImage.color, Color.clear, flashSpeed * Time.deltaTime);
			Camera.main.GetComponent<EffectsHandler>().DisableDamageEffects();
		}
		damaged = false;
	}

	public bool isAlive() {
		return currentHealth > 0;
	}

	public void TakeDamage(float amount, bool bossAttack) {
		if ( !isAlive() || flashing && !bossAttack ) {
			return;
		}
		damaged = true;
		this.moonAttack = bossAttack;

		currentHealth -= amount;
		UpdateUIHealthAmount();

		SoundManager.instance.playAtRandomPitch(damageAudioSource[Random.Range(0, damageAudioSource.Length)]);

		if ( !isAlive() && !deathTriggered ) {
			Death();
		} else {
			StartCoroutine("FlashPlayer");
		}

	}

	public void HealDamage(float amount) {
		if ( currentHealth < startingHealth ) {
			currentHealth += amount;
		}
		if ( currentHealth > startingHealth ) {
			currentHealth = startingHealth;
		}
		UpdateUIHealthAmount();
	}

	private void UpdateUIHealthAmount() {
		healthSlider.value = currentHealth;
		healthText.text = currentHealth.ToString();
	}

	private IEnumerator FlashPlayer() {
		flashing = true;
		float whenWeAreDone = Time.time + flashFor;
		while ( Time.time < whenWeAreDone ) {
			EnableProtectedMaterials();
			yield return new WaitForFixedUpdate();
			DisableProtectedMaterials();
			yield return new WaitForFixedUpdate();
		}
		flashing = false;
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
		StopCoroutine("FlashPlayer");
		flashing = false;
		EnableProtectedMaterials();
		anim.enabled = false;
		Camera.main.GetComponent<EffectsHandler>().EnableProtectionEffects();
	}

	private void RemoveProtection() {
		DisableProtectedMaterials();
		anim.enabled = true;
		Camera.main.GetComponent<EffectsHandler>().DisableProtectionEffects();
	}

	private void EnableProtectedMaterials() {
		for ( int i = 0; i < meshes.Length; i++ ) {
			meshes[i].material = protectedMaterial;
		}
	}

	private void DisableProtectedMaterials() {
		for ( int i = 0; i < meshes.Length; i++ ) {
			meshes[i].materials = meshMaterialMap[meshes[i]];
		}
	}

	private void CheckIfUnderSight() {
		if ( !moonRoutine.IsWatching || !unprotected ) {
			return;
		}
		RaycastHit hit;
		for ( int i = 0; i < eyes.Length; i++ ) {
			if ( Physics.Raycast(transform.position, eyes[i].position, out hit) ) {
				if ( hit.transform.gameObject.tag == "Moon" ) {
					TakeDamage(1f, true);
					break;
				}
			}
		}
	}

	private void Death() {
		deathTriggered = true;
		playerMovement.enabled = false;
		anim.enabled = false;
		for ( int i = 0; i < meshExploders.Length; i++ ) {
			meshExploders[i].Explode();
		}
		Destroy(gameObject);
	}

	private void LoadProtectionMaterials() {
		meshes = GetComponentsInChildren<SkinnedMeshRenderer>();

		for ( int i = 0; i < meshes.Length; i++ ) {
			meshMaterialMap[meshes[i]] = meshes[i].materials;
		}
	}

	private void OnParticleCollision(GameObject other) {
		TakeDamage(5f, false);
	}

}
