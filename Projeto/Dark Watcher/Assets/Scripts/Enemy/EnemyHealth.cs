using UnityEngine;
using System.Collections;

public class EnemyHealth : MonoBehaviour {

	public AudioSource[] damagedSounds;

	public float startingHealth = 100;

	public float currentHealth;

	private MonoBehaviour enemyAttack;

	private bool isSinking;

	private void Start() {
		enemyAttack = GetComponent<EnemyAttack>();
		if(enemyAttack == null) {
			enemyAttack = GetComponent<EnemyBossAttack>();
		}
		ResetHealth();
    }

	public void TakeDamage(float amount, Vector3 hitPoint) {
		if ( IsDead() ) {
			return;

		}

		SoundManager.instance.playAtRandomPitch(damagedSounds[Random.Range(0, damagedSounds.Length)]);

		currentHealth -= amount;

		if ( IsDead() ) {
			Die();
		}

	}

	public bool IsDead() {
		return currentHealth <= 0;
	}

	public void ResetHealth() {
		currentHealth = Mathf.FloorToInt(startingHealth);
	}

	private void Die() {
		enemyAttack.StopAllCoroutines();
		Atomize();
		CacheManager.DeSpawnGameObject(gameObject);
	}

	private void Atomize() {
		AtomizerEffectGroup effectGroup = Atomizer.CreateEffectGroup();

		SwapColours swapColours = new SwapColours();
		int modeIndex = Random.Range(0, System.Enum.GetValues(typeof(ColourSwapMode)).Length);
		swapColours.ColourSwapMode = (ColourSwapMode) modeIndex;
		swapColours.Duration = 5f;
		effectGroup.Combine(swapColours);

		Pulse pulseEffect = new Pulse();
		pulseEffect.PulseLength = Random.Range(0.1f, 0.6f);
		pulseEffect.PulseStrength = Random.Range(0.2f, 0.8f);
		pulseEffect.Duration = 5f;
		effectGroup.Combine(pulseEffect);

		Pop popEffect = new Pop();
		popEffect.Duration = 5f;
		popEffect.Force = Random.Range(0.1f, 4.0f);
		effectGroup.Combine(popEffect);

		Percolate percolateEffect = new Percolate();
		percolateEffect.PercolationTime = Random.Range(1.0f, 4.0f);
		percolateEffect.PercolationSpeed = Random.Range(0.5f, 6.0f);
		percolateEffect.Duration = 5f;
		int directionIndex = Random.Range(0, System.Enum.GetValues(typeof(PercolationDirection)).Length);
		percolateEffect.Direction = (PercolationDirection) directionIndex;
		effectGroup.Combine(percolateEffect);

		Disintegrate disintegrateEffect = new Disintegrate();
		disintegrateEffect.Duration = 5f;
		disintegrateEffect.FadeColour = new Color(Random.value, Random.value, Random.value, Random.value);
		effectGroup.Combine(disintegrateEffect);

		Vacuum vacuumEffect = new Vacuum();
		vacuumEffect.VacuumPoint = new Vector3(
			transform.position.x,
			transform.position.y + 2f,
			transform.position.z);
		vacuumEffect.MoveSpeed = 5f;
		vacuumEffect.Duration = 5.0f;
		effectGroup.Chain(vacuumEffect);

		Atomizer.Atomize(gameObject, effectGroup, null);
	}

}
