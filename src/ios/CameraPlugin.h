//
//  CameraPlugin.h
//
//
//  Created by Marci on 26/02/14.
//
//

#import <Cordova/CDV.h>
#import <objc/runtime.h>

@interface CameraPlugin : CDVPlugin <UIAlertViewDelegate> {
    Method originalHandleOpenUrl;
    Method myHandleOpenUrl;
}

@property (nonatomic, strong) NSString* callbackId;

- (void)initPlugin:(CDVInvokedUrlCommand*)command;
- (BOOL)application:(UIApplication *)application newHandleOpenUrlImpl:(NSURL *)url;

@end
