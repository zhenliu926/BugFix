//
//  TalkSingletonManager.m
//  WutzWhat
//
//  Created by Kashif on 08/12/2012.
//
//

#import "TalkSingletonManager.h"

static TalkSingletonManager *sharedInstance = nil;

@implementation TalkSingletonManager
@synthesize categoriesDataDict,categoriesSectionsDict,isNewTalkAdded;

- (id) init
{
    self = [super init];
    if (self) {
        
        self.categoriesDataDict = [[NSMutableDictionary alloc] init];
        self.categoriesSectionsDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (id)sharedManager
{
	@synchronized(self)
	{
		if (sharedInstance == nil) {
			sharedInstance = [[TalkSingletonManager alloc] init];
        }
	}
	return sharedInstance;
}


- (NSMutableDictionary *) getCategoryArrayAtIndex:(int)index {
    return [self.categoriesDataDict objectForKey:[NSString stringWithFormat:@"%d",index]];
}

- (NSMutableArray *) getCategorySectionArrayAtIndex:(int)index {
    return [self.categoriesSectionsDict objectForKey:[NSString stringWithFormat:@"%d",index]];
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
    [self.categoriesSectionsDict removeAllObjects];
    
    //[self setCategoriesDataDict:nil];
    //[self setCategoriesSectionsDict:nil];
}

@end
