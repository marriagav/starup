//
//  Post.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/11/22.
//

#import "Post.h"


@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic contentOfPost;
@dynamic updateStatus;
@dynamic likeCount;
@dynamic commentCount;
@dynamic statusImage;

+ (nonnull NSString *)parseClassName
{
    return @"Post";
}

+ (void)postUserStatus:(NSString *_Nullable)updateStatus withCaption:(NSString *_Nullable)contentOfPost withImage:(UIImage *_Nullable)statusImage withCompletion:(PFBooleanResultBlock _Nullable)completion
{
    //    Method to set the properties of the post
    Post *newPost = [[Post alloc] initWithClassName:@"Post"];
    newPost.statusImage = [Algos getPFFileFromImage:statusImage];
    newPost.author = [PFUser currentUser];
    newPost.contentOfPost = contentOfPost;
    newPost.updateStatus = updateStatus;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    [newPost saveInBackgroundWithBlock:completion];
}

@end
