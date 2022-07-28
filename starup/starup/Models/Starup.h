//
//  Starup.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/12/22.
//

#import <Parse/Parse.h>
#import "Algos.h"

NS_ASSUME_NONNULL_BEGIN


@interface Starup : PFObject

@property (nonatomic, strong) NSString *starupID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *starupName;
@property (nonatomic, strong) NSString *starupCategory;
@property (nonatomic, strong) NSDate *operatingSince;
@property (nonatomic) int sales;
@property (nonatomic) int goalInvestment;
@property (nonatomic) int currentInvestment;
@property (nonatomic) int percentageToGive;
@property (nonatomic, strong) PFFileObject *starupImage;
@property (nonatomic, strong) NSString *starupDescription;

+ (void)postStarup:(NSString *_Nullable)starupName withCategory:(NSString *_Nullable)starupCategory withDescription:(NSString *_Nullable)starupDescription withImage:(UIImage *_Nullable)starupImage withOperationSince:(NSDate *_Nullable)operatingSince withSales:(int)sales withGoalInvestment:(int)goalInvestment withPercentageToGive:(int)percentageToGive withCompletion:(void (^)(Starup *starup, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
