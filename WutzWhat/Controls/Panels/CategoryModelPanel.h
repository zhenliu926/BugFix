//
//  CategoryModelPanel.h
//  WutzWhat
//
//  Created by Rafay on 11/16/12.
//
//

#import "UATitledModalPanel.h"

@interface CategoryModelPanel : UATitledModalPanel
{
    UIView			*v;
    IBOutlet UIView	*viewLoadedFromXib;
}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;


@end
