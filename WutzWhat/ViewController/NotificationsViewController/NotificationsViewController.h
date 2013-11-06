//
//  NotificationsViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/26/12.
//
//

#import <UIKit/UIKit.h>
#import "NotificationsModel.h"
#import "NotificationSettingsViewController.h"
#import "DataFetcher.h"
#import "UIImageView+WebCache.h"
#import "WutzWhatProductDetailViewController.h"
#import "PerksProductDetailViewController.h"
#import "PerksModel.h"
#import "WutzWhatModel.h"
#import "DataModel.h"
#import "RedeemCreditViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "MNMBottomPullToRefreshManager.h"
#import "LoadMore.h"
@interface NotificationsViewController : UIViewController
<
DataFetcherDelegate,
UITableViewDataSource,
UITableViewDelegate,
EGORefreshTableHeaderDelegate,
MNMBottomPullToRefreshManagerClient
>
{
    BOOL isTableReloading;
    EGORefreshTableHeaderView *_refreshNotificationTableView;
    MNMBottomPullToRefreshManager *_pullToRefreshManager;
    NSUInteger _reloads;
    BOOL isLastLoadSuccessful;
    BOOL isLoadMore;
    LoadMore *loadMore;
    UIImageView *selectedBgView;
}

@property (nonatomic,retain) NSMutableDictionary *dataDict;
@property (nonatomic,retain) NSArray *sectionsArray;
@property (nonatomic,retain) NSMutableArray *rows;
@property (nonatomic,retain) NSMutableArray *notificationListArray;
@property (strong, nonatomic) IBOutlet UITableView *tblNotifications;

@end
