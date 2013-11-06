//
//  NotificationSettingsViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/26/12.
//
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"

@interface NotificationSettingsViewController : UIViewController <DataFetcherDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UIButton *btnFeaturedWutzwhat;
@property (strong, nonatomic) IBOutlet UIButton *btnFeaturedPerks;
@property (strong, nonatomic) IBOutlet UIButton *btnNewPromoCodes;
@property (strong, nonatomic) IBOutlet UIButton *btnCreditUpdates;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;


- (IBAction)btnCreditUpdateClicked:(id)sender;
- (IBAction)btnFeaturedPerksClicked:(id)sender;
- (IBAction)btnFeaturedWutzwhatClicked:(id)sender;
- (IBAction)btnNewPromoCodesUpdatesClicked:(id)sender;


@end
