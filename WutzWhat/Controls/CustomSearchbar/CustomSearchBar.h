#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol CustomSearchBarDelegate

-(void)customCancelButtonHit;
- (void)searchBar:(UISearchBar *)searchBar;

@end

@interface CustomSearchBar : UISearchBar<UISearchBarDelegate>
{
    UIButton *customBackButtom;
}
@property (nonatomic, assign) id<UISearchBarDelegate> delegate;

-(void)cancelAction;
@end
