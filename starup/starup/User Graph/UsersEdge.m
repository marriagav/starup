//
//  usersEdge.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/26/22.
//

#import "UsersEdge.h"


@implementation UsersEdge

- (instancetype)initWithNodes:(UserNode *)node1 node2:(UserNode *)node2
                    closeness:(int)closeness
{
    self = [super init];
    if (self) {
        _node1 = node1;
        _node2 = node2;
        _closeness = closeness;
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithNodes:[[UserNode alloc] init] node2:[[UserNode alloc] init] closeness:0];
    return self;
}

@end
