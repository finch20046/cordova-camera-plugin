package com.marcello.cameraplugin;

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
import android.provider.MediaStore;

public class CameraPlugin extends CordovaPlugin {

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
			this.openCamera(callbackContext);
			return true;
		}
		return false;
	}

	private void openCamera(CallbackContext callbackContext) {
	    this.paymentCallbackContext = callbackContext;

        // create Intent to take a picture and return control to the calling application
     // create intent with ACTION_IMAGE_CAPTURE action
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

        // start camera activity
        this.cordova.getActivity().startActivityForResult(intent, 1);

	}

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {

        if (requestCode == TAKE_PICTURE && resultCode== RESULT_OK && intent != null){
            // get bundle
            Bundle extras = intent.getExtras();

            // get bitmap
            bitMap = (Bitmap) extras.get("data");
            ivThumbnailPhoto.setImageBitmap(bitMap);

        }
    }

	private void initPlugin(CallbackContext callbackContext) {

	}
}