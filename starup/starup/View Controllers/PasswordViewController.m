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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setInstruction];
}

- (void)setInstruction{
    
}

- (IBAction)continueOnClick:(id)sender {
    [self.delegate didPressNext:self.passwordField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goBack:(id)sender {
    // dissmiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
