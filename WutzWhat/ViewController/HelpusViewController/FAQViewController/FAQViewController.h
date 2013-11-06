//
//  FAQViewController.h
//  WutzWhat
//
//  Created by Zeeshan on 4/24/13.
//
//

#import <UIKit/UIKit.h>
#import "FAQModel.h"
@interface FAQViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSInteger selectedButtonIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tblFaq;
@property (nonatomic,retain) NSMutableArray *sectionArray;
@property (nonatomic,retain) NSMutableDictionary *dataDict;
@property (nonatomic,retain) NSMutableArray *rows;

@end