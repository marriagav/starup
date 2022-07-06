//
//  RegisterViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add gesture recognizer to dissmiss keyboard when clicking on screen
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)dismissKeyboard{
//    Dissmiss the keyboard
     [self.view endEditing:YES];
}


- (void)registerUser {
//    Method that registers the user
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser.email = self.emailField.text;
    newUser[@"firstName"] = self.firstNameField.text;
    newUser[@"lastName"] = self.lastNameField.text;
    newUser[@"userRole"] = self.roleField.text;
    
    
//    Initialize alert controller
    [self initializeAlertController];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // display view controller that needs to shown after successful login
            UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UIViewController *nav = [storyboard instantiateViewControllerWithIdentifier:@"homeFeed"];
            [nav setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController presentViewController:nav animated:YES completion:nil];

        }
    }];
}

- (IBAction)registerOnClick:(id)sender {
    [self registerUser];
}

- (void)initializeAlertController{
//    Create the alert controller
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                    message:@"Empty Field"
                    preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again"
                    style:UIAlertActionStyleCancel
                    handler:^(UIAlertAction * _Nonnull action) {
                    // handle try again response here. Doing nothing will dismiss the view.
                    }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""] || [self.emailField.text isEqual:@""] || [self.firstNameField.text isEqual:@""] || [self.lastNameField.text isEqual:@""]){
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
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
