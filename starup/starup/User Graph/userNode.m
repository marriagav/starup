//
//  userNode.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import "userNode.h"

@implementation userNode

- (instancetype)initWithUser:(PFUser *)user withVertices:(NSMutableArray *)vertices{
    self = [super init];
    if (self){
        _user = user;
        _vertices = vertices;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithUser:[[PFUser alloc]init] withVertices:[[NSMutableArray alloc]init]];
    return self;
}

@end
