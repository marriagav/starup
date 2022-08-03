//
//  EditProfileViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/13/22.
//

#import "EditProfileViewController.h"


@interface EditProfileViewController () <UITextViewDelegate>

@end


@implementation EditProfileViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set outlets
    [self setOutlets];
    // Add gesture recognizer to dissmiss keyboard when clicking on screen
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    // For the textfield placeholder to work
    self.userBio.delegate = self;
    self.typeHere.hidden = (self.userBio.text.length > 0);
}

- (void)setOutlets
{
    self.usernameOutlet.text = PFUser.currentUser[@"username"];
    self.firstnameOutlet.text = PFUser.currentUser[@"firstname"];
    self.lastnameOutlet.text = PFUser.currentUser[@"lastname"];
    self.userBio.text = PFUser.currentUser[@"userBio"];
    self.roleOutlet.text = PFUser.currentUser[@"role"];
}

#pragma mark - QualityOfLife

- (void)dismissKeyboard
{
    //    Dissmiss the keyboard
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    //    If the text changes the placeholder dissapears
    self.typeHere.hidden = (textView.text.length > 0);
}

#pragma mark - Network

- (void)changeProfileDetails
{
    //    Call to change the profile details
    [PFUser.currentUser setObject:self.usernameOutlet.text forKey:@"username"];
    [PFUser.currentUser setObject:self.firstnameOutlet.text forKey:@"firstname"];
    [PFUser.currentUser setObject:self.lastnameOutlet.text forKey:@"lastname"];
    [PFUser.currentUser setObject:self.userBio.text forKey:@"userBio"];
    [PFUser.currentUser setObject:self.roleOutlet.text forKey:@"role"];
    //    Normalize strings for search
    [PFUser.currentUser setObject:[Algos normalizeFullName:self.firstnameOutlet.text withLastname:self.lastnameOutlet.text] forKey:@"normalizedFullname"];
    [PFUser.currentUser setObject:[Algos normalizeString:self.usernameOutlet.text] forKey:@"normalizedUsername"];
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            // Dismiss UIImagePickerController to go back to your original view controller
            [BIntegrationHelper updateUserWithName:[NSString stringWithFormat:@"%@ %@", self.firstnameOutlet.text, self.lastnameOutlet.text] image:BChatSDK.currentUser.imageAsImage url:BChatSDK.currentUser.imageURL];
            [self.delegate didEdit];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - Actions

- (IBAction)updateOnClick:(id)sender
{
    [self changeProfileDetails];
}

#pragma mark - Navigation

- (IBAction)cancelOnClick:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
