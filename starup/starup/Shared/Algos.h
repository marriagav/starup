//
//  Algos.h
//  instagram-codepath
//  Algorithms class to use throughout the app
//  Created by Miguel Arriaga Velasco on 6/29/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ChatSDKFirebase/CCUserWrapper.h>

NS_ASSUME_NONNULL_BEGIN

@import Parse;


@interface Algos : NSObject

+ (PFFileObject *)getPFFileFromImage:(UIImage *_Nullable)image;
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)i_width;
+ (void)formatPictureWithRoundedEdges:(PFImageView *)image;
+ (NSString *)dateToString:(NSDate *)date;
+ (float)percentageWithNumbers:(double)current withTotal:(double)total;
+ (NSString *)firstObjectFromDict:(NSDictionary *)dict;
+ (NSString *)generateRandomString:(int)num;
+ (BOOL)userInArray:(PFUser *)user1 withArray:(NSMutableArray *)array;
+ (NSString *)normalizeString:(NSString *)string;
+ (NSString *)normalizeFullName:(NSString *)firstName withLastname:(NSString *)lastName;
+ (id<PUser>)getChatUserWithId:(NSString *)chatUserId;

@end

NS_ASSUME_NONNULL_END
