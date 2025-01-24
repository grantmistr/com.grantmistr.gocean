using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CapFramerate : MonoBehaviour
{
    public int frameRate = 30;
    private void Start()
    {
        Application.targetFrameRate = frameRate;
    }
}
