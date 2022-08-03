//
//  PasswordViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/20/22.
//

#import "PasswordViewController.h"


@interface PasswordViewController ()

@end


@implementation PasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setInstruction];
}

- (void)setInstruction
{
    if (self.newUser) {
        self.instructionOutlet.text = @"Set your password";
        self.passwordField.placeholder = @"Different from your Linkedin password...";
    } else {
        self.instructionOutlet.text = @"Enter your password";
    }
}

- (void)initializeAlertController
{
    //    Empty fields
    self.passwordLength = [UIAlertController alertControllerWithTitle:@"Error"
                                                              message:@"Password must be at least 6 characters long"
                                                       preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                         }];
    [self.passwordLength addAction:cancelAction];
}

- (IBAction)continueOnClick:(id)sender
{
    [self initializeAlertController];
    if (self.newUser) {
        if (self.passwordField.text.length < 6) {
            [self presentViewController:self.passwordLength animated:YES completion:^{
                nil;
            }];
        } else {
            [self.delegate didPressNextRegister:self.passwordField.text];
        }
    } else {
        [self.delegate didPressNextLogin:self.passwordField.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goBack:(id)sender
{
    // dissmiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
