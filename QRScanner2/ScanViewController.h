//
//  ScanViewController.h
//  QRScanner2
//
//  Created by Simon Cook on 10/11/2015.
//  Copyright © 2015 Simon Cook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView   *previewView;
@property (weak, nonatomic) IBOutlet UILabel  *scanLabel;
@property (weak, nonatomic) IBOutlet UILabel  *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

- (IBAction)scanButtonPressed:(id)sender;

@end

