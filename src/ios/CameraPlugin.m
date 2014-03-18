//
//  CameraPlugin.m
//
//
//  Created by Marc on 26/02/14.
//
//

#import "CameraPlugin.h"

NSString *appname = @"cameraplugin";
static char CAMERA_PLUGIN_REF_KEY;
static IMP UIApplicationDelegate_handleOpenURL_original;

@implementation CameraPlugin

- (void)initPlugin:(CDVInvokedUrlCommand*)command{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Store a reference to the plugin so we can access it from our handleOpenUrl
    objc_setAssociatedObject(appDelegate, &CAMERA_PLUGIN_REF_KEY, self, OBJC_ASSOCIATION_RETAIN);
    
    // Store references to the handleOpenUrl methods so we can switch them on demand
    self->myHandleOpenUrl = class_getInstanceMethod([self class], @selector(application:newHandleOpenUrlImpl:));
    self->originalHandleOpenUrl = class_getInstanceMethod([appDelegate class], @selector(application:handleOpenURL:));
}

-(BOOL) application:(UIApplication *)application newHandleOpenUrlImpl:(NSURL *)url {
    CDVPluginResult* pluginResult = nil;
    NSString *value = [url query];
    NSLog(@"%@", url);

    if (true) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"paid"];

    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"failed"];
    }

    // self is a reference to AppDelegate
    CameraPlugin *plugin = (CameraPlugin *)objc_getAssociatedObject(self, &CAMERA_PLUGIN_REF_KEY);
    
    // Replace handleOpenUrl with original application one
    method_exchangeImplementations(plugin->myHandleOpenUrl, plugin->originalHandleOpenUrl);
    
    // Send payment result
    [plugin.commandDelegate sendPluginResult:pluginResult callbackId:plugin.callbackId];
    return YES;
}

- (void)performPayment:(CDVInvokedUrlCommand*)command{

    NSString* value = [command.arguments objectAtIndex:0];
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"IlmioPOS://"]];
    CDVPluginResult* pluginResult = nil;
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:value];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    if (isInstalled & isValid) {
        self.callbackId = command.callbackId;
        NSString *myString = [NSString stringWithFormat:@"IlmioPOS://?value=%@&sender=%@", value, appname];
        NSURL *myURL = [NSURL URLWithString:myString];

        // Replace application handleOpenUrl with our own version
        method_exchangeImplementations(self->originalHandleOpenUrl, self->myHandleOpenUrl);

        [[UIApplication sharedApplication] openURL:myURL];
    } else {
        if(!isValid)
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"-5"];
        else
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"-1"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)isAvailable:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;

    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"IlmioPOS://"]];
    if (isInstalled) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"available"];

    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"-1"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showConfirmAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Pos Not Found!"
                                                        message:@"Mobile Pos Application is not installed on this device!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];

}


@end