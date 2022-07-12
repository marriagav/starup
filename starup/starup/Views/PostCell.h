//
//  PostCell.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Post.h"
#import "DateTools.h"
#import "Algos.h"

NS_ASSUME_NONNULL_BEGIN

@import Parse;

@protocol PostCellDelegate;

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet PFImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *statusText;
@property (weak, nonatomic) IBOutlet UILabel *captionOutlet;
@property (weak, nonatomic) IBOutlet UILabel *dateOutlet;
@property (weak, nonatomic) IBOutlet UILabel *userRole;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) Post *post;
@property (nonatomic, weak) id<PostCellDelegate> delegate;

- (void)setPost:(Post *)post;

@end

@protocol PostCellDelegate

- (void)postCell:(PostCell *) postCell didTap: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
