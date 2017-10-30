using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RadiusShaderAnimation : MonoBehaviour {


	public Material radiusJP;
	public float radius;
	public Color radiusColor;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		radiusJP.SetVector("_Center",transform.position);
		radiusJP.SetColor("_CircleColor",radiusColor);
		radiusJP.SetFloat("_Radius",radius);
	}
}
