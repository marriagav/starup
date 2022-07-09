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
    // Error should be set to empty initially
    self.error = @"";
    self.correctLogin = @"";
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
    newUser[@"firstname"] = self.firstNameField.text;
    newUser[@"lastname"] = self.lastNameField.text;
    newUser[@"role"] = self.roleField.text;
    
    
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            //    Initialize alert controller in case of errors
            self.error = error.localizedDescription;
            [self initializeAlertController];
        } else {
            NSLog(@"User registered successfully");
            self.correctLogin = @"YES";
            [self initializeAlertController];
            
        }
    }];
}

- (IBAction)registerOnClick:(id)sender {
    [self registerUser];
}

- (void)initializeAlertController{
    //    Create the alert controller for register errors
    UIAlertController *registerError = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:self.error
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
    //    Create the alert controller for email verification
    UIAlertController *emailVerify = [UIAlertController alertControllerWithTitle:@"Please verify email"
                                                                         message:@"An email has been sent to your address for verification!"
                                                                  preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // handle try again response here. Doing nothing will dismiss the view.
    }];
    // create an ok action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
        //Logout the user
        [PFUser logOutInBackground];
        // display the login view controller to ensure email verification
        UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginNoNav"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [navigationController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.navigationController presentViewController:navigationController animated:YES completion:^{
            //                            Pass the username so that the user doesnt need to type again
            loginViewController.usernameField.text = self.usernameField.text;
        }];
    }];
    // add the cancel action to the alertControllers
    [registerError addAction:cancelAction];
    [emailVerify addAction:okAction];
    
    if (![self.error isEqual:@""]){
        [self presentViewController:registerError animated:YES completion:^{
            self.error = @"";
        }];
    }
    if (![self.correctLogin isEqual:@""]){
        [self presentViewController:emailVerify animated:YES completion:^{
            self.correctLogin = @"";
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
