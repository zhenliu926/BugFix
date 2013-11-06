//
//  HelpusViewController.h
//  WutzWhat
//
//  Created by Zeeshan on 4/23/13.
//
//

#import <UIKit/UIKit.h>
#import "CommonFunctions.h"
#import "TourViewController.h"
@interface HelpusViewController : UIViewController
{
    
}
@property (nonatomic,retain) CommonFunctions *sender;
@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

- (IBAction)btnTour_Pressed:(id)sender;

- (IBAction)btnFAQs_Pressed:(id)sender;

- (IBAction)btnEmailUs_Pressed:(id)sender;

- (IBAction)btnTermOfUse_Pressed:(id)sender;

@end
