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

- (IBAction)continueOnClick:(id)sender
{
    if (self.newUser) {
        [self.delegate didPressNextRegister:self.passwordField.text];
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
