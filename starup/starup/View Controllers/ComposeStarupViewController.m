//
//  ComposeStarupViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "ComposeStarupViewController.h"

@interface ComposeStarupViewController ()

@end

@implementation ComposeStarupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dismissKeyboard{
//    Dissmiss the keyboard
     [self.view endEditing:YES];
}

- (void)didTapImage:(UITapGestureRecognizer *)sender{
//    Gets called when the user taps on the image placeholder, creating and opening an UIImagePickerController
    
}

- (void)textViewDidChange:(UITextView *)textView{
//    If the text changes the placeholder dissapears

}

- (void)pictureGestureRecognizer:(UIImageView *)image{
    //Method to set up a tap gesture recognizer for an image
    UITapGestureRecognizer *imageTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapImage:)];
    [image addGestureRecognizer:imageTapGestureRecognizer];
    [image setUserInteractionEnabled:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    
    // Resize the image
    
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postStarup:(id)sender {
//    Makes the call to post the starup to the db
//    Shows progress hud
    
//    Dissables sharebutton so that the user cant spam it
    
//    Makes call
    
}

//TODO: way to select collaborators
//TODO: set up collection views

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
