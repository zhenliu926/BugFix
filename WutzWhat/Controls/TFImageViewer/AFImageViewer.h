//
//  AFImageViewer.h
//  ImageViewer
//
//  Created by Adrian Florian on 5/11/12.
//  Copyright (c) 2012 Adrian Florian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "NSString+MD5.h"


@protocol AFImageViewerDelegate<NSObject>


-(void)imageClickedAtIndex:(int)index;
-(void)videoClickedAtIndex:(int)index videoURL:(NSURL *)videoURL;
-(void)firstImageDownloadedForSharing:(UIImage *)downloadedImage;

@optional

-(UIImageView *) imageViewForPage:(int) page;
-(int) numberOfImages;

@end

@interface AFImageViewer : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *imageScrollView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *imagesUrls;
@property (nonatomic, strong) UIImage *loadingImage;
@property (nonatomic, strong) UIImageView *initialImageView;
@property (nonatomic) BOOL disableSpinnerWhenLoadinImage;
@property (nonatomic) int videoExistAtIndex;
@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic) BOOL tempDownloadedImageSavingEnabled;

@property (nonatomic) UIViewContentMode contentMode;

@property (nonatomic, weak) id<AFImageViewerDelegate> delegate;

-(void) setCustomPageControl:(UIPageControl *) customPageControl;

-(void)setInitialPage:(NSInteger)page;
-(NSInteger)currentPage;
-(void)initialize;
- (void) addImageView:(UIImageView *)imgView toImageScrollView:(UIScrollView *)imgScrollView withPage:(int) page removingSubview:(UIView *) subview;

@end
