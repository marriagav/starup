//
//  usersEdge.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/26/22.
//

#import <Foundation/Foundation.h>
#import "userNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface usersEdge : NSObject

@property (nonatomic, strong) userNode *node1;
@property (nonatomic, strong) userNode *node2;
@property int closeness;
@property (nonatomic, strong) NSMutableArray *vertices;

- (instancetype)initWithNodes:(userNode *)node1 :(userNode *)node2 :(int)closeness;

@end

NS_ASSUME_NONNULL_END
