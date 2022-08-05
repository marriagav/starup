//
//  Collaborator.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/15/22.
//

#import <Parse/Parse.h>
#import "Starup.h"

NS_ASSUME_NONNULL_BEGIN


@interface Collaborator : PFObject

@property (nonatomic, strong) NSString *collaboratorID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *starupID;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) Starup *starup;
@property (nonatomic, strong) NSString *typeOfUser;
@property (nonatomic, strong) NSNumber *ownership;

+ (void)postCollaborator:(NSString *_Nullable)typeOfUser
                withUser:(PFUser *_Nullable)user
              withStarup:(Starup *_Nullable)starup
           withOwnership:(NSNumber *_Nullable)ownership
          withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
