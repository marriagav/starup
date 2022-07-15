//
//  EditProfileViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/13/22.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set outlets
    [self setOutlets];
    // Add gesture recognizer to dissmiss keyboard when clicking on screen
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)setOutlets{
    self.usernameOutlet.text = PFUser.currentUser[@"username"];
    self.firstnameOutlet.text = PFUser.currentUser[@"firstname"];
    self.lastnameOutlet.text = PFUser.currentUser[@"lastname"];
    self.userBio.text = PFUser.currentUser[@"userBio"];
    self.roleOutlet.text =  PFUser.currentUser[@"role"];
}

#pragma mark - QualityOfLife

- (void)dismissKeyboard{
    //    Dissmiss the keyboard
    [self.view endEditing:YES];
}

#pragma mark - Network

- (void)changeProfileDetails{
    //    Call to change the profile details
    [PFUser.currentUser setObject:self.usernameOutlet.text forKey: @"username"];
    [PFUser.currentUser setObject:self.firstnameOutlet.text forKey: @"firstname"];
    [PFUser.currentUser setObject:self.lastnameOutlet.text forKey: @"lastname"];
    [PFUser.currentUser setObject:self.userBio.text forKey: @"userBio"];
    [PFUser.currentUser setObject:self.roleOutlet.text forKey: @"role"];
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            // Dismiss UIImagePickerController to go back to your original view controller
            [self.delegate didEdit];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - Actions

- (IBAction)updateOnClick:(id)sender {
    [self changeProfileDetails];
}

#pragma mark - Navigation

- (IBAction)cancelOnClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
