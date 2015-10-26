using UnityEngine;
using System.Collections;

public class CoinManager : AbstractManager {

	public float intervalSeconds;

	public int percentChance;

	public int maxSpawnRange;

	protected override IEnumerator ManageSpawn() {
		while ( true ) {
			int random = Random.Range(1, 100);

			if ( random <= percentChance ) {
				SpawnGameObject();
			}

			yield return new WaitForSeconds(intervalSeconds);
		}

	}


	protected override void SpawnGameObject() {
		int randomPosition = Random.Range(-maxSpawnRange, maxSpawnRange);
		if ( randomPosition >= 0 && randomPosition <= 15) {
			randomPosition += 15;
		} else if(randomPosition <=0 && randomPosition >= -15){
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

		CacheManager.SpawnNewGameObject(objects, Vector3.forward * randomPosition + Vector3.up * randomHeight, transform.rotation);
	}

	protected override void CacheGameObjects() {
		CacheManager.CachePrefabs(out objects, maxNumberOfObjects, prefab);
	}

}
