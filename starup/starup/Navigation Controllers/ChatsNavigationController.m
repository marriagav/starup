//
//  ChatsNavigationController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 8/2/22.
//

#import "ChatsNavigationController.h"


@interface ChatsNavigationController ()

@end


@implementation ChatsNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIViewController *privateThreadsViewController = [BChatSDK.ui privateThreadsViewController];
    privateThreadsViewController.navigationItem.hidesBackButton = YES;
    privateThreadsViewController.title = @" ";
    [privateThreadsViewController.navigationItem setTitle:@"Chats"];
    [self pushViewController:privateThreadsViewController animated:NO];
}

@end
