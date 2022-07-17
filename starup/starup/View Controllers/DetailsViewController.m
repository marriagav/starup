//
//  DetailsViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setUpLabels];
}

- (void)_setUpLabels {
    //    Sets up the labels of the details view
    self.starupName.text = self.starup[@"starupName"];
    self.starupCategory.text = [self.starup[@"starupCategory"] capitalizedString];
    self.sales.text = [NSString stringWithFormat:@"%@%@", @"Sales ~ $", self.starup[@"sales"]];
    self.starupDescription.text = self.starup[@"starupDescription"];
    NSDate *date = self.starup[@"operatingSince"];
    self.operatingSince.text = [NSString stringWithFormat:@"%@%ld", @"Operating since: ", (long)date.year];
    self.starupImage.file = self.starup[@"starupImage"];
    [self.starupImage loadInBackground];
    [self setProgressBar];
}

- (void)setProgressBar{
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 7.0f);
    self.investmentProgressBar.transform = transform;
    [self updateProgressBar];
}

- (void)updateProgressBar{
    NSNumber* currentInv = self.starup[@"currentInvestment"];
    NSNumber* goalInv = self.starup[@"goalInvestment"];
    self.progressString.text = [NSString stringWithFormat:@"%@$%@ / $%@", @"Progress: ", currentInv, goalInv];
    self.investmentProgressBar.progress = [Algos percentageWithNumbers:[currentInv floatValue] :[goalInv floatValue]];
}

- (IBAction)goBack:(id)sender {
    // display starups view controller
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UITabBarController *nav = [storyboard instantiateViewControllerWithIdentifier:@"navBar"];
    [nav setModalPresentationStyle:UIModalPresentationFullScreen];
    [nav setSelectedViewController:[nav.viewControllers objectAtIndex:1]];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
