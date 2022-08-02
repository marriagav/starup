//
//  GoToChatsViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 8/1/22.
//

#import "GoToChatsViewController.h"


@interface GoToChatsViewController ()

@end


@implementation GoToChatsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIViewController *privateThreadsViewController = [BChatSDK.ui privateThreadsViewController];
    privateThreadsViewController.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:privateThreadsViewController animated:NO];
}

@end
