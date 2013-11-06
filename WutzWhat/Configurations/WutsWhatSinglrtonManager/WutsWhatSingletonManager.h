//
//  WutsWhatSingletonManager.h
//  WutzWhat
//
//  Created by Kashif on 16/01/2012.
//
//

#import <Foundation/Foundation.h>

@interface WutsWhatSingletonManager : NSObject
{
    WutsWhatSingletonManager *singleton;
}

+ (id)sharedManager;

@property (nonatomic,retain) NSMutableDictionary *categoriesDataDict;
@property (nonatomic,retain) NSMutableDictionary *categoriesLocationDict;

- (NSMutableDictionary *) getCategoryArrayAtIndex:(int)index;
- (void) setDataDict:(NSMutableDictionary*)dataDict forIndex:(int)categoryIndex;
- (void)removeDateDictForIndex:(int)categoryIndex;

- (id) init;
- (void) destroy;
@end
