//
//  InvestViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "InvestViewController.h"

@interface InvestViewController ()

@end

@implementation InvestViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setUpLabels];
    [self.investOutlet addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)_setUpLabels {
    //    Sets up the labels of the details view
    self.goalInv = self.starup[@"goalInvestment"];
    self.totalPercent = self.starup[@"percentageToGive"];
    self.starupName.text = self.starup[@"starupName"];
    self.hasError = NO;
    [self _getMaxInvestment];
}

- (void)initializeAlertController{
    //    Create the alert controller for login errors
    UIAlertController *investError = [UIAlertController alertControllerWithTitle:@"Error"
                                                                         message:@"Investment off limits, must be lowered"
                                                                  preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // handle try again response here. Doing nothing will dismiss the view.
    }];
    // add the cancel action to the alertControllers
    [investError addAction:cancelAction];
    
    if ([self.investOutlet.text floatValue] > self.maxInvestment){
        self.hasError = YES;
        [self presentViewController:investError animated:YES completion:nil];
    }
}

#pragma mark - Calculations

- (void)_getMaxInvestment {
    //    Calculate the percentage gained from investing x amount
    NSNumber* currentInv = self.starup[@"currentInvestment"];
    self.maxInvestment = [self.goalInv floatValue] - [currentInv floatValue];
    self.maxInvestOutlet.text = [NSString stringWithFormat:@"%@%.0f", @"max:", self.maxInvestment];
}

- (void)_getPercentage: (float) amount {
    //    Calculate the percentage gained from investing x amount
    self.percentageToGet = amount * [self.totalPercent floatValue] / [self.goalInv floatValue];
    self.percentageOutlet.text = [NSString stringWithFormat:@"%@%.04f", @"%", self.percentageToGet];
}

- (void)textFieldDidChange :(UITextField *) textField{
    [self _getPercentage:[self.investOutlet.text floatValue]];
}

#pragma mark - Network

- (void)updateServerWithInvestment{
    //    Shows progress hud
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    Dissables invest button so that the user cant spam it
    self.investButton.enabled = false;
    
    //    Call to change the starup investment percent
    int newInvestment = [self.starup[@"currentInvestment"] intValue] + [self.investOutlet.text floatValue];
    
    //    If the user is already a shark, dont duplicate collaborator, only update their ownership
    [self checkIfIsShark:newInvestment];
}

-(void)updateStarupInvestment: (int)newInvestment{
    // Update starup investment
    PFQuery *query = [PFQuery queryWithClassName:@"Starup"];
    [query getObjectInBackgroundWithId:self.starup.objectId
                                 block:^(PFObject *parseObject, NSError *error) {
        parseObject[@"currentInvestment"] = [NSNumber numberWithInt:newInvestment];
        [parseObject saveInBackground];
        [self.delegate didInvest];
        [self dismissViewControllerAnimated:YES completion:nil];
        // hides progress hud
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)checkIfIsShark: (int)newInvestment{
    
    PFQuery *find = [PFQuery queryWithClassName:@"Collaborator"];
    [find includeKey:@"user"];
    [find includeKey:@"starup"];
    [find whereKey:@"typeOfUser" equalTo:@"Shark"];
    [find whereKey:@"user" equalTo:PFUser.currentUser];
    [find whereKey:@"starup" equalTo:self.starup];
    [find getFirstObjectInBackgroundWithBlock: ^(PFObject *parseObject, NSError *error) {
        if (parseObject){
            float currOwnership = [parseObject[@"ownership"] floatValue];
            parseObject[@"ownership"] = [NSNumber numberWithFloat: currOwnership+self.percentageToGet];
            [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    [self updateStarupInvestment:newInvestment];
                }
            }];
        }
        else{
            //            Create collaborator and add to db
            [Collaborator postCollaborator:@"Shark" withUser:PFUser.currentUser withStarup:self.starup withOwnership:[NSNumber numberWithFloat: self.percentageToGet] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    [self updateStarupInvestment:newInvestment];
                }
            }];
        }
    }];
}

#pragma mark - PayPal

- (IBAction)invest:(id)sender {
    [self initializeAlertController];
    if (!self.hasError){
        [self startCheckout];
    }
    else{
        self.hasError = NO;
    }
}

#pragma mark - PayPal

- (void)startCheckout {
    [PPCheckout startWithPresentingViewController:self createOrder:^(PPCCreateOrderAction * action) {
        [self createOrderCallbackCreateOrderWithAction:action];
    } onApprove:^(PPCApproval * approval) {
        [self onApproveCallbackWithApproval:approval];
    } onShippingChange:nil
                                         onCancel:^{
        [self onCancelCallback];
    } onError:^(PPCErrorInfo * errorInfo) {
        [self onErrorCallbackWithErrorInfo:errorInfo];
    }];
}

- (PPCOrderRequest*)createNewOrder {
    NSString *total = self.investOutlet.text;
    NSString *itemTotal = self.investOutlet.text;
    NSString *taxTotal = @"0";
    
    NSString *description = [NSString stringWithFormat:@"Investment for starup: %@",self.starupName.text];
    PPCUnitAmount *itemTotalUnitAmount = [[PPCUnitAmount alloc] initWithCurrencyCode:PPCCurrencyCodeUsd
                                                                            value:itemTotal];
    PPCUnitAmount *taxTotalUnitAmount = [[PPCUnitAmount alloc] initWithCurrencyCode:PPCCurrencyCodeUsd
                                                                              value:taxTotal];
    
    PPCPurchaseUnitItem *itemBought = [[PPCPurchaseUnitItem alloc]initWithName:description unitAmount:itemTotalUnitAmount quantity:@"1" tax:nil itemDescription:description sku:nil category:PPCPurchaseUnitCategoryDigitalGoods];
    NSArray<PPCPurchaseUnitItem *> * itemArray = [[NSArray alloc] initWithObjects:itemBought, nil];
    
    PPCPurchaseUnitBreakdown *purchaseUnitBreakdown = [[PPCPurchaseUnitBreakdown alloc] initWithItemTotal:itemTotalUnitAmount
                                                                                                 shipping:nil
                                                                                                 handling:nil
                                                                                                 taxTotal:taxTotalUnitAmount
                                                                                                insurance:nil
                                                                                         shippingDiscount:nil
                                                                                                 discount:nil];
    
    PPCPurchaseUnitAmount *purchaseUnitAmount = [[PPCPurchaseUnitAmount alloc] initWithCurrencyCode:PPCCurrencyCodeUsd
                                                                                              value:total
                                                                                          breakdown:purchaseUnitBreakdown];
    
    PPCPurchaseUnit *purchaseUnit = [[PPCPurchaseUnit alloc] initWithAmount:purchaseUnitAmount
                                                                referenceId:nil
                                                                      payee:nil
                                                         paymentInstruction:nil
                                                    purchaseUnitDescription:description
                                                                   customId:nil
                                                                  invoiceId:nil
                                                             softDescriptor:nil
                                                                      items:itemArray
                                                                   shipping:nil];
    
    PPCOrderRequest *order = [[PPCOrderRequest alloc] initWithIntent:PPCOrderIntentCapture purchaseUnits:@[purchaseUnit] processingInstruction:PPCOrderProcessingInstructionNone payer:nil applicationContext:nil];
    
    return order;
}

/// createOrder callback:
/// This will be called when PayPalCheckout starts creating an order
/// Use this if you want PayPalCheckout to create an order and get an order ID for you internally via PayPal Orders API
- (void)createOrderCallbackCreateOrderWithAction:(PPCCreateOrderAction *)action {
    PPCOrderRequest *order = [self createNewOrder];
    [action createWithOrder:order completion:^(NSString *orderId) {
        NSLog(@"Order created with orderId: %@", orderId);
    }];
}

/// onApprove callback: This will be called when checkout with PayPalCheckout is completed, you will need to handle authorizing or capturing the funds in this callback
- (void)onApproveCallbackWithApproval:(PPCApproval *)approval {
    [approval.actions captureOnComplete:^(PPCCaptureActionSuccess *success, NSError *error) {
        if (error) {
            NSLog(@"Fail to capture order with error %@", error.localizedDescription);
        } else if (success) {
            [self updateServerWithInvestment];
            NSLog(@"Capture order successfully");
        } else {
            NSLog(@"Capture order: No error and no success response");
        }
    }];
}

/// onCancel callback: This will be called when users cancel checkout
- (void)onCancelCallback {
    NSLog(@"Checkout cancelled");
}

/// onError callback: This will be call when an error occurs in the checkout session
- (void)onErrorCallbackWithErrorInfo:(PPCErrorInfo *)errorInfo {
    NSLog(@"Checkout failed with error: %@", errorInfo.error.localizedDescription);
}

#pragma mark - Navigation

- (IBAction)goBack:(id)sender {
    // display starups view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
