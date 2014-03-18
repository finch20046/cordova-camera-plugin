#import "CameraPlugin.h"
#import "AppDelegate.h"
@implementation CameraPlugin

// Cordova command method
-(void) openCamera:(CDVInvokedUrlCommand *)command {

	// Save the CDVInvokedUrlCommand as a property.  We will need it later.
	self.latestCommand = command;

	// Make the overlay view controller.
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;

    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIViewController *rootViewController = delegate.window.rootViewController;

    // Display the view.  This will "slide up" a modal view from the bottom of the screen.
    [rootViewController presentModalViewController:self.picker animated:YES];

    self.picker.delegate = self;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

	// Get a reference to the captured image
	UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];

	// Get a file path to save the JPEG
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	NSString* filename = [[self genRandStringLength:5] stringByAppendingString:@".jpg"];
	NSString* imagePath = [documentsDirectory stringByAppendingPathComponent:filename];

	// Get the image data (blocking; around 1 second)
	NSData* imageData = UIImageJPEGRepresentation(image, 0.5);

	// Write the data to the file
	[imageData writeToFile:imagePath atomically:YES];

	// Tell the plugin class that we're finished processing the image
	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:imagePath] callbackId:self.latestCommand.callbackId];

    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
	// Hide the picker view
	[delegate.window.rootViewController dismissModalViewControllerAnimated:YES];
}

-(NSString *) genRandStringLength: (int) len {

    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];

    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }

    return randomString;
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.picker dismissModalViewControllerAnimated:YES];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Canceled"] callbackId:self.latestCommand.callbackId];
}

@end