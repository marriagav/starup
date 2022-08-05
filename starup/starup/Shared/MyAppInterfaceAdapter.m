//
//  MyAppInterfaceAdapter.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 8/1/22.
//

#import "MyAppInterfaceAdapter.h"


@implementation MyAppInterfaceAdapter

- (UIViewController *)profileViewControllerWithUser:(id<PUser>)user
{
    NSString *entityId = user.entityID;
    PFQuery *query = [PFUser query];
    [query whereKey:@"chatsId" equalTo:entityId];

    // fetch data asynchronously
    PFUser *userParse = [query getFirstObject];
    //    Goes to profile page when user taps on profile
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    // Pass the user
    profileViewController.user = userParse;
    return profileViewController;
}

@end
