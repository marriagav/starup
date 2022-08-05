//
//  Starup.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/12/22.
//

#import "Starup.h"


@implementation Starup

@dynamic starupID;
@dynamic userID;
@dynamic author;
@dynamic starupCategory;
@dynamic starupName;
@dynamic starupDescription;
@dynamic operatingSince;
@dynamic sales;
@dynamic goalInvestment;
@dynamic percentageToGive;
@dynamic starupImage;
@dynamic currentInvestment;

+ (nonnull NSString *)parseClassName
{
    return @"Starup";
}

+ (void)postStarup:(NSString *_Nullable)starupName
            withCategory:(NSString *_Nullable)starupCategory
         withDescription:(NSString *_Nullable)starupDescription
               withImage:(UIImage *_Nullable)starupImage
      withOperationSince:(NSDate *_Nullable)operatingSince
               withSales:(int)sales
      withGoalInvestment:(int)goalInvestment
    withPercentageToGive:(int)percentageToGive
          withCompletion:(void (^)(Starup *starup, NSError *error))completion
{
    //    Method to set the properties of the starup
    Starup *newStarup = [[Starup alloc] initWithClassName:@"Starup"];
    newStarup.starupImage = [Algos getPFFileFromImage:starupImage];
    newStarup.author = [PFUser currentUser];
    newStarup.starupName = starupName;
    newStarup.starupCategory = starupCategory;
    newStarup.starupDescription = starupDescription;
    newStarup.operatingSince = operatingSince;
    newStarup.sales = sales;
    newStarup.goalInvestment = goalInvestment;
    newStarup.currentInvestment = 0;
    newStarup.percentageToGive = percentageToGive;
    [newStarup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        completion(newStarup, error);
    }];
}

@end
