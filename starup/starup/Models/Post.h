//
//  Post.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/11/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *contentOfPost;
@property (nonatomic, strong) NSString *updateStatus;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;


+ (void) postUserStatus: ( NSString * _Nullable )updateStatus withCaption: ( NSString * _Nullable )contentOfPost withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
