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
    [self.navigationController pushViewController:privateThreadsViewController animated:NO];
}

//- (void)viewDidAppear:(BOOL)animated {
//    UIViewController * privateThreadsViewController = [BChatSDK.ui privateThreadsViewController];
//    [self.navigationController pushViewController:privateThreadsViewController animated:YES];
//}

@end
