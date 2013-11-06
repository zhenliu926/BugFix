//
//  MenuViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/14/12.
//
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
#import "WutzWhatViewController.h"
#import "TalkViewController.h"
#import "CreditViewController.h"
#import "NotificationsViewController.h"
#import "CityViewController.h"
#import "InitialViewController.h"
#import "CommonFunctions.h"
#import "FavouritesViewController.h"
#import "DataFetcher.h"

@interface MenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate, DataFetcherDelegate>
{
    InitialViewController *initialVeiwController;
    UILabel *notificationCount;
}
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic,retain) NSMutableArray *rows;

-(void)refreshMenuTable;
- (void)refreshNotificationCount;
@end
