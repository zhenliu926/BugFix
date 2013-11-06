//
//  ReceiptViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 4/15/13.
//
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"
#import <QuickLook/QuickLook.h>

@interface ReceiptViewController : UIViewController<DataFetcherDelegate, UIDocumentInteractionControllerDelegate,UIWebViewDelegate>
{
    CGRect origViewFrame;
    BOOL savedPDF;
    NSURLRequest *non_pdf;
}

@property (strong, nonatomic) IBOutlet UIWebView *webViewPDFReceiptViewer;
@property (strong, nonatomic) NSString *perkID;
@property (strong, nonatomic) NSString *pdfID;

@property (strong, nonatomic) NSURL *fileURL;

@property (nonatomic, retain) UIDocumentInteractionController *docInteractionController;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *activityIndicatorView;

@end
