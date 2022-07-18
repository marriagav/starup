//
//  StarupCell.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Starup.h"
#import "DateTools.h"
#import "Algos.h"

NS_ASSUME_NONNULL_BEGIN

@import Parse;

@protocol starupCellDelegate;

@interface StarupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *starupName;
@property (weak, nonatomic) IBOutlet UILabel *starupCategory;
@property (weak, nonatomic) IBOutlet UILabel *operatingSince;
@property (weak, nonatomic) IBOutlet UILabel *sales;
@property (weak, nonatomic) IBOutlet PFImageView *starupImage;
@property (weak, nonatomic) IBOutlet UILabel *starupDescription;
@property (strong, nonatomic) Starup *starup;
@property (nonatomic, weak) id<starupCellDelegate> delegate;

- (void)setStarup:(Starup *)starup;

@end

@protocol starupCellDelegate

- (void)starupCell:(StarupCell *) starupCell didTap: (Starup *)starup;

@end


NS_ASSUME_NONNULL_END
