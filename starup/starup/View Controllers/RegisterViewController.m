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

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Add gesture recognizer to dissmiss keyboard when clicking on screen
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    // Error should be set to empty initially
    self.error = @"";
    self.correctLogin = @"";
}

#pragma mark - QualityOfLife

- (void)dismissKeyboard
{
    //    Dissmiss the keyboard
    [self.view endEditing:YES];
}

- (void)initializeAlertController
{
    //    Create the alert controller for register errors
    UIAlertController *registerError = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:self.error
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
    //    Create the alert controller for email verification
    UIAlertController *emailVerify = [UIAlertController alertControllerWithTitle:@"Please verify email"
                                                                         message:@"An email has been sent to your address for verification!"
                                                                  preferredStyle:(UIAlertControllerStyleAlert)];
    //    Empty fields
    self.emptyFields = [UIAlertController alertControllerWithTitle:@"Error"
                                                           message:@"Empty Fields"
                                                    preferredStyle:(UIAlertControllerStyleAlert)];
    //    Empty fields
    self.passwordLength = [UIAlertController alertControllerWithTitle:@"Error"
                                                              message:@"Password must be at least 6 characters long"
                                                       preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                         }];
    // create an ok action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                         //Logout the user
                                                         [PFUser logOutInBackground];
                                                         // display the login view controller to ensure email verification
                                                         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
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
    [self.emptyFields addAction:cancelAction];
    [self.passwordLength addAction:cancelAction];

    if (![self.error isEqual:@""]) {
        [self presentViewController:registerError animated:YES completion:^{
            self.error = @"";
        }];
    }
    if (![self.correctLogin isEqual:@""]) {
        [self presentViewController:emailVerify animated:YES completion:^{
            self.correctLogin = @"";
        }];
    }
}

#pragma mark - Network

- (void)registerUser
{
    //    Method that registers the user
    // initialize a user object
    PFUser *newUser = [PFUser user];

    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser.email = self.emailField.text;
    newUser[@"firstname"] = self.firstNameField.text;
    newUser[@"lastname"] = self.lastNameField.text;

    //    Normalize strings for search
    newUser[@"normalizedFullname"] = [Algos normalizeFullName:self.firstNameField.text withLastname:self.lastNameField.text];
    newUser[@"normalizedUsername"] = [Algos normalizeString:self.usernameField.text];

    newUser[@"role"] = self.roleField.text;
    newUser[@"linkedinAuthentification"] = @"False";
    UIImage *image = [UIImage imageNamed:@"default_user_image"];
    [newUser setObject:[Algos getPFFileFromImage:image] forKey:@"profileImage"];

    [self initializeAlertController];
    if (([self.emailField.text isEqual:@""]) | ([self.firstNameField.text isEqual:@""]) | ([self.lastNameField.text isEqual:@""]) | ([self.roleField.text isEqual:@""])) {
        [self presentViewController:self.emptyFields animated:YES completion:^{
            nil;
        }];
    } else if (self.passwordField.text.length < 6) {
        [self presentViewController:self.passwordLength animated:YES completion:^{
            nil;
        }];
    } else {
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                //    Initialize alert controller in case of errors
                self.error = error.localizedDescription;
                [self initializeAlertController];
            } else {
                // successful register means we need to register the user in the chats SDK
                BAccountDetails *accountDetails = [BAccountDetails signUp:self.emailField.text password:self.passwordField.text];
                [BChatSDK.auth authenticate:accountDetails].thenOnMain(
                    ^id(id result) {
                        [BIntegrationHelper updateUserWithName:[NSString stringWithFormat:@"%@ %@", self.firstNameField.text, self.lastNameField.text] image:image url:[Algos imageToString:image]];
                        [PFUser.currentUser setObject:[BChatSDK currentUserID] forKey:@"chatsId"];
                        [PFUser.currentUser save];
                        NSLog(@"User registered successfully");
                        self.correctLogin = @"YES";
                        [self initializeAlertController];
                        return result;
                    }, ^id(NSError *error) {
                        NSLog(@"%@", error);
                        return error;
                    });
            }
        }];
    }
}

#pragma mark - Actions

- (IBAction)registerOnClick:(id)sender
{
    [self registerUser];
}

@end
