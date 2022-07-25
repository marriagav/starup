//
//  AppDelegate.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Get the keys
    NSString *path = [[NSBundle mainBundle] pathForResource:@"../Keys" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *parseAPIid = [dict objectForKey:@"parseAppID"];
    NSString *parseKey = [dict objectForKey:@"parseClientKey"];
    NSString *paypalKey = [dict objectForKey:@"paypalClientID"];
//    Set Parse configuration
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = parseAPIid;
        configuration.clientKey = parseKey;
        configuration.server = @"https://parseapi.back4app.com";
    }];
    [Parse initializeWithConfiguration:config];
//    Set PayPal configuration
    PPCheckoutConfig *paypalConfig = [[PPCheckoutConfig alloc] initWithClientID:paypalKey returnUrl:@"com.starupcode.app://paypalpay" createOrder:nil onApprove:nil onShippingChange:nil onCancel:nil onError:nil environment:PPCEnvironmentSandbox];
    [PPCheckout setConfig:paypalConfig];
    
    return YES;
}


#pragma mark - UISceneSession lifecycles


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
