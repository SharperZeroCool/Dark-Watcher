using UnityEngine;
using System.Collections;

public class SkeletonManager : AbstractManager {

	public float intervalSeconds;

	public int percentChance;

	public int maxSpawnRangeForX;

	public int maxSpawnRangeForZ;

	protected override IEnumerator ManageSpawn() {
		maxSpawnRangeForX = Mathf.Abs(maxSpawnRangeForX) * -1;

		while ( true ) {
			int random = Random.Range(1, 100);

			if ( random <= percentChance ) {
				SpawnGameObject();
			}

			yield return new WaitForSeconds(intervalSeconds);
		}
	}

	protected override void SpawnGameObject() {
		int randomPositionX = Random.Range(maxSpawnRangeForX, 0);

		int randomPositionZ = Random.Range(-maxSpawnRangeForZ, maxSpawnRangeForZ);
		if ( randomPositionZ >= 0 && randomPositionZ <= 15 ) {
			randomPositionZ += 15;
		} else if ( randomPositionZ <= 0 && randomPositionZ >= -15 ) {
			randomPositionZ -= 15;
		}

		CacheManager.SpawnNewGameObject(objects, Vector3.forward * randomPositionZ + Vector3.right * randomPositionX, transform.rotation);
	}

	protected override void CacheGameObjects() {
		CacheManager.CachePrefabs(out objects, maxNumberOfObjects, prefab);
	}

}
