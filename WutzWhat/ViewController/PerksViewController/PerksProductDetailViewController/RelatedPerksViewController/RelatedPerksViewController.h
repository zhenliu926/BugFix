//
//  RelatedPerksViewController.h
//  WutzWhat
//
//  Created by Zeeshan on 1/30/13.
//
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"
#import "ProcessingView.h"
#import "Utiltiy.h"
#import "RelatedPerksModel.h"
#import "UIImageView+WebCache.h"
#import "PerksProductDetailViewController.h"
#import "PerksModel.h"
#import "RelatedPerksModel.h"
#import "CustomCell.h"

@interface RelatedPerksViewController : UIViewController
<
DataFetcherDelegate,
UIScrollViewDelegate,
UITableViewDelegate
>
{
    UIImageView *selectedBgView;
    NSMutableArray *RelatedPerks;
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
}

@property (strong, nonatomic) NSString *perkID;
@property (assign, nonatomic) int categoryID;
@property (strong, nonatomic) IBOutlet UITableView *tblRelatedPerks;

@end
