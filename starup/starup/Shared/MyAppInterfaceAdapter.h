//
//  MyAppInterfaceAdapter.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 8/1/22.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/ChatSDK.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>
#import <ChatSDK/BDefaultInterfaceAdapter.h>
#import "Parse/Parse.h"
#import "ProfileViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface MyAppInterfaceAdapter : BDefaultInterfaceAdapter

- (UIViewController *)profileViewControllerWithUser:(id<PUser>)user;

@end

NS_ASSUME_NONNULL_END
