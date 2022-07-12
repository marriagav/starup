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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setOutlets];
    // Add gesture recognizer to dissmiss keyboard when clicking on screen
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    // For the textfield placeholder to work
    self.captionOutlet.delegate=self;
}

- (void)setOutlets{
    //  Set the profile picture
    self.imageView.file = PFUser.currentUser[@"profileImage"];
    [self.imageView loadInBackground];
    //    Format the profile picture
    [Algos formatPictureWithRoundedEdges:self.imageView];
    //    Set the dropdown menu
    UIAction *postedStarup = [UIAction actionWithTitle:@"Posted a new Starup" image:NULL identifier:NULL handler:^(UIAction* action){
        self.updateStatus = @"Posted a new Starup";
        self.updateImage = [UIImage imageNamed:@"ideator-1"];
    }];
    UIAction *lookingStarupsJ = [UIAction actionWithTitle:@"Looking for a Starup to join" image:NULL identifier:NULL handler:^(UIAction* action){
        self.updateStatus = @"Looking for a Starup to join";
        self.updateImage = [UIImage imageNamed:@"hacker-1"];
    }];
    UIAction *lookingStarupsI = [UIAction actionWithTitle:@"Looking for a Starup to invest" image:NULL identifier:NULL handler:^(UIAction* action){
        self.updateStatus = @"Looking for a Starup to invest";
        self.updateImage = [UIImage imageNamed:@"shark-1"];
    }];
    UIAction *investedStarup = [UIAction actionWithTitle:@"Invested on a Starup" image:NULL identifier:NULL handler:^(UIAction* action){
        self.updateStatus = @"Invested on a Starup";
        self.updateImage = [UIImage imageNamed:@"shark-1"];
    }];
    UIAction *joinedStarup = [UIAction actionWithTitle:@"Joined a Starup" image:NULL identifier:NULL handler:^(UIAction* action){
        self.updateStatus = @"Joined a Starup";
        self.updateImage = [UIImage imageNamed:@"hacker-1"];
    }];
    UIMenu *menu = [[UIMenu alloc] menuByReplacingChildren:[NSArray arrayWithObjects:postedStarup, lookingStarupsJ, lookingStarupsI, investedStarup, joinedStarup, nil]];
    self.dropdownOutlet.menu = menu;
    self.dropdownOutlet.showsMenuAsPrimaryAction = YES;
    self.dropdownOutlet.changesSelectionAsPrimaryAction= YES;
}

- (void)dismissKeyboard{
    //    Dissmiss the keyboard
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    //    If the text changes the placeholder dissapears
    self.typeHere.hidden=(textView.text.length>0);
}

- (IBAction)makePost:(id)sender {
    //    Makes the call to post the post
    //    Shows progress hud
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    Dissables sharebutton so that the user cant spam it
    self.shareButton.enabled = false;
    //    Makes call
    [Post postUserStatus:self.updateStatus withCaption:self.captionOutlet.text withImage:self.updateImage withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error){
            NSLog(@"%@", error);
        }
        else{
            // Calls the didPost method from the delegate and dissmisses the view controller
            [self.delegate didPost];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        // hides progress hud
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    ];
}

- (IBAction)goBackToHome:(id)sender {
    // display home view controller
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *nav = [storyboard instantiateViewControllerWithIdentifier:@"navBar"];
    [nav setModalPresentationStyle:UIModalPresentationFullScreen];
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
