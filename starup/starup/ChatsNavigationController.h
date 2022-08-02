//
//  ChatsNavigationController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 8/2/22.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/ChatSDK.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>

NS_ASSUME_NONNULL_BEGIN


@interface ChatsNavigationController : UINavigationController

@property (weak, nonatomic) IBOutlet UITabBarItem *barItem;

@end

NS_ASSUME_NONNULL_END
