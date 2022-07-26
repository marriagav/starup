//
//  userNode.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import "userNode.h"

@implementation userNode

- (instancetype)initWithUser:(PFUser *)user{
    self = [super init];
    if (self){
        _user = user;
        _distanceFromStart = INT_MAX;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithUser:[[PFUser alloc]init]];
    return self;
}

@end
