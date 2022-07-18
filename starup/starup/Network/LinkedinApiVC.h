//
//  LinkedinApiVC.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/18/22.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppAuth/AppAuth.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LinkedinApiVC : UIViewController

- (void)OAuth;
@property(nonatomic, readonly, nullable) OIDAuthState *authState;

@end

NS_ASSUME_NONNULL_END
