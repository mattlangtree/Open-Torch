//
//  Open_TorchAppDelegate.m
//  Open Torch
//
//  Created by Abhi Beckert on 2011-04-26.
//  Copyright 2011 Precedence. All rights reserved.
//

#import "Open_TorchAppDelegate.h"

#import "Open_TorchViewController.h"

@implementation Open_TorchAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // hide status bar
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
  
  // setup and turn on torch
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if (device && [device hasTorch] && [device hasFlash]){
    AVCaptureDeviceInput *flashInput = [AVCaptureDeviceInput deviceInputWithDevice:device error: nil];
    AVCaptureVideoDataOutput *output = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
    
    captureSession = [[AVCaptureSession alloc] init];
    
    [captureSession beginConfiguration];
    [device lockForConfiguration:nil];
    
    [captureSession addInput:flashInput];
    [captureSession addOutput:output];
    [device setTorchMode:AVCaptureTorchModeOn];
    [device setFlashMode:AVCaptureFlashModeOn];
    
    [device unlockForConfiguration];
    
    [captureSession commitConfiguration];
    [captureSession startRunning];
  }
  
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // torch will have been truned off. turn back on
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if (device && [device hasTorch] && [device hasFlash]){
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOn];
    [device setFlashMode:AVCaptureFlashModeOn];
    [device unlockForConfiguration];
  }
}

- (void)dealloc
{
  [captureSession release];
  [_window release];
  [_viewController release];
  [super dealloc];
}

@end
