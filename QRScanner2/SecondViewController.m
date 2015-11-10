//
//  SecondViewController.m
//  QRScanner2
//
//  Created by Simon Cook on 10/11/2015.
//  Copyright © 2015 Simon Cook. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSMutableData *responseData;

- (BOOL)startReading;
- (void)stopReading;

@end

@implementation SecondViewController

#pragma mark Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBeepSound];
    _isReading = NO;
    _captureSession = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI Callbacks

- (IBAction)scanButtonPressed:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
            [self.scanButton setTitle:@"Stop" forState:UIControlStateNormal];
            [self.statusLabel setText:@"Scanning for QR Code..."];
        }
    }
    else{
        [self stopReading];
        [self.scanButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    _isReading = !_isReading;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    [self.scanButton setTitle:@"Start" forState:UIControlStateNormal];
}

#pragma mark Sound Related Methods

-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}

#pragma mark Scanning Methods

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.previewView.layer.bounds];
    [self.previewView.layer addSublayer:_videoPreviewLayer];
    [_captureSession startRunning];
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            // update the status label to show the name of the item in the preview image
            NSString *ingredient = [metadataObj stringValue];
            [self.statusLabel performSelectorOnMainThread:@selector(setText:)
                                               withObject:ingredient
                                            waitUntilDone:NO];
            
            // call stop reading
            [self performSelectorOnMainThread:@selector(stopReading)
                                   withObject:nil
                                 waitUntilDone:NO];
            
            // set the buttion back to start text
            [self.scanButton performSelectorOnMainThread:@selector(setTitle:)
                                              withObject:@"Start!"
                                           waitUntilDone:NO];
            _isReading = NO;
            if (_audioPlayer) {
                [_audioPlayer play];
            }
            
            // contact heroku to get the recipe associated with the ingredients
            [self.scanLabel performSelectorOnMainThread:@selector(setText:)
                                             withObject:@"Contacting Heroku ..."
                                          waitUntilDone:NO];
            
            // make the http request
            NSString     *herokuURL = [NSString stringWithFormat:@"https://ancient-brushlands-5083.herokuapp.com/recipes?in=%@", ingredient];
            NSURLSession *session   = [NSURLSession sharedSession];
            
            [[session dataTaskWithURL:[NSURL URLWithString:herokuURL]
                    completionHandler:^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                        [self.scanLabel performSelectorOnMainThread:@selector(setText:)
                                                         withObject:[NSString stringWithUTF8String:[data bytes]]
                                                      waitUntilDone:NO];
                    }] resume];
        }
    }
}

@end
