//
//  HotpicksSingletonManager.m
//  WutzWhat
//
//  Created by Zeeshan on 1/22/13.
//
//

#import "HotpicksSingletonManager.h"
static HotpicksSingletonManager *sharedInstance = nil;

@implementation HotpicksSingletonManager
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
			sharedInstance = [[HotpicksSingletonManager alloc] init];
        }
	}
	return sharedInstance;
}


- (NSMutableDictionary *) getCategoryArrayAtIndex:(int)index {
    return [self.categoriesDataDict objectForKey:[NSString stringWithFormat:@"%d",index]];
}

- (void) setDataDict:(NSMutableDictionary*)dataDict forIndex:(int)categoryIndex {
    [self.categoriesDataDict setObject:dataDict forKey:[NSString stringWithFormat:@"%d",categoryIndex]];
}

- (void)removeDateDictForIndex:(int)categoryIndex
{
    [self.categoriesDataDict removeObjectForKey:[NSString stringWithFormat:@"%d", categoryIndex]];
}

- (void) destroy {
    [self.categoriesDataDict removeAllObjects];
    [self.categoriesLocationDict removeAllObjects];
    
    //[self setCategoriesDataDict:nil];
    //[self setCategoriesLocationDict:nil];
    
}

@end
