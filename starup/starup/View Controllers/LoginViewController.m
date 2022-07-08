//
//  LoginViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add gesture recognizer to dissmiss keyboard when clicking on screen
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
//    Error should be set to empty initially
    self.error = @"";
}

- (void)dismissKeyboard{
//    Dissmiss the keyboard
     [self.view endEditing:YES];
}

- (void)loginUser {
//    Method that logs the user in
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
//    Call log in function on the object
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            //    Initialize alert controller if there is an error
            self.error = error.localizedDescription;
            [self initializeAlertController];
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UIViewController *nav = [storyboard instantiateViewControllerWithIdentifier:@"navBar"];
            [nav setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }];
}

- (IBAction)loginOnClick:(id)sender {
    [self loginUser];
}

- (IBAction)registerOnClick:(id)sender {
    // display register view controller
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"registerView"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initializeAlertController{
//    Create the alert controller for login errors
    UIAlertController *loginError = [UIAlertController alertControllerWithTitle:@"Error"
                    message:self.error
                    preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again"
                    style:UIAlertActionStyleCancel
                    handler:^(UIAlertAction * _Nonnull action) {
                    // handle try again response here. Doing nothing will dismiss the view.
                    }];
    // add the cancel action to the alertControllers
    [loginError addAction:cancelAction];
    
    if (![self.error isEqual:@""]){
        [self presentViewController:loginError animated:YES completion:^{
            self.error = @"";
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
