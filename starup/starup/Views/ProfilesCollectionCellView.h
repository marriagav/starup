//
//  profilesCollectionViewCell.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/15/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Algos.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfilesCollectionCellViewDelegate;


@interface ProfilesCollectionCellView : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameOutlet;
@property (strong, nonatomic) PFUser *user;
@property (nonatomic, weak) id<ProfilesCollectionCellViewDelegate> delegate;

- (void)setUser:(PFUser *)user;

@end

@protocol ProfilesCollectionCellViewDelegate

- (void)profileCell:(ProfilesCollectionCellView *)profileCell didTap:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
