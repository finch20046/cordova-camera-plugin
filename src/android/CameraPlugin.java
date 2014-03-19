package com.scloby.ingenico;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import android.widget.Toast;
import android.content.Context;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.util.Log;
import android.widget.Toast;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.net.Uri;

public class SclobyPlugin extends CordovaPlugin {

	private final String INGENICO_PAKAGE = "com.ingenico.bancasella";
	private final String INGENICO_SUB_PAKAGE = "com.ingenico.pos";
	private final int INGENICO_PAYMENT = 500;
	private Intent intent;
	private final String TAG = "SCLOBY";
	private CallbackContext paymentCallbackContext;

	@Override
	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {
		System.out.println("============>" + action);

		if (action.equals("initPlugin")) {
			String message = "initPlugin";
			this.initPlugin(callbackContext);
			return true;
		}
		if (action.equals("openCamera")) {
			String message = "openCamera";
			this.initPlugin(callbackContext);
			return true;
		}
		return false;
	}

	private void openCamera(CallbackContext callbackContext) {
	    this.paymentCallbackContext = callbackContext;

        setContentView(R.layout.main);

        // create Intent to take a picture and return control to the calling application
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

        fileUri = getOutputMediaFileUri(MEDIA_TYPE_IMAGE); // create a file to save the image
        intent.putExtra(MediaStore.EXTRA_OUTPUT, fileUri); // set the image file name

        // start the image capture Intent
        startActivityForResult(intent, CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE);

	}

	private void initPlugin(CallbackContext callbackContext) {

	}

}