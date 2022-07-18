//
//  LinkedinApiVC.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/18/22.
//

#import "LinkedinApiVC.h"

/*! @brief The OIDC issuer from which the configuration will be discovered.
 */
static NSString *const kIssuer = @"https://www.linkedin.com/uas/oauth2/";

/*! @brief The OAuth client ID.
 */
static NSString *const kClientID = @"86j2dodya1oazo";

/*! @brief The OAuth redirect URI for the client @c kClientID.
 */
static NSString *const kRedirectURI = @"http://starupcode.com";

/*! @brief NSCoding key for the authState property.
 */
static NSString *const kAppAuthExampleAuthStateKey = @"authState";

@interface LinkedinApiVC () <OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate>

@end

@implementation LinkedinApiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self OAuth];
}

- (void)OAuth{

    NSURL *issuer = [NSURL URLWithString:kIssuer];

    [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer
                                                        completion:^(OIDServiceConfiguration *_Nullable configuration,
                                                                     NSError *_Nullable error) {

        if (!configuration) {
            NSLog(@"Error retrieving discovery document: %@",
                  [error localizedDescription]);
            return;
        }

        // builds authentication request
        NSURL *URI = [NSURL URLWithString:kRedirectURI];
        OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientID
                                                        scopes:@[OIDScopeOpenID,
                                                                 OIDScopeProfile]
                                                   redirectURL:URI
                                                  responseType:OIDResponseTypeCode
                                          additionalParameters:nil];

        // performs authentication request
        AppDelegate *appDelegate =
        (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.currentAuthorizationFlow =
        [OIDAuthState authStateByPresentingAuthorizationRequest:request
                                       presentingViewController:self
                                                       callback:^(OIDAuthState *_Nullable authState,
                                                                  NSError *_Nullable error) {
            if (authState) {
                NSLog(@"Got authorization tokens. Access token: %@",
                      authState.lastTokenResponse.accessToken);
                [self setAuthState:authState];
            } else {
                NSLog(@"Authorization error: %@", [error localizedDescription]);
                [self setAuthState:nil];
            }
        }];
    }];

}

- (void)saveState {
    // for production usage consider using the OS Keychain instead
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.openid.appauth.Example"];
    NSData *archivedAuthState = [NSKeyedArchiver archivedDataWithRootObject:_authState requiringSecureCoding:YES error:nil];
    [userDefaults setObject:archivedAuthState
                     forKey:kAppAuthExampleAuthStateKey];
    [userDefaults synchronize];
}

/*! @brief Loads the @c OIDAuthState from @c NSUSerDefaults.
 */
- (void)loadState {
    // loads OIDAuthState from NSUSerDefaults
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.openid.appauth.Example"];
    NSData *archivedAuthState = [userDefaults objectForKey:kAppAuthExampleAuthStateKey];
    OIDAuthState *authState = [NSKeyedUnarchiver unarchivedObjectOfClass:[OIDAuthState class] fromData:archivedAuthState error:nil];
    [self setAuthState:authState];
}

- (void)setAuthState:(nullable OIDAuthState *)authState {
    if (_authState == authState) {
        return;
    }
    _authState = authState;
    _authState.stateChangeDelegate = self;
    [self stateChanged];
}

- (void)stateChanged {
    [self saveState];
}

- (void)didChangeState:(OIDAuthState *)state {
    [self stateChanged];
}

- (void)authState:(OIDAuthState *)state didEncounterAuthorizationError:(nonnull NSError *)error {
    NSLog(@"Received authorization error: %@", error);
}


@end
