//
//  QRView.m
//  JapaneseHelper
//
//  Created by wzr on 2015/02/20.
//  Copyright (c) 2015年 wzr. All rights reserved.
//

#import "ScanViewCon.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanAreaView.h"
@interface ScanViewCon() <AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureDeviceInput* input;
@property (strong, nonatomic) AVCaptureMetadataOutput* output;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* preview;
//scan area view
@property (strong, nonatomic) ScanAreaView* scanAreaView;
@end
@implementation ScanViewCon
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupCamera];
   
//    self.navigationItem.leftBarButtonItem =
    //resetボタン
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height-70, 200, 70);
    btn.backgroundColor = [UIColor grayColor];
//    btn.titleLabel.text = @"キャンセル";
    [btn setTitle:@"キャンセル" forState:UIControlStateNormal];
    [btn setTitle:@"キャンセル" forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
    
    CGRect scanFrame = CGRectMake(20, self.view.frame.size.height/3, self.view.frame.size.width-40, self.view.frame.size.height/3);
    [self drawScanFrame:scanFrame];
    
}
//Scanの範囲Viewを設定します
//後、試験の範囲を設定します
-(void)drawScanFrame:(CGRect)scanFrame
{
    self.scanAreaView = [[ScanAreaView alloc] initWithFrame:scanFrame];
    self.scanAreaView.backgroundColor = [UIColor blackColor];
    self.scanAreaView.alpha = 0.1;
    [self.view addSubview:self.scanAreaView];
    [self setRectOfIntrest];
    
    CGRect frame = CGRectMake(0, 0, 1000, 1000);
    UIView *clearColorView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:clearColorView];
}
-(void)btnClicked
{
    NSLog(@"キャンセル");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.session startRunning];
}

-(void)setRectOfIntrest
{
    CGSize size = self.view.bounds.size;
    CGRect cropRect = self.scanAreaView.frame;
    self.output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                              cropRect.origin.x/size.width,
                                              cropRect.size.height/size.height,
                                              cropRect.size.width/size.width);
}
- (void)setupCamera

{
    // Session
    self.session = [[AVCaptureSession alloc] init];
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    [self.session addInput:self.input];
    // Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
      [self.session addOutput:self.output];
    self.output.metadataObjectTypes =  @[AVMetadataObjectTypeUPCECode
                                         , AVMetadataObjectTypeCode39Code
                                         , AVMetadataObjectTypeCode39Mod43Code
                                         , AVMetadataObjectTypeEAN13Code
                                         , AVMetadataObjectTypeEAN8Code
                                         , AVMetadataObjectTypeCode93Code
                                         , AVMetadataObjectTypeCode128Code
                                         ,AVMetadataObjectTypePDF417Code
                                         , AVMetadataObjectTypeQRCode
                                         , AVMetadataObjectTypeAztecCode];
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    // Start
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"Metadata");
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode
                              , AVMetadataObjectTypeCode39Code
                              , AVMetadataObjectTypeCode39Mod43Code
                              , AVMetadataObjectTypeEAN13Code
                              , AVMetadataObjectTypeEAN8Code
                              , AVMetadataObjectTypeCode93Code
                              , AVMetadataObjectTypeCode128Code
                              ,AVMetadataObjectTypePDF417Code
                              , AVMetadataObjectTypeQRCode
                              , AVMetadataObjectTypeAztecCode];

   
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[self.preview transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            NSLog(@"detectionString --%@",detectionString);
            [self readOverAction:detectionString];
            break;
        }
        else
            NSLog(@"detectionString --%@",detectionString);
    }

    [self.session stopRunning];
}
-(void)readOverAction:(NSString*)detectionString
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate scanFinished:detectionString];
    }];
}
@end
