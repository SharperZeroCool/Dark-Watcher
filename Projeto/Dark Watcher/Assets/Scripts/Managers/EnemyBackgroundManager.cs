using UnityEngine;
using System.Collections;

public class EnemyBackgroundManager : AbstractManager {

	public Transform[] spawnLocations;

	public Transform target;

	public float intervalSeconds;

	public int percentChance;

	protected override IEnumerator ManageSpawn() {
		for ( int i = 0; i < maxNumberOfObjects; i++ ) {
			int random = Random.Range(0, 100);

			if ( random <= percentChance ) {
				SpawnGameObject();
			}

			yield return new WaitForSeconds(intervalSeconds);
		}
	}

	protected override void SpawnGameObject() {
		Transform spawnLocation = GetRandomLocation();
		GameObject enemyBackground = CacheManager.SpawnNewGameObject(objects, spawnLocation.position, spawnLocation.rotation);
		enemyBackground.GetComponent<EnemyBackgroundAttack>().target = target;
		enemyBackground.GetComponent<EnemyBackgroundMovement>().targets = spawnLocations;
	}

	protected override void CacheGameObjects() {
		CacheManager.CachePrefabs(out objects, maxNumberOfObjects, prefab);
	}


	private Transform GetRandomLocation() {
		return spawnLocations[Random.Range(0, spawnLocations.Length)];
	}

}
