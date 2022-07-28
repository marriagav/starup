//
//  usersEdge.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/26/22.
//

#import <Foundation/Foundation.h>
#import "UserNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface UsersEdge : NSObject

@property (nonatomic, strong) UserNode *node1;
@property (nonatomic, strong) UserNode *node2;
@property int closeness;
@property (nonatomic, strong) NSMutableArray *vertices;

- (instancetype)initWithNodes:(UserNode *)node1 :(UserNode *)node2 :(int)closeness;

@end

NS_ASSUME_NONNULL_END
