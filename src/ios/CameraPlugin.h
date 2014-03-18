// Note that Xcode gets this line wrong.  You need to change "Cordova.h" to "CDV.h" as shown below.
#import <Cordova/CDV.h>

@interface CameraPlugin : CDVPlugin <UIImagePickerControllerDelegate>

// Cordova command method
-(void) openCamera:(CDVInvokedUrlCommand*)command;

// Create and override some properties and methods (these will be explained later)
-(void) capturedImageWithPath:(NSString*)imagePath;
@property (strong, nonatomic) CDVInvokedUrlCommand *latestCommand;
@property (strong, nonatomic) UIImagePickerController* picker;

@end

