//
//  CommentViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/19/12.
//
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "AddCommentViewController.h"
@interface CommentViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITableView *tblComments;


@property (nonatomic,retain) NSMutableDictionary *dataDict;
@property (nonatomic,retain) NSArray *sectionsArray;
@property (nonatomic,retain) NSMutableArray *rows;

@end
