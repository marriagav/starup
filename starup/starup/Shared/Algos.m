//
//  Algos.m
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/29/22.
//

#import "Algos.h"

@implementation Algos

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
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

+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width {
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

+ (void)formatPictureWithRoundedEdges: (PFImageView *) image{
//    Add rounded edges to a PFImageView
    image.layer.cornerRadius = image.frame.size.height/2;
    image.layer.borderWidth = 0;
    image.clipsToBounds=YES;
}

+ (NSString*)dateToString: (NSDate *) date{
//    Convert a NSDate to a string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM d HH:mm y";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (float)percentageWithNumbers: (double) current :(double) total{
    return current/total;
}

@end
