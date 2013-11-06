//
//  MyCreditViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 3/19/13.
//
//

#import <UIKit/UIKit.h>
#import "CreditModel.h"

@interface MyCreditViewController : UIViewController
<
DataFetcherDelegate, UIScrollViewDelegate
>
{
    NSMutableArray *array;
    int page;
}

@property (nonatomic,retain) NSMutableDictionary *dataDict;
@property (nonatomic,retain) NSArray *sectionsArray;
@property (nonatomic,retain) NSMutableArray *rows;
@property (strong, nonatomic) IBOutlet UILabel *lblCreditBalance;
@property (strong, nonatomic) IBOutlet UILabel *creditText;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *creditImg;
@property (strong, nonatomic) IBOutlet UITableView *tblCredit;


@end
