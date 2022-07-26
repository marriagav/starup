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

@interface userNode : NSObject

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) userNode *previous;
@property int distanceFromStart;
@property (nonatomic, strong) NSMutableArray *vertices;

- (instancetype)initWithUser:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
