//
//  TalkSingletonManager.h
//  WutzWhat
//
//  Created by Kashif on 08/12/2012.
//
//

#import <Foundation/Foundation.h>

@interface TalkSingletonManager : NSObject
{
    TalkSingletonManager *singleton;
}

+ (id)sharedManager;

@property (nonatomic,readwrite) BOOL isNewTalkAdded;
@property (nonatomic,retain) NSMutableDictionary *categoriesDataDict;
@property (nonatomic,retain) NSMutableDictionary *categoriesSectionsDict;

- (NSMutableDictionary *) getCategoryArrayAtIndex:(int)index;
- (NSMutableArray *) getCategorySectionArrayAtIndex:(int)index;
- (void) setDataDict:(NSMutableDictionary*)dataDict forIndex:(int)categoryIndex;
- (void)removeDateDictForIndex:(int)categoryIndex;

- (id) init;
- (void) destroy;
@end
