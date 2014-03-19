package com.marcello.cameraplugin;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;


public class CameraPlugin extends CordovaPlugin {
	
	static int TAKE_PICTURE = 1;
	private CallbackContext callbackContext;

	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		System.out.println("============>" + action);

		if (action.equals("initPlugin")) {
			this.initPlugin(callbackContext);
			return true;
		}
		if (action.equals("openCamera")) {
			this.openCamera(callbackContext);
			return true;
		}
		return false;
	}

	private void openCamera(CallbackContext callbackContext) {
	    this.callbackContext = callbackContext;
	    //Context context = cordova.getActivity().getApplicationContext();
	    //Intent intent = new Intent(context, CameraPlugin.class);
        // create Intent to take a picture and return control to the calling application
        //create intent with ACTION_IMAGE_CAPTURE action
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        this.cordova.setActivityResultCallback(CameraPlugin.this);
        // start camera activity
        this.cordova.getActivity().startActivityForResult(intent, 1);
        
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		if ((requestCode == TAKE_PICTURE) && (resultCode == Activity.RESULT_OK)) {
	        Uri photoPath = intent.getData();
	                    // do something with the uri here
	        String uri = getPath(photoPath);
	        Log.d("CAMERAPLUGIN", uri);
	        this.callbackContext.success(uri);
	    }else
	    	this.callbackContext.success("error");
	}
	
	private String getPath(Uri uri) {

	    String[] projection = { MediaStore.Images.Media.DATA };
	    Cursor cursor = this.cordova.getActivity().getContentResolver().query(uri, projection, null, null,null);

	    int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
	    cursor.moveToFirst();

	    return cursor.getString(column_index);
	}
	
	
	

	private void initPlugin(CallbackContext callbackContext) {

	}
}