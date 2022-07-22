//
//  Linkedin.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/21/22.
//

#import <Foundation/Foundation.h>
#import "LinkedinIOSHelper/LinkedInHelper.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Linkedin : NSObject

+ (BOOL)isLinkedInAccessTokenValid;
+ (void)getUserInfo;
+ (void)logoutFromLinkedin;
+ (void)checkIfUserHasLinkedin: (NSString*)username ;

@end

NS_ASSUME_NONNULL_END
