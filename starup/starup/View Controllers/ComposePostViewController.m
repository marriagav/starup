//
//  ComposePostViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "ComposePostViewController.h"


@interface ComposePostViewController () <UITextViewDelegate>

@end


@implementation ComposePostViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setOutlets];
    // Add gesture recognizer to dissmiss keyboard when clicking on screen
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    // For the textfield placeholder to work
    self.captionOutlet.delegate = self;
    self.hasLinkedin = YES;
}

- (void)setOutlets
{
    //  Set the profile picture
    self.imageView.file = PFUser.currentUser[@"profileImage"];
    [self.imageView loadInBackground];
    //    Format the profile picture
    [Algos formatPictureWithRoundedEdges:self.imageView];
    //    Set the dropdown menu
    UIAction *noStatus = [UIAction actionWithTitle:@"Select an option" image:NULL identifier:NULL handler:^(UIAction *action) {
        self.updateStatus = @"Just a thought";
        self.updateImage = [UIImage imageNamed:@"thought-icon-6"];
    }];
    UIAction *postedStarup = [UIAction actionWithTitle:@"Posted a new Starup" image:NULL identifier:NULL handler:^(UIAction *action) {
        self.updateStatus = @"Posted a new Starup";
        self.updateImage = [UIImage imageNamed:@"ideator-1"];
    }];
    UIAction *lookingStarupsJ = [UIAction actionWithTitle:@"Looking for a Starup to join" image:NULL identifier:NULL handler:^(UIAction *action) {
        self.updateStatus = @"Looking for a Starup to join";
        self.updateImage = [UIImage imageNamed:@"hacker-1"];
    }];
    UIAction *lookingStarupsI = [UIAction actionWithTitle:@"Looking for a Starup to invest" image:NULL identifier:NULL handler:^(UIAction *action) {
        self.updateStatus = @"Looking for a Starup to invest";
        self.updateImage = [UIImage imageNamed:@"shark-1"];
    }];
    UIAction *investedStarup = [UIAction actionWithTitle:@"Invested on a Starup" image:NULL identifier:NULL handler:^(UIAction *action) {
        self.updateStatus = @"Invested on a Starup";
        self.updateImage = [UIImage imageNamed:@"shark-1"];
    }];
    UIAction *joinedStarup = [UIAction actionWithTitle:@"Joined a Starup" image:NULL identifier:NULL handler:^(UIAction *action) {
        self.updateStatus = @"Joined a Starup";
        self.updateImage = [UIImage imageNamed:@"hacker-1"];
    }];
    UIAction *postToLinkedin = [UIAction actionWithTitle:@"Post to Linkedin" image:NULL identifier:NULL handler:^(UIAction *action) {
        self.updateStatus = @"Linkedin Post";
        self.updateImage = [UIImage imageNamed:@"LI-In-Bug"];
    }];
    UIMenu *menu = [[UIMenu alloc] menuByReplacingChildren:[NSArray arrayWithObjects:noStatus, postedStarup, lookingStarupsJ, lookingStarupsI, investedStarup, joinedStarup, postToLinkedin, nil]];
    self.dropdownOutlet.menu = menu;
    self.dropdownOutlet.showsMenuAsPrimaryAction = YES;
    self.dropdownOutlet.changesSelectionAsPrimaryAction = YES;
    //    Set default state
    self.updateStatus = @"";
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

- (void)initializeAlertController
{
    //    Create the alert controller for post errors
    UIAlertController *LinkedinError = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Must authenticate with Linkedin"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
    //    Empty fields
    self.textLength = [UIAlertController alertControllerWithTitle:@"Error"
                                                          message:@"Caption cannot be empty"
                                                   preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             self.hasLinkedin = YES;
                                                         }];
    // add the cancel action to the alertControllers
    [LinkedinError addAction:cancelAction];
    [self.textLength addAction:cancelAction];

    if (!(self.hasLinkedin)) {
        [self presentViewController:LinkedinError animated:YES completion:nil];
    }
}

#pragma mark - Network

- (IBAction)makePost:(id)sender
{
    [self initializeAlertController];
    if ([self.captionOutlet.text isEqual:@""]) {
        [self presentViewController:self.textLength animated:YES completion:^{
            nil;
        }];
    } else {
        if ([self.updateStatus isEqual:@""]) {
            //        If no status selected
            self.updateStatus = @"Just a thought";
            self.updateImage = [UIImage imageNamed:@"thought-icon-6"];
        } else if ([self.updateStatus isEqual:@"Linkedin Post"]) {
            //        Make post to likedin if the user wants to
            [self checkIfUserHasLinkedin];
        } else {
            //    Make the post to Starup
            [self makePostToStarup];
        }
    }
}

- (void)makePostToStarup
{
    //    Make the post to Starup
    //    Makes the call to post the post
    //    Shows progress hud
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    Dissables sharebutton so that the user cant spam it
    self.shareButton.enabled = false;
    //    Makes call
    [Post postUserStatus:self.updateStatus withCaption:self.captionOutlet.text withImage:self.updateImage withCompletion:^(BOOL succeeded, NSError *_Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            self.shareButton.enabled = true;
        } else {
            // Calls the didPost method from the delegate and dissmisses the view controller
            [self.delegate didPost];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        // hides progress hud
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)checkIfUserHasLinkedin
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"linkedinAuthentification" equalTo:@"True"];
    [query whereKey:@"username" equalTo:PFUser.currentUser.username];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            if (users.count > 0) {
                [Linkedin postTolinkedin:@"CONNECTIONS" withTextToPost:self.captionOutlet.text];
                [self makePostToStarup];
            } else {
                self.hasLinkedin = NO;
                [self initializeAlertController];
            }
        } else {
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - Navigation

- (IBAction)goBackToHome:(id)sender
{
    // display home view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
