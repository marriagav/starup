//
//  LinkedInServiceManager.m
//  linkedinDemo
//
//  Created by Ahmet Kazım Günay on 26/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LinkedinIOSHelper/LinkedInServiceManager.h>
#import <LinkedinIOSHelper/LinkedInAuthorizationViewController.h>
#import <LinkedinIOSHelper/LinkedInConnectionHandler.h>
#import <LinkedinIOSHelper/LinkedinSimpleKeychain.h>

@interface LinkedInServiceManager ()

@property (nonatomic, copy) void (^successBlock)(NSDictionary *dict);

@property (nonatomic, copy) void (^failureBlock)(NSError *err);

@property(nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, copy) NSString *cancelButtonText;

@end

@implementation LinkedInServiceManager

#pragma mark - Initialize -

+ (LinkedInServiceManager *)serviceForPresentingViewController:viewController
                                              cancelButtonText:(NSString*)cancelButtonText
                                                   appSettings:(LinkedInAppSettings*)settings {

    LinkedInServiceManager *service = [[self alloc] init];
    service.cancelButtonText = cancelButtonText;
    service.presentingViewController = viewController;
    service.settings = settings;
    
    return service;
}

#pragma mark - Authorization Code -

- (void)getAuthorizationCode:(void (^)(NSString *))success
                      cancel:(void (^)(void))cancel
                     failure:(void (^)(NSError *))failure {
    
    __weak typeof (self) weakSelf = self;
    
    LinkedInAuthorizationViewController *vc = [[LinkedInAuthorizationViewController alloc] initWithServiceManager:self];
    vc.showActivityIndicator = _showActivityIndicator;
    
    [vc setAuthorizationCodeCancelCallback:^{
        [weakSelf hideAuthenticateView];
        if (cancel) {
            cancel();
        }
    }];
    
    [vc setAuthorizationCodeFailureCallback:^(NSError *err) {
        [weakSelf hideAuthenticateView];
        if (failure) {
            failure(err);
        }
    }];
    
    [vc setAuthorizationCodeSuccessCallback:^(NSString *code) {
        [weakSelf hideAuthenticateView];
        if (success) {
            success(code);
        }
    }];
    vc.cancelButtonText = self.cancelButtonText;
    
    if (self.presentingViewController == nil)
        self.presentingViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nc.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self.presentingViewController presentViewController:nc animated:YES completion:nil];
}

- (NSString *)authorizationCode {
    return [LinkedinSimpleKeychain loadWithService:LINKEDIN_AUTHORIZATION_CODE];
}

- (void)hideAuthenticateView {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Access Token -

- (NSString *)accessToken {
    return [LinkedinSimpleKeychain loadWithService:LINKEDIN_TOKEN_KEY];
}

- (BOOL)validToken {
    
    return !([[NSDate date] timeIntervalSince1970] >= ([[LinkedinSimpleKeychain loadWithService:LINKEDIN_CREATION_KEY] doubleValue] +
                                                       [[LinkedinSimpleKeychain loadWithService:LINKEDIN_EXPIRATION_KEY] doubleValue]));
}

- (void)getAccessToken:(NSString *)authorizationCode
               success:(void (^)(NSDictionary *))success
               failure:(void (^)(NSError *))failure {

    NSString *postDataStr = [NSString stringWithFormat:@"grant_type=authorization_code""&code=%@""&redirect_uri=%@""&client_id=%@""&client_secret=%@", authorizationCode, _settings.applicationWithRedirectURL, _settings.clientId, _settings.clientSecret];
    NSData *data1 = [postDataStr dataUsingEncoding:NSUTF8StringEncoding];
    
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.linkedin.com/oauth/v2/accessToken"]];
    
        //create the Method "GET" or "POST"
        [urlRequest setHTTPMethod:@"POST"];
    
        //Apply the data to the body
        [urlRequest setHTTPBody:data1];
    
        [urlRequest addValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
    
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode == 200)
            {
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                
                NSString *accessToken = responseDictionary[@"access_token"];
                
                NSTimeInterval expiration = [[responseDictionary objectForKey:@"expires_in"] doubleValue];

                // store credentials
                [LinkedinSimpleKeychain saveWithService:LINKEDIN_TOKEN_KEY data:accessToken];
                [LinkedinSimpleKeychain saveWithService:LINKEDIN_AUTHORIZATION_CODE data:authorizationCode];
                [LinkedinSimpleKeychain saveWithService:LINKEDIN_EXPIRATION_KEY data:@(expiration)];
                [LinkedinSimpleKeychain saveWithService:LINKEDIN_CREATION_KEY data:@([[NSDate date] timeIntervalSince1970])];

                success(responseDictionary);
            }
            else
            {
                failure(error);
            }
        }];
        [dataTask resume];
}

#pragma mark - Memory Management -

- (void)dealloc
{
    
}

@end
