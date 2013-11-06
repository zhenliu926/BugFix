//
//  Util.h
//  WutzWhat
//
//  Created by Henrique Valadares on 2013-06-21.
//
//

#ifndef WutzWhat_Util_h
#define WutzWhat_Util_h

#import <Foundation/Foundation.h>

@interface Util : NSObject {
    
}

-(UIImage*)cropCenterAndResizeImage:(NSString*)imageUrl cropWidth:(float)widthCrop cropHeight:(float)heightCrop resizeWidth:(float)widthResize resizeHeight:(float)heightHeight;

-(UIImage*)cropCenterAndResizeImageWithImage:(UIImage *)image cropWidth:(float)widthCrop cropHeight:(float)heightCrop resizeWidth:(float)widthResize resizeHeight:(float)heightHeight;

-(NSString*)findFirstUrlImage:(NSArray*) images;

@end


#endif
