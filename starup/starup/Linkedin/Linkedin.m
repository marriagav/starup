//
//  Linkedin.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/21/22.
//

#import "Linkedin.h"

@implementation Linkedin

+ (BOOL)isLinkedInAccessTokenValid {
    return [LinkedInHelper sharedInstance].isValidToken;
}

+ (void)getUserInfo {
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    
    // If user has already connected via linkedin in and access token is still valid then
    // No need to fetch authorizationCode and then accessToken again!
    
#warning - To fetch user info  automatically without getting authorization code, accessToken must be still valid
    
    if (linkedIn.isValidToken) {
        
        // So Fetch member info by elderyly access token
        [linkedIn autoFetchUserInfoWithSuccess:^(NSDictionary *userInfo) {
            // Whole User Info
            NSLog(@"user Info : %@", userInfo);
        } failUserInfo:^(NSError *error) {
            NSLog(@"error : %@", error.userInfo.description);
        }];
    }
    else{
        [self fetchUserInformations];
    }
}

+ (void)fetchUserInformations {
    
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
        NSLog(@"user Info : %@", userInfo);
    }
                              failUserInfoBlock:^(NSError *error) {
        NSLog(@"error : %@", error.userInfo.description);
    }
    ];
}

+ (void)logoutFromLinkedin{
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    [linkedIn logout];
}

+ (void)checkIfUserHasLinkedin: (NSString*)username {
    PFQuery *query = [PFUser query];
    [query whereKey:@"linkedinAuthentification" equalTo:@"True"];
    [query whereKey:@"username" equalTo:username];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            if (users != nil) {
                if (users.count>0){
                    [self getUserInfo];
                }
                else{
                    nil;
                }
            } else {
                NSLog(@"%@", error);
            }
        }];
}

@end
