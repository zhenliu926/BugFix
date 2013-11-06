//
//  MyPerksViewController.h
//  WutzWhat
//
//  Created by Rafay on 3/20/13.
//
//

#import <UIKit/UIKit.h>
#import "ReceiptViewController.h"
#import "MNMBottomPullToRefreshManager.h"
#import "LoadMore.h"
#import "CustomCell.h"
@interface MyPerksViewController : UIViewController<DataFetcherDelegate, MNMBottomPullToRefreshManagerClient, UIScrollViewDelegate>
{
    NSMutableArray *array;
    NSString *page;
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    
    BOOL isLoadMore;
    LoadMore *loadMore;
}

@property (nonatomic) BOOL isLastLoadSuccessful;

@property (nonatomic, strong) MNMBottomPullToRefreshManager *pullToRefreshTableManager;

@property (nonatomic,retain) NSString *page;
@property (nonatomic,retain) NSMutableDictionary *dataDict;
@property (nonatomic,retain) NSArray *sectionsArray;
@property (nonatomic,retain) NSMutableArray *rows;
@property (strong, nonatomic) IBOutlet UILabel *lblCreditBalance;
@property (strong, nonatomic) IBOutlet UITableView *tblCredit;


@end
