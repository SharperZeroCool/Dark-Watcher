using UnityEngine;
using System.Collections;

public class HealthManager : AbstractManager {

	public float intervalSeconds;

	public int percentChance;

	public int maxZ;

	public float minZ;

	protected override IEnumerator ManageSpawn() {
		while ( true ) {
			int random = Random.Range(0, 100);

			if ( random <= percentChance ) {
				SpawnGameObject();
			}

			yield return new WaitForSeconds(intervalSeconds);
		}

	}


	protected override void SpawnGameObject() {
		float randomPosition = Random.Range(minZ, maxZ);

		CacheManager.SpawnNewGameObject(objects, Vector3.forward * randomPosition + Vector3.up * 0.3f, transform.rotation);
	}

	protected override void CacheGameObjects() {
		CacheManager.CachePrefabs(out objects, maxNumberOfObjects, prefab);
	}

}
