//
//  userNode.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "UserConnection.h"

NS_ASSUME_NONNULL_BEGIN


@interface UserNode : NSObject

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) UserNode *previous;
@property int distanceFromStart;

- (instancetype)initWithUser:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
