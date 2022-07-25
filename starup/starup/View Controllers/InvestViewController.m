//
//  InvestViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "InvestViewController.h"

@interface InvestViewController ()

@end

@implementation InvestViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setUpLabels];
    [self.investOutlet addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)_setUpLabels {
    //    Sets up the labels of the details view
    self.goalInv = self.starup[@"goalInvestment"];
    self.totalPercent = self.starup[@"percentageToGive"];
    self.starupName.text = self.starup[@"starupName"];
    self.hasError = NO;
    [self _getMaxInvestment];
}

- (void)initializeAlertController{
    //    Create the alert controller for login errors
    UIAlertController *investError = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:@"Investment off limits, must be lowered"
                                                                 preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // handle try again response here. Doing nothing will dismiss the view.
    }];
    // add the cancel action to the alertControllers
    [investError addAction:cancelAction];
    
    if ([self.investOutlet.text floatValue] > self.maxInvestment){
        self.hasError = YES;
        [self presentViewController:investError animated:YES completion:nil];
    }
}

#pragma mark - Calculations

- (void)_getMaxInvestment {
    //    Calculate the percentage gained from investing x amount
    NSNumber* currentInv = self.starup[@"currentInvestment"];
    self.maxInvestment = [self.goalInv floatValue] - [currentInv floatValue];
    self.maxInvestOutlet.text = [NSString stringWithFormat:@"%@%.0f", @"max:", self.maxInvestment];
}

- (void)_getPercentage: (float) amount {
    //    Calculate the percentage gained from investing x amount
    self.percentageToGet = amount * [self.totalPercent floatValue] / [self.goalInv floatValue];
    self.percentageOutlet.text = [NSString stringWithFormat:@"%@%.04f", @"%", self.percentageToGet];
}

- (void)textFieldDidChange :(UITextField *) textField{
    [self _getPercentage:[self.investOutlet.text floatValue]];
}

#pragma mark - Network

- (void)updateServerWithInvestment{
    //    Shows progress hud
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    Dissables invest button so that the user cant spam it
    self.investButton.enabled = false;
    
    //    Call to change the starup investment percent
    int newInvestment = [self.starup[@"currentInvestment"] intValue] + [self.investOutlet.text floatValue];
    
//    If the user is already a shark, dont duplicate collaborator, only update their ownership
    [self checkIfIsShark:newInvestment];
}

-(void)updateStarupInvestment: (int)newInvestment{
    // Update starup investment
    PFQuery *query = [PFQuery queryWithClassName:@"Starup"];
    [query getObjectInBackgroundWithId:self.starup.objectId
                                 block:^(PFObject *parseObject, NSError *error) {
        parseObject[@"currentInvestment"] = [NSNumber numberWithInt:newInvestment];
        [parseObject saveInBackground];
        [self.delegate didInvest];
        [self dismissViewControllerAnimated:YES completion:nil];
        // hides progress hud
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)checkIfIsShark: (int)newInvestment{
    
    PFQuery *find = [PFQuery queryWithClassName:@"Collaborator"];
    [find includeKey:@"user"];
    [find includeKey:@"starup"];
    [find whereKey:@"typeOfUser" equalTo:@"Shark"];
    [find whereKey:@"user" equalTo:PFUser.currentUser];
    [find whereKey:@"starup" equalTo:self.starup];
    [find getFirstObjectInBackgroundWithBlock: ^(PFObject *parseObject, NSError *error) {
        if (parseObject){
            float currOwnership = [parseObject[@"ownership"] floatValue];
            parseObject[@"ownership"] = [NSNumber numberWithFloat: currOwnership+self.percentageToGet];
            [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    [self updateStarupInvestment:newInvestment];
                }
            }];
        }
        else{
//            Create collaborator and add to db
            [Collaborator postCollaborator:@"Shark" withUser:PFUser.currentUser withStarup:self.starup withOwnership:[NSNumber numberWithFloat: self.percentageToGet] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    [self updateStarupInvestment:newInvestment];
                }
            }];
        }
    }];
}

- (IBAction)invest:(id)sender {
    [self initializeAlertController];
    if (!self.hasError){
        //        TODO: go to payment selection
        [self updateServerWithInvestment];
    }
    else{
        self.hasError = NO;
    }
}

#pragma mark - Navigation

- (IBAction)goBack:(id)sender {
    // display starups view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
