using UnityEngine;
using System.Collections;

public class EnemyBackgroundAttack : MonoBehaviour {

	public Transform target;

	public float attackDamageMultiplier = 1f;

	public void Attack() {
		Quaternion rotation = transform.rotation;
		Vector3 angle = Vector3.left * 80;
		rotation.eulerAngles += angle;
        GameObject arrow = ArrowManager.instance.SpawnObjectAt(transform.position + Vector3.up * 2, rotation);
		arrow.GetComponent<Arrow>().target = target;
		arrow.GetComponent<Arrow>().attackDamage *= attackDamageMultiplier;
		transform.LookAt(target);
	}
}
