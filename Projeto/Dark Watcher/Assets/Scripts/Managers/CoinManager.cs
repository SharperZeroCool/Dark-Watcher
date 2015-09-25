using UnityEngine;
using System.Collections;

public class CoinManager : MonoBehaviour {

	public GameObject coin;

	public float intervalSeconds;

	public int percentChance;

	public int maxSpawnRange;

	private void Start() {
		StartCoroutine("ManageSpawn");
	}

	private IEnumerator ManageSpawn() {
		while ( true ) {
			int random = Random.Range(1, 100);

			if ( random <= percentChance ) {
				SpawnCoin();
			}

			yield return new WaitForSeconds(intervalSeconds);
		}

	}

	private void SpawnCoin() {
		int randomPosition = Random.Range(-maxSpawnRange, maxSpawnRange);
		if ( randomPosition >= 0 ) {
			randomPosition += 15;
		} else {
			randomPosition -= 15;
		}
		int randomHeight = Random.Range(0, 11);
		if ( randomHeight % 4 != 0 ) {
			if ( randomHeight < 4 ) {
				randomHeight = 0;
			} else if ( randomHeight < 8 ) {
				randomHeight = 4;
			} else {
				randomHeight = 8;
			}
		}

		Instantiate(coin, Vector3.forward * randomPosition + Vector3.up * randomHeight, transform.rotation);
	}
}
