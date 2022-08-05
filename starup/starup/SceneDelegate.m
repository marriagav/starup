//
//  SceneDelegate.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "SceneDelegate.h"


@interface SceneDelegate ()

@end


@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    //    Persistant sessions
    if (PFUser.currentUser) {
        UIStoryboard *loadingScreen = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
        self.window.rootViewController = [loadingScreen instantiateViewControllerWithIdentifier:@"launchScreen"];
        [Linkedin checkIfUserHasLinkedin:PFUser.currentUser.username];
        [BChatSDK.auth authenticate].thenOnMain(
            ^id(id result) {
                //    Set graph
                ConnectionsGraph *graph = [ConnectionsGraph sharedInstance];
                [graph fillGraphWithCloseConnections:^(NSError *_Nullable error) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"navBar"];
                }];
                return result;
            }, ^id(NSError *error) {
                return error;
            });
    }
}

@end
