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
@dynamic ideators;
@dynamic sharks;
@dynamic hackers;

+ (nonnull NSString *)parseClassName {
    return @"Starup";
}

+ (void) postStarup: ( NSString * _Nullable )starupName withCategory: ( NSString * _Nullable )starupCategory withDescription: ( NSString * _Nullable )starupDescription withImage:( UIImage * _Nullable )starupImage withOperationSince: ( NSDate * _Nullable )operatingSince withSales: ( int )sales withGoalInvestment: ( int )goalInvestment withPercentageToGive: ( int )percentageToGive withSharks: (NSMutableArray<PFUser*>* _Nullable) sharks withIdeators: (NSMutableArray<PFUser*>* _Nullable) ideators withHackers: (NSMutableArray<PFUser*>* _Nullable) hackers withCompletion: (PFBooleanResultBlock  _Nullable)completion {
//    Method to set the properties of the starup
    Starup *newStarup= [[Starup alloc]initWithClassName:@"Starup"];
    newStarup.starupImage = [Algos getPFFileFromImage:starupImage];
    newStarup.author = [PFUser currentUser];
    newStarup.starupName = starupName;
    newStarup.starupCategory = starupCategory;
    newStarup.starupDescription = starupDescription;
    newStarup.operatingSince = operatingSince;
    newStarup.sales = sales;
    newStarup.goalInvestment= goalInvestment;
    newStarup.percentageToGive = percentageToGive;
    NSLog(@"%@", ideators);
    newStarup.ideators = ideators;
    newStarup.sharks= sharks;
    newStarup.hackers = hackers;
    [newStarup saveInBackgroundWithBlock: completion];
}

@end
