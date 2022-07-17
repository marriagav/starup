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

@protocol profilesCollectionViewCellDelegate;

@interface profilesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameOutlet;
@property (strong, nonatomic) PFUser *user;
@property (nonatomic, weak) id<profilesCollectionViewCellDelegate> delegate;

- (void)setUser:(PFUser *)user;

@end

@protocol profilesCollectionViewCellDelegate

- (void)profileCell:(profilesCollectionViewCell *) profileCell didTap: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
