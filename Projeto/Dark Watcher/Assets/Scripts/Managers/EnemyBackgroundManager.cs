using UnityEngine;
using System.Collections;

public class EnemyBackgroundManager : AbstractManager {

	public Transform[] spawnLocations;

	public Transform player;

	public Transform player2;

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
		if ( Vector3.Distance(gameObject.transform.position, player.position) < Vector3.Distance(gameObject.transform.position, player2.position) ) {
			enemyBackground.GetComponent<EnemyBackgroundAttack>().target = player;
		} else {
			enemyBackground.GetComponent<EnemyBackgroundAttack>().target = player2;
		}
		enemyBackground.GetComponent<EnemyBackgroundMovement>().targets = spawnLocations;
	}

	protected override void CacheGameObjects() {
		CacheManager.CachePrefabs(out objects, maxNumberOfObjects, prefab);
	}


	private Transform GetRandomLocation() {
		return spawnLocations[Random.Range(0, spawnLocations.Length)];
	}

}
