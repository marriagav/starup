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
    // Override point for customization after application launch.
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

            configuration.applicationId = @"0afOxTp50eiV4LwfjndlWljRa7eBEg9mTXkifaJP";
            configuration.clientKey = @"uE7TrfDAbk4lRSzrfvavBAow4NdIFUa9VzFfNvDZ";
            configuration.server = @"https://parseapi.back4app.com";
        }];

        [Parse initializeWithConfiguration:config];

        return YES;
    return YES;
}


#pragma mark - UISceneSession lifecycle


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
