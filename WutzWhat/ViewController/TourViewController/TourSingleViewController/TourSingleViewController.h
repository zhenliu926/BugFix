//
//  TourSingleViewController.h
//  WutzWhat
//
//  Created by Zeeshan on 4/25/13.
//
//

#import <UIKit/UIKit.h>

@protocol TourSingleViewDelegate <NSObject>

-(void)exitTours;

@end

@interface TourSingleViewController : UIViewController
{

}

@property (strong, nonatomic) IBOutlet UIButton *btnLastButton;

@property (nonatomic, assign) id<TourSingleViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) IBOutlet UIImageView *imgTour;

- (IBAction)btnClose_Pressed:(id)sender;
- (IBAction)btnLastButtonClicked:(id)sender;

@property (assign, nonatomic) int index;

@end
