//
//  PerksSingletonManager.h
//  WutzWhat
//
//  Created by Zeeshan on 1/31/13.
//
//

#import <Foundation/Foundation.h>

@interface PerksSingletonManager : NSObject
{
    PerksSingletonManager *singleton;
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
