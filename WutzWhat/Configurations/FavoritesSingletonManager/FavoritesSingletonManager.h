//
//  FavoritesSingletonManager.h
//  WutzWhat
//
//  Created by Zeeshan on 2/4/13.
//
//

#import <Foundation/Foundation.h>

@interface FavoritesSingletonManager : NSObject
{
    FavoritesSingletonManager *singleton;
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
