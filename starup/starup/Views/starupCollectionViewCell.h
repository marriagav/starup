//
//  starupCollectionViewCell.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/15/22.
//

#import <UIKit/UIKit.h>
#import "Collaborator.h"
#import "Starup.h"

NS_ASSUME_NONNULL_BEGIN

@protocol starupCollectionViewCellDelegate;

@interface starupCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *starupName;
@property (strong, nonatomic) Collaborator *collaborator;
@property (strong, nonatomic) NSString *userRoleText;
@property (weak, nonatomic) IBOutlet UIImageView *userRoleImage;
@property (nonatomic, weak) id<starupCollectionViewCellDelegate> delegate;

- (void)setCollaborator:(Collaborator *)collaborator;

@end

@protocol starupCollectionViewCellDelegate

- (void)starupCell:(starupCollectionViewCell *) starupCell didTap: (Starup *)starup;

@end

NS_ASSUME_NONNULL_END
