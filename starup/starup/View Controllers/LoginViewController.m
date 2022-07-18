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

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add gesture recognizer to dissmiss keyboard when clicking on screen
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    //    Error should be set to empty initially
    self.error = @"";
//    [self fetchUserInformations];
}

#pragma mark - QualityOfLife

- (void)dismissKeyboard{
    //    Dissmiss the keyboard
    [self.view endEditing:YES];
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

#pragma mark - Network

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

#pragma mark - Actions

- (IBAction)loginOnClick:(id)sender {
    [self loginUser];
}

- (IBAction)registerOnClick:(id)sender {
    // display register view controller
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"registerView"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Linkedin API

- (void)fetchUserInformations {
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];

    linkedIn.cancelButtonText = @"Close"; // Or any other language But Default is Close
    
    NSArray *permissions = @[@(BasicProfile),
                            @(EmailAddress),
                            @(Share),
                            @(CompanyAdmin)];
        
    linkedIn.showActivityIndicator = YES;
        
#warning - Your LinkedIn App ClientId - ClientSecret - RedirectUrl
    [linkedIn requestMeWithSenderViewController:self
                                       clientId:@"86j2dodya1oazo"         // Your App Client Id
                                   clientSecret:@"t9WeE5hll2xaqXnL"         // Your App Client Secret
                                    redirectUrl:@"https://www.linkedin.com/developers/tools/oauth/redirect"         // Your App Redirect Url
                                    permissions:permissions
                                          state:@"authState"               // Your client state
                                successUserInfo:^(NSDictionary *userInfo) {
                                    // Whole User Info
                                    NSLog(@"user Info : %@", userInfo);
                                }
                                failUserInfoBlock:^(NSError *error) {
                                    NSLog(@"error : %@", error.userInfo.description);
                                }
    ];
}

- (BOOL)isLinkedInAccessTokenValid {
    return [LinkedInHelper sharedInstance].isValidToken;
}

-  (void)getUserInfo {
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    
    // If user has already connected via linkedin in and access token is still valid then
    // No need to fetch authorizationCode and then accessToken again!
    
    #warning - To fetch user info  automatically without getting authorization code, accessToken must be still valid
    
    if (linkedIn.isValidToken) {
                
        // So Fetch member info by elderyly access token
        [linkedIn autoFetchUserInfoWithSuccess:^(NSDictionary *userInfo) {
            // Whole User Info
            NSLog(@"user Info : %@", userInfo);
        } failUserInfo:^(NSError *error) {
            NSLog(@"error : %@", error.userInfo.description);
        }];
    }
}

@end
