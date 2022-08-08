//
//  DetailsViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Starup.h"
#import "DateTools.h"
#import "Collaborator.h"
#import "ProfilesCollectionCellView.h"
#import "ProfileViewController.h"
#import "InvestViewController.h"
#import "UserConnection.h"
#import "ConnectionsGraph.h"
#import "ComposeStarupViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewControllerDelegate

- (void)updateData;

@end


@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Starup *starup;
@property (weak, nonatomic) IBOutlet UILabel *starupName;
@property (weak, nonatomic) IBOutlet UILabel *starupDescription;
@property (weak, nonatomic) IBOutlet UILabel *starupCategory;
@property (weak, nonatomic) IBOutlet UILabel *operatingSince;
@property (weak, nonatomic) IBOutlet UILabel *sales;
@property (weak, nonatomic) IBOutlet PFImageView *starupImage;
@property (weak, nonatomic) IBOutlet UICollectionView *ideatorsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *hackersCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *sharksCollectionView;
@property (weak, nonatomic) IBOutlet UIProgressView *investmentProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressString;
@property (nonatomic, strong) NSMutableArray *ideators;
@property (nonatomic, strong) NSMutableArray *sharks;
@property (nonatomic, strong) NSMutableArray *hackers;
@property (nonatomic, strong) NSMutableArray *chatParticipants;
@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *editStarupButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property BOOL isOwner;

@end

NS_ASSUME_NONNULL_END
