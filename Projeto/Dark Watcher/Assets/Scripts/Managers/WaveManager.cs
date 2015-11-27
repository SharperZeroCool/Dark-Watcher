using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class WaveManager : MonoBehaviour {

	public Text waveText;

	public EnemyManager bossManager;

	public EnemyManager enemyManager;

	private int currentWave;

	void Start() {
		currentWave = 0;
		StartCoroutine("ControlWaves");
		StartNewWave();
	}

	private IEnumerator ControlWaves() {
		while ( true ) {
			if ( ScoreManager.score / 100f > currentWave ) {
				StartNewWave();

				yield return new WaitForSeconds(10);

			}

			yield return new WaitForFixedUpdate();

		}
	}

	private void StartNewWave() {
		currentWave++;
		waveText.text = "Wave " + currentWave;
		waveText.enabled = true;
		Invoke("HideWaveText", 3f);
		IncreaseDifficulty();
	}

	private void HideWaveText() {
		waveText.enabled = false;
	}

	private void IncreaseDifficulty() {
		IncreaseBossDifficulty();
		IncreaseMageDifficulty();
	}

	private void IncreaseBossDifficulty() {
		if ( bossManager.percentChance < 100 ) {
			bossManager.percentChance += 1;
		}
		if ( bossManager.percentChance > 100 ) {
			bossManager.percentChance = 100;
		}
		if ( bossManager.intervalSeconds > 0 ) {
			bossManager.intervalSeconds -= 0.45f;
		}
		if ( bossManager.intervalSeconds < 0 ) {
			bossManager.intervalSeconds = 0;
		}
		bossManager.startingHealth *= 1.025f;
	}

	private void IncreaseMageDifficulty() {
		if ( enemyManager.percentChance < 100 ) {
			enemyManager.percentChance += 3;
		}
		if ( enemyManager.percentChance > 100 ) {
			enemyManager.percentChance = 100;
		}
		if ( enemyManager.intervalSeconds > 0 ) {
			enemyManager.intervalSeconds -= 0.4f;
		}
		if ( enemyManager.intervalSeconds < 0 ) {
			enemyManager.intervalSeconds = 0;
		}
		enemyManager.startingHealth *= 1.056f;
	}

}
