//
//  LoginViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "LoginViewController.h"

@interface LoginViewController () <PasswordViewControllerDelegate>

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

- (void)loginUser: (NSString *)username :(NSString *)password{
    //    Method that logs the user in
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
            [self afterSuccessfullLogin];
        }
    }];
}

- (void)registerUserWithLinkedin {
    //    Method that registers the user
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    //    the username is a combination of users name, lastname and id from linkedin
    newUser.username = self.linkedinUsername;
    newUser.password = self.password;
    newUser.email = self.linkedinEmail;
    newUser[@"firstname"] = self.linkedinFName;
    newUser[@"lastname"] = self.linkedinLName;
    newUser[@"linkedinAuthentification"] = @"True";
    UIImage *image =  self.imageLinkedin;
    [newUser setObject:[Algos getPFFileFromImage:image] forKey: @"profileImage"];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            // successful register means we need to log the user in
            [self loginUser:newUser.username :newUser.password];
        }
    }];
}

- (void)checkIfUserExists {
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:self.linkedinEmail];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            if (users != nil) {
                if (users.count>0){
                    [self requestUserPassword:NO];
                }
                else{
                    [self requestUserPassword:YES];
                }
            } else {
                NSLog(@"%@", error);
            }
        }];
}

#pragma mark - Actions

- (IBAction)loginOnClick:(id)sender {
    [self loginUser:self.usernameField.text :self.passwordField.text];
}

- (IBAction)registerOnClick:(id)sender {
    // display register view controller
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"registerView"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)logInLinkedin:(id)sender {
    [self fetchUserInformations];
}

#pragma mark - Linkedin API

- (void)fetchUserInformations {
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    
    linkedIn.cancelButtonText = @"Close"; // Or any other language But Default is Close
    
    NSArray *permissions = @[@(ContactInfo),
                             @(EmailAddress),
                             @(Share)];
    
    linkedIn.showActivityIndicator = YES;
    
#warning - Your LinkedIn App ClientId - ClientSecret - RedirectUrl
    [linkedIn requestMeWithSenderViewController:self
                                       clientId:@"86j2dodya1oazo"         // Your App Client Id
                                   clientSecret:@"t9WeE5hll2xaqXnL"         // Your App Client Secret
                                    redirectUrl:@"http://starupcode.com"         // Your App Redirect Url
                                    permissions:permissions
                                          state:@"authState"               // Your client state
                                successUserInfo:^(NSDictionary *userInfo) {
        // Save User Info
        NSLog(@"user : %@", userInfo);
        NSDictionary *linkedinFName = userInfo[@"firstName"][@"localized"];
        self.linkedinFName = [Algos firstObjectFromDict:linkedinFName];
        self.linkedinID = [userInfo[@"id"] substringToIndex:3];
        NSDictionary *linkedinLName = userInfo[@"lastName"][@"localized"];
        self.linkedinLName = [Algos firstObjectFromDict:linkedinLName];
        NSArray *elementsOfPicture = userInfo[@"profilePicture"][@"displayImage~"][@"elements"];
        NSDictionary *urlOfImageDict =  elementsOfPicture[0];
        NSDictionary *urlOfimageIdentifiers = [urlOfImageDict valueForKey:@"identifiers"];
        NSArray *imageURLLinkedin = [urlOfimageIdentifiers valueForKey:@"identifier"];
        self.imageLinkedin = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: imageURLLinkedin[0]]]];
        //    the username is a combination of users name, lastname and id from linkedin
        self.linkedinUsername = [NSString stringWithFormat:@"%@_%@_%@", self.linkedinFName , self.linkedinLName, self.linkedinID];
        //        Get the email address
        [linkedIn requestEmailWithToken:^(NSDictionary *response, NSError *error) {
            NSDictionary *emailHandle = response[@"elements"];
            NSArray *userEmailArray = [[emailHandle valueForKey:@"handle~"] valueForKey:@"emailAddress"];
            //            Save email address
            self.linkedinEmail = userEmailArray[0];
            //        Checks if the user already exists to determine if new user needs to be created
            [self checkIfUserExists];
        }];
        
    }
                              failUserInfoBlock:^(NSError *error) {
        NSLog(@"error : %@", error.userInfo.description);
    }
    ];
}

- (void)requestUserPassword: (BOOL)isNewUser{
    //     display password view
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        PasswordViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"passwordView"];
        vc.newUser = isNewUser;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:navigationController animated:YES completion:^{
            // Pass the delegate
            vc.delegate = weakSelf;
        }];
    });
}

- (void)didPressNextRegister:(NSString *)password{
    self.password = password;
    [self registerUserWithLinkedin];
}

- (void)didPressNextLogin:(NSString *)password{
    self.password = password;
    [self loginUser:self.linkedinUsername :self.password];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)afterSuccessfullLogin{
    // display view controller that needs to shown after successful login
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *nav = [storyboard instantiateViewControllerWithIdentifier:@"navBar"];
    [nav setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

@end
