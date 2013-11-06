//
//  LoadMore.m
//  WutzWhat
//
//  Created by Zeeshan on 4/5/13.
//
//

#import "LoadMore.h"
@interface LoadMore()
@end
@implementation LoadMore
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(int)getNumberOfTotalRowsFromTable:(UITableView *)tableView
{
    int sections = [tableView numberOfSections];
    
    int rowscount = 0;
    
    for(int i=0; i < sections; i++)
    {
        rowscount += [tableView numberOfRowsInSection:i];
    }
    
    return rowscount;
}


-(BOOL)canGetMoreRecordsForTableView:(UITableView *)tableView andIsLastLoadSuccessful: (BOOL)isLastLoadSuccessful isMyFindTable:(BOOL)isMyFindTable
{
    int rowCount = [self getNumberOfTotalRowsFromTable:tableView];
    
    if (isMyFindTable)
    {
        rowCount -= 1;
    }
    
    return rowCount %10 == 0 && rowCount != 0 && isLastLoadSuccessful;
}


-(int)getNextPageNumberForTablePaggination:(UITableView *)tableView
{
    int currentNoOfRows = [self getNumberOfTotalRowsFromTable:tableView];
    
    int currentPage = currentNoOfRows / 10;
    
    return currentPage + 1;
}
@end
