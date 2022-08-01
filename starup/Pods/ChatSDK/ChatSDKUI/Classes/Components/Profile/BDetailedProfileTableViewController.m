//
//  BRegisterTableViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BDetailedProfileTableViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import <ChatSDK/ChatSDK-Swift.h>

#define bStatusSection 1
#define bBlockCellTag 2
#define bAddContactCellTag 3
#define bMoreCellTag 4

@interface BDetailedProfileTableViewController ()

@end

@implementation BDetailedProfileTableViewController

@synthesize profilePictureButton;
@synthesize nameLabel;
@synthesize statusTextView;
@synthesize localityLabel;
@synthesize phoneNumberLabel;
@synthesize emailLabel;

@synthesize user;

@synthesize blockImageView;
@synthesize blockTextView;
@synthesize blockUserActivityIndicator;
@synthesize availabilityLabel;

@synthesize statusCell;
@synthesize localityCell;
@synthesize blockUserCell;
@synthesize phoneNumberCell;
@synthesize emailCell;
@synthesize availabilityCell;
@synthesize addContactCell;

@synthesize addContactLabel;
@synthesize addContactImageView;

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.title = [NSBundle t:bProfile];
        self.tabBarItem.image = [NSBundle uiImageNamed: @"icn_30_profile"];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _notificationList = [BNotificationObserverList new];
    
    _anonymousProfilePicture = [Icons getWithName:Icons.defaultProfile];
    profilePictureButton.layer.cornerRadius = 50;
    profilePictureButton.imageView.contentMode = UIViewContentModeScaleAspectFill;

    self.hideSectionsWithHiddenRows = YES;
    
    [self refreshInterfaceAnimated:NO];
    
    [_notificationList add:[BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
        id<PUser> user = dict[bHook_PUser];
        if (user) {
            [self reloadDataAnimated:NO];
            [self refreshInterfaceAnimated:NO];
        }
    }] withName:bHookUserUpdated]];
    
    __weak __typeof(self) weakSelf = self;
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        weakSelf.user = Nil;
    }] withName:bHookDidLogout];
    
//    NSString * backButtonTitle = self.title;
//    if (backButtonTitle.length > 9) {
//        backButtonTitle = [[backButtonTitle substringToIndex:9] stringByAppendingString:@"..."];
//    }
    
    
    if (@available(iOS 13.0, *)) {

    } else {
        if([self presentingViewController]) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        }
    }
    

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.title style:UIBarButtonItemStylePlain target:Nil action:Nil];
    self.navigationItem.titleView = [BReconnectingView new];

    self.localityLabel.textColor = [Colors getWithName:Colors.mediumGray];
    self.phoneNumberLabel.textColor = [Colors getWithName:Colors.mediumGray];
    self.emailLabel.textColor = [Colors getWithName:Colors.mediumGray];

    self.addContactLabel.textColor = [Colors getWithName:Colors.mediumGray];
//    self.moreLabel.textColor = [Colors getWithName:Colors.mediumGray];
    self.moreLabel.tintColor = [Colors getWithName:Colors.mediumGray];
    self.statusTextView.textColor = [Colors getWithName:Colors.mediumGray];
    self.blockTextView.textColor = [Colors getWithName:Colors.mediumGray];
    self.availabilityLabel.textColor = [Colors getWithName:Colors.mediumGray];
    
}

-(void) settings {
    UIViewController * settingsViewController = BChatSDK.ui.settingsViewController;
    if (settingsViewController) {
        [self presentViewController:settingsViewController animated:true completion:nil];
    }
}

-(void) back {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(!user) {
        user = BChatSDK.currentUser;
    }
    
    if (!self.navigationItem.leftBarButtonItem && user.isMe && BChatSDK.ui.settingsSections.count > 0 && BChatSDK.ui.settingsViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[NSBundle uiImageNamed:@"icn_25_settings"] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
    }
    
    [self refreshInterfaceAnimated:NO];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:_userObserver];
}

-(void) refreshInterfaceAnimated: (BOOL) animated {

    BDetailedUserWrapper * userWrapper = [BDetailedUserWrapper wrapperWithUser:user];
    
    // Stop the app from crashing when we log out
    if (!user) {
        return;
    }
    
    self.profilePictureButton.userInteractionEnabled = NO;
    if (!self.user.isMe) {
        self.title = user.name;
        
        NSMutableArray * rightBarButtonItems = [NSMutableArray new];
        
        UIBarButtonItem * chatItem = [[UIBarButtonItem alloc] initWithImage:[NSBundle uiImageNamed:@"icn_25_chat"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(startChat)];

        if (BChatSDK.call) {
            [rightBarButtonItems addObject:chatItem];
            [rightBarButtonItems addObject:[[UIBarButtonItem alloc] initWithImage:[NSBundle uiImageNamed:@"icn_25_call"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                  action:@selector(startCall)]];
            self.navigationItem.rightBarButtonItems = rightBarButtonItems;
        } else {
            self.navigationItem.rightBarButtonItem = chatItem;
        }

    }
    //
    // Name
    //
    
    nameLabel.text = user.name;

    //
    // Status
    //
    
    NSString * status = user.statusText;
    if (!status || status.length == 0) {
        status = @"";
    }
    statusTextView.text = status;
    
    [self cell:statusCell setHidden:!status || ![status stringByReplacingOccurrencesOfString:@" " withString:@""].length];

    //
    // City
    //
    
    NSString * locality = userWrapper.locality;
    localityLabel.text = locality;
    
    [self cell:localityCell setHidden:!locality || !locality.length];
        
    //
    // Phone number
    //
    
    phoneNumberLabel.text = user.phoneNumber;
    [self cell:phoneNumberCell setHidden:!user.phoneNumber || !user.phoneNumber.length];

    //
    // Email
    //

    emailLabel.text = user.email;
    [self cell:emailCell setHidden:!user.email || !user.email.length];
    
    //
    // Profile picture
    //

    [profilePictureButton loadAvatarForUser:user forControlState:UIControlStateNormal];
    
    //
    // State
    //
    
    NSString * availability = [BAvailabilityState titleForKey:user.availability];
    
    // There are two more states... If the user has no state but they are online
    // then their state is online. If they are offline, their state is offline
    if (!availability || !availability.length) {
        if (user.online.boolValue) {
            availability = [NSBundle t:bAvailabilityStateAvailable];
        }
        else {
            availability = [NSBundle t:bOffline];
        }
    }
    availabilityLabel.text = availability;
    
    [self cell:availabilityCell setHidden:!availabilityLabel.text || !availabilityLabel.text.length];

    //
    // Contact
    //
    
    [self cell:addContactCell setHidden:user.isMe];

    //
    // Blocking
    //
    
    [self cell:blockUserCell setHidden:user.isMe || !BChatSDK.blocking || !BChatSDK.blocking.serviceAvailable];
    
    BOOL isBlocked = [BChatSDK.blocking isBlocked:user.entityID];
    [self setIsBlocked:isBlocked setRemote:NO];
    
    if (self.isContact) {
        addContactLabel.text = [NSBundle t: bDelete];
        
        if (@available(iOS 13.0, *)) {
            addContactLabel.textColor = [UIColor systemRedColor];
        } else {
            addContactLabel.textColor = [UIColor redColor];
        }
        
        addContactImageView.highlighted = YES;
    } else {
        addContactLabel.text = [NSBundle t: bAddContact];
        addContactImageView.highlighted = NO;
        
        if (@available(iOS 13.0, *)) {
            addContactLabel.textColor = [UIColor systemGrayColor];
        } else {
            addContactLabel.textColor = [UIColor darkGrayColor];
        }
        
    }
    
    id<PUserConnection> userConnection = self.userConnection;
    BUserConnectionWrapper * wrapper = [BUserConnectionWrapper wrapperWithConnection:userConnection];
    
    UIImage * tick = [NSBundle uiImageNamed:@"icn_36_tick"];
    UIImage * cross = [NSBundle uiImageNamed:@"icn_36_cross"];
    UIImage * clock = [NSBundle uiImageNamed:@"icn_36_clock"];
    
    // Choose the icons based on the presence status
    bSubscriptionType subscription = userConnection.subscriptionType;
    BOOL ask = wrapper.ask != Nil;
   
    // Follows
    if (ask) {
        [_followsButton setImage:clock forState:UIControlStateNormal];
    }
    else {
        [_followsButton setImage:subscription & bSubscriptionTypeFrom ? tick : cross forState:UIControlStateNormal];
    }
    [_followedButton setImage:subscription & bSubscriptionTypeTo ? tick : cross forState:UIControlStateNormal];
    
    [self cell:_moreCell setHidden: ![ChatSDKUI.shared getProfileSectionsWithUser:user].count];
    
    [self reloadDataAnimated:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == bBlockCellTag) {
        [self setIsBlocked:!self.isBlocked setRemote:YES];
    }
    if (cell.tag == bAddContactCellTag) {
        if (self.isContact) {
            __weak __typeof(self) weakSelf = self;
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:[NSBundle t:bOk] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                __typeof(self) strongSelf = weakSelf;
                [strongSelf deleteUser];
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            }];
            [self alertWithTitle:[NSBundle t:bDeleteContact] withMessage:[NSBundle t:bDeleteContactMessage] actions: @[okAction]];
        } else {
            [self addContact];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    int staticSections = [super numberOfSectionsInTableView:tableView];
//    if (indexPath.section < staticSections) {
        if (indexPath.section == bStatusSection) {
            return [statusTextView heightToFitText] + 18;
        }
        return [super tableView: tableView heightForRowAtIndexPath:indexPath];
//    } else {
//        return 44;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSInteger staticSections = [super numberOfSectionsInTableView:tableView];
    if (section < staticSections) {
        return [super tableView: tableView heightForFooterInSection:section];
    } else {
        return 0;
    }
}

-(id<PUserConnection>) userConnection {
    // Get the user connection
    id<PUser> currentUser = BChatSDK.currentUser;
    for (id<PUserConnection> connection in [currentUser connectionsWithType:bUserConnectionTypeContact]) {
        if ([connection.user isEqualToEntity:user]) {
            return connection;
        }
    }
    return Nil;
}

-(void) setIsBlocked: (BOOL) isBlocked setRemote: (BOOL) setRemote {
    
    blockUserActivityIndicator.hidden = NO;
    [blockUserActivityIndicator startAnimating];
    
    __weak __typeof(self) weakSelf = self;
    promise_completionHandler_t success = ^id(id success) {
        weakSelf.blockImageView.highlighted = isBlocked;
        weakSelf.blockTextView.text = isBlocked ? [NSBundle t:bUnblock] : [NSBundle t:bBlock];
        weakSelf.blockUserActivityIndicator.hidden = YES;
        return Nil;
    };
    
    promise_errorHandler_t error = ^id(NSError * error) {
        weakSelf.blockUserActivityIndicator.hidden = YES;
        return Nil;
    };
    
    if (setRemote) {
        if (isBlocked) {
            [BChatSDK.blocking blockUser:user.entityID].thenOnMain(success, error);
        }
        else {
            [BChatSDK.blocking unblockUser:user.entityID].thenOnMain(success, error);
        }
    }
    else {
        success(Nil);
    }
}

-(void) deleteUser {
    __weak __typeof(self) weakSelf = self;
    [BChatSDK.contact deleteContact:self.user withType:bUserConnectionTypeContact].thenOnMain(^id(id success) {
        [weakSelf refreshInterfaceAnimated:NO];
        return Nil;
    }, ^id(NSError * error) {
        [weakSelf alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
        return Nil;
    });
}

-(void) addContact {
    __weak __typeof(self) weakSelf = self;
    [BChatSDK.contact addContact:self.user withType:bUserConnectionTypeContact].thenOnMain(^id(id success) {
        [weakSelf refreshInterfaceAnimated:NO];
        return Nil;
    }, ^id(NSError * error) {
        [weakSelf alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
        return Nil;
    });
}

-(BOOL) isBlocked {
    return blockImageView.highlighted;
}

//-(UIImage *) profilePicture {
//    id<PUser> user = BChatSDK.currentUser;
//    return user.imageAsImage;
//}

-(void) startChat {
    [BChatSDK.thread createThreadWithUsers:@[self.user] threadCreated:^(NSError * error, id<PThread> thread) {
        UIViewController * cvc = [BChatSDK.ui chatViewControllerWithThread:thread];
        [self.navigationController pushViewController:cvc animated:YES];
    }];
}

-(void) startCall {
    [BChatSDK.call callWithUser:self.user.entityID viewController: self];
}

-(BOOL) isContact {
    id<PUserConnection> userConnection = self.userConnection;
    // If the user is a contact
    return userConnection && userConnection.type.intValue == bUserConnectionTypeContact;
}


- (IBAction)editButtonPressed:(id)sender {

//    BDetailedEditProfileTableViewController * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"EditProfile"];
//    vc.profileViewController = self;

    BDetailedEditProfileTableViewController * vc = [BChatSDK.ui editProfileViewControllerWithParent:self];

    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:Nil];
}

-(BOOL) userIsCurrent {
    return [user isMe];
}

- (IBAction)moreButtonPressed:(id)sender {
    UIViewController * vc = [BChatSDK.ui profileOptionsViewControllerWithUser:user];
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController: nvc animated:YES completion:Nil];
}


@end
