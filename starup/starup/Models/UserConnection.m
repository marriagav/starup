//
//  UserConnection.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import "UserConnection.h"

@implementation UserConnection

@dynamic userConnectionID;
@dynamic userOneID;
@dynamic userTwoID;
@dynamic userOne;
@dynamic userTwo;
@dynamic closeness;

+ (nonnull NSString *)parseClassName {
    return @"UserConnection";
}

+ (void) postUserConnection: (PFUser* _Nullable) userOne withUserTwo: (PFUser* _Nullable) userTwo withCloseness: (NSNumber* _Nullable) closeness withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    //    Method to set the properties of the collaborator
    UserConnection *newConnection= [[UserConnection alloc]initWithClassName:@"UserConnection"];
    newConnection.userOne = userOne;
    newConnection.userTwo = userTwo;
    newConnection.closeness= closeness;
    [newConnection saveInBackgroundWithBlock: completion];
}

@end
