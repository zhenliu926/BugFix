//
//  LoadMore.h
//  WutzWhat
//
//  Created by Zeeshan on 4/5/13.
//
//

#import <Foundation/Foundation.h>

@interface LoadMore : NSObject
-(int)getNumberOfTotalRowsFromTable:(UITableView *)tableView;
-(BOOL)canGetMoreRecordsForTableView:(UITableView *)tableView andIsLastLoadSuccessful: (BOOL)isLastLoadSuccessful isMyFindTable:(BOOL)isMyFindTable;
-(int)getNextPageNumberForTablePaggination:(UITableView *)tableView;
@end
