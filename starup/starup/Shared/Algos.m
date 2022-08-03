//
//  Algos.m
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/29/22.
//

#import "Algos.h"


@implementation Algos

+ (PFFileObject *)getPFFileFromImage:(UIImage *_Nullable)image
{
    //    Gets a PFFFileObject from a UIImage
    // check if image is not nil
    if (!image) {
        return nil;
    }

    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)i_width
{
    //    Resizes an image using i_width width
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;

    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)formatPictureWithRoundedEdges:(PFImageView *)image
{
    //    Add rounded edges to a PFImageView
    image.layer.cornerRadius = image.frame.size.height / 2;
    image.layer.borderWidth = 0;
    image.clipsToBounds = YES;
}

+ (NSString *)dateToString:(NSDate *)date
{
    //    Convert a NSDate to a string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM d HH:mm y";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (float)percentageWithNumbers:(double)current withTotal:(double)total
{
    return current / total;
}

+ (NSString *)firstObjectFromDict:(NSDictionary *)dict
{
    id val = nil;
    NSArray *values = [dict allValues];
    if ([values count] != 0) {
        val = [values objectAtIndex:0];
        return val;
    }
    return @"";
}

+ (NSString *)generateRandomString:(int)num
{
    NSMutableString *string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(26))];
    }
    return string;
}

+ (BOOL)userInArray:(PFUser *)user1 withArray:(NSMutableArray *)array
{
    for (PFUser *user in array) {
        if ([user.username isEqual:user1.username]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)imageToString:(UIImage *)image
{
    NSString *imagePath = [NSString stringWithFormat:@"%@%@", [self generateRandomString:10], @".png"];
    NSURL *url = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:imagePath];
    NSData *pngData = UIImagePNGRepresentation(image);
    [pngData writeToURL:url atomically:YES];
    return url.absoluteString;
}

+ (NSString *)normalizeString:(NSString *)string
{
    //    Normalize strings for search
    NSString *normalizedString = [[NSString alloc]
        initWithData:
            [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]
            encoding:NSASCIIStringEncoding];
    return [normalizedString lowercaseString];
}

+ (NSString *)normalizeFullName:(NSString *)firstName withLastname:(NSString *)lastName
{
    return [self normalizeString:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
}

+ (id<PUser>)getChatUserWithId:(NSString *)chatUserId
{
    CCUserWrapper *wrapper = [CCUserWrapper userWithEntityID:chatUserId];
    [wrapper metaOn];
    [wrapper onlineOn];
    id<PUser> chatUser = [wrapper model];
    return chatUser;
}

@end
