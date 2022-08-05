//
//  Collaborator.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/15/22.
//

#import "Collaborator.h"


@implementation Collaborator

@dynamic collaboratorID;
@dynamic starupID;
@dynamic userID;
@dynamic user;
@dynamic starup;
@dynamic typeOfUser;
@dynamic ownership;

+ (nonnull NSString *)parseClassName
{
    return @"Collaborator";
}

+ (void)postCollaborator:(NSString *_Nullable)typeOfUser
                withUser:(PFUser *_Nullable)user
              withStarup:(Starup *_Nullable)starup
           withOwnership:(NSNumber *_Nullable)ownership
          withCompletion:(PFBooleanResultBlock _Nullable)completion
{
    //    Method to set the properties of the collaborator
    Collaborator *newCollaborator = [[Collaborator alloc] initWithClassName:@"Collaborator"];
    newCollaborator.typeOfUser = typeOfUser;
    newCollaborator.user = user;
    newCollaborator.starup = starup;
    newCollaborator.ownership = ownership;
    [newCollaborator saveInBackgroundWithBlock:completion];
}

@end
