//
//  OptionsViewController.h
//  WutzWhat
//
//  Created by Rafay on 3/12/13.
//
//

#import <UIKit/UIKit.h>


@interface OptionsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
}


@property (strong, nonatomic) IBOutlet UITableView *tblOptions;
@property (strong, nonatomic) NSString *currentSelection;
@property (strong, nonatomic) NSArray *optionsArray;

//temp
@property (nonatomic, assign) BOOL isShipping;

@end