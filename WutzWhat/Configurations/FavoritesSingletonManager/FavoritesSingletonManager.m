//
//  FavoritesSingletonManager.m
//  WutzWhat
//
//  Created by Zeeshan on 2/4/13.
//
//

#import "FavoritesSingletonManager.h"
static FavoritesSingletonManager *sharedInstance = nil;

@implementation FavoritesSingletonManager

@synthesize categoriesDataDict;

- (id) init
{
    self = [super init];
    if (self) {
        
        self.categoriesDataDict = [[NSMutableDictionary alloc] init];
        
        
    }
    return self;
}

+ (id)sharedManager
{
	@synchronized(self)
	{
		if (sharedInstance == nil) {
			sharedInstance = [[FavoritesSingletonManager alloc] init];
        }
	}
	return sharedInstance;
}


- (NSMutableDictionary *) getCategoryArrayAtIndex:(int)index {
    return [self.categoriesDataDict objectForKey:[NSString stringWithFormat:@"%d",index]];
}

- (void) setDataDict:(NSMutableDictionary*)dataDict forIndex:(int)categoryIndex
{
    [self.categoriesDataDict setObject:dataDict forKey:[NSString stringWithFormat:@"%d",categoryIndex]];
}

- (void)removeDateDictForIndex:(int)categoryIndex
{
    [self.categoriesDataDict removeObjectForKey:[NSString stringWithFormat:@"%d", categoryIndex]];
}

- (void) destroy
{
    [self.categoriesDataDict removeAllObjects];
    [self.categoriesLocationDict removeAllObjects];
}

@end
