//
//  UserConnection.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN


@interface UserConnection : PFObject

@property (nonatomic, strong) NSString *userConnectionID;
@property (nonatomic, strong) NSString *userOneID;
@property (nonatomic, strong) NSString *userTwoID;
@property (nonatomic, strong) PFUser *userOne;
@property (nonatomic, strong) PFUser *userTwo;
@property (nonatomic, strong) NSNumber *closeness;

+ (void)postUserConnection:(PFUser *_Nullable)userOne
               withUserTwo:(PFUser *_Nullable)userTwo
             withCloseness:(NSNumber *_Nullable)closeness
            withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
