//
//  QRView.h
//  JapaneseHelper
//
//  Created by wzr on 2015/02/20.
//  Copyright (c) 2015年 wzr. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScanViewConDelegate <NSObject>
-(void)scanFinished:(NSString *)selectionString;
@end
@interface ScanViewCon : UIViewController
@property(nonatomic,weak)id<ScanViewConDelegate>delegate;
@end
