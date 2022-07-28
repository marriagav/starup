//
//  ProfileViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Algos.h"
#import "Parse/Parse.h"
#import "EditProfileViewController.h"
#import "Post.h"
#import "PostCellView.h"
#import "StarupCollectionCellView.h"
#import "InfiniteScrollActivityView.h"
#import "DetailsViewController.h"
#import "Linkedin.h"
#import "ConnectionsGraph.h"
#import "AddCollaboratorViewController.h"
#import "ResultsViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileRole;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITextView *profileBio;
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (strong, nonatomic) NSMutableArray *collaboratorArray;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic) int currentMax;

@end

NS_ASSUME_NONNULL_END
