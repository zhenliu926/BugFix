//
//  WutsWhatSingletonManager.h
//  WutzWhat
//
//  Created by Kashif on 16/01/2012.
//
//

#import "WutsWhatSingletonManager.h"

static WutsWhatSingletonManager *sharedInstance = nil;

@implementation WutsWhatSingletonManager
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
			sharedInstance = [[WutsWhatSingletonManager alloc] init];
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
    //[self categoriesLocationDict:nil];
}

@end
