using UnityEngine;
using System.Collections;

public class ThetaWebCamTexture : MonoBehaviour {
	
	public int cameraNumber = 0;
	private WebCamTexture webcamTexture;
	
	void Start() 
	{
		WebCamDevice[] devices = WebCamTexture.devices;
		if (devices.Length > cameraNumber) {
			webcamTexture = new WebCamTexture(devices[cameraNumber].name, 1280, 720);
			GetComponent<Renderer>().material.mainTexture = webcamTexture;
			webcamTexture.Play();
		} else {
			Debug.Log("no camera");
		}
	}
}