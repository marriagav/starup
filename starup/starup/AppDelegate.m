//
//  AppDelegate.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "AppDelegate.h"

#import <ChatSDK/ChatSDK.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>
//#import <ChatSDKFirebase/fi
//#import <FirebaseEmailAuthUI/FirebaseEmailAuthUI.h>
//#import <Chatsdf
//#import <ChatSDKFirebase/ChatSDKFirebase.h>
//#import <FirebaseEmailAuthUI/FirebaseEmailAuthUI.h>

//#import <FirebaseModules/FirebaseModules-umbrella.h>
//#import <EncryptionModule/EncryptionModule-umbrella.h>
//#import <MessageModules/MessageModules-umbrella.h>
//#import <ContactBookModule/ContactBookModule-umbrella.h>
//#import <FirebaseNearbyUsersModule/FirebaseNearbyUsersModule-umbrella.h>

//@import ChatSDK;


@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Get the keys
    NSString *path = [[NSBundle mainBundle] pathForResource:@"../Keys" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *parseAPIid = [dict objectForKey:@"parseAppID"];
    NSString *parseKey = [dict objectForKey:@"parseClientKey"];
    NSString *paypalKey = [dict objectForKey:@"paypalClientID"];
    //    Set Parse configuration
    ParseClientConfiguration *parseConfig = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = parseAPIid;
        configuration.clientKey = parseKey;
        configuration.server = @"https://parseapi.back4app.com";
    }];
    [Parse initializeWithConfiguration:parseConfig];
    //    Set PayPal configuration
    PPCheckoutConfig *paypalConfig = [[PPCheckoutConfig alloc] initWithClientID:paypalKey returnUrl:@"com.starupcode.app://paypalpay" createOrder:nil onApprove:nil onShippingChange:nil onCancel:nil onError:nil environment:PPCEnvironmentSandbox];
    [PPCheckout setConfig:paypalConfig];


    BConfiguration *config = [BConfiguration configuration];
    config.rootPath = @"test";
    //    config.allowUsersToCreatePublicChats = YES;
    //    config.showEmptyChats = NO;

    NSMutableArray<PModule> *modules = [NSMutableArray arrayWithArray:@[
        [FirebaseNetworkAdapterModule shared],
        [FirebaseUploadModule shared],
        [FirebasePushModule shared],
    ]];

    //    FirebaseUIModule * firebaseUI = [FirebaseUIModule new];
    //    [firebaseUI setProviders:@[
    //        [FUIEmailAuth new]
    //    ]];

    //    [modules addObject:firebaseUI]
    //    NSLog(@"%@", [FIRApp defaultApp]);
    //    FIRDatabase *db = [FIRDatabase databaseForApp:[FIRApp defaultApp]];
    //    FIRDatabaseReference *ref = [[db reference] child:@"test/users"];
    //    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
    //        NSDictionary *userDict = snapshot.value;
    //        NSLog(@"%@",userDict);
    //    }];
    //    NSLog(@"%@",ref);

    [BChatSDK initialize:config app:application options:launchOptions modules:modules];

    return YES;
}


#pragma mark - UISceneSession lifecycles


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options
{
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions
{
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [BChatSDK application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    return [BChatSDK application:app openURL:url options:options];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BChatSDK application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [BChatSDK application:application didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
}
- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
