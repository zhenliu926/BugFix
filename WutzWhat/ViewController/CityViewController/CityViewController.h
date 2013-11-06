//
//  CityViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/15/12.
//
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "MenuViewController.h"
#import "ProcessingView.h"

@interface CityViewController : UIViewController<DataFetcherDelegate>
{
    NSMutableArray *rows;
}
@property (strong, nonatomic) IBOutlet UITableView *cityTableView;
@property (nonatomic,retain) NSMutableArray *rows;
@property (nonatomic,retain)IBOutlet UIImageView *cellBgIV;
@property (nonatomic,retain)IBOutlet NSIndexPath *lastSavedIndexPath;

@property (assign, nonatomic) BOOL isFromMainMenu;
@property (strong, nonatomic) IBOutlet UIView *customNavBarView;
- (IBAction)btnMenuClicked:(id)sender;

@end
