//
//  starupCollectionViewCell.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/15/22.
//

#import <UIKit/UIKit.h>
#import "Collaborator.h"

NS_ASSUME_NONNULL_BEGIN

@interface starupCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *starupName;
@property (strong, nonatomic) Collaborator *collaborator;
@property (strong, nonatomic) NSString *userRoleText;
@property (weak, nonatomic) IBOutlet UIImageView *userRoleImage;

- (void)setCollaborator:(Collaborator *)collaborator;

@end

NS_ASSUME_NONNULL_END
