//
//  MyVideoCompositor.m
//  AVVideoCompositionRadar
//
//  Created by Hagai Weinfeld on 20/06/2016.
//  Copyright © 2016 Hagai Weinfeld. All rights reserved.
//

#import "MyVideoCompositor.h"
#import "MyVideoCompositionInstruction.h"
#import <CoreImage/CoreImage.h>

@interface MyVideoCompositor ()

@property (strong, nonatomic) CIContext *context;

@end

@implementation MyVideoCompositor

/// Pixel format for outputed frames.
static const int contextPixelFormat = kCVPixelFormatType_32BGRA;

/// Pixel format for inputted frames.
static const int sourcePixelFormat = kCVPixelFormatType_32BGRA;

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)init {
  if (self = [super init]) {
    self.context = [CIContext contextWithOptions:nil];
  }
  return self;
}

#pragma mark -
#pragma mark AVVideoCompositing
#pragma mark -

- (void)renderContextChanged:(AVVideoCompositionRenderContext *)newRenderContext {
  NSLog(@"renderContextChanged %@", newRenderContext);
}

- (NSDictionary<NSString *, id> *)requiredPixelBufferAttributesForRenderContext {
  return @{ (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey: @(contextPixelFormat),
            (__bridge NSString *)kCVPixelBufferOpenGLESCompatibilityKey: @YES };
}

- (nullable NSDictionary<NSString *, id> *)sourcePixelBufferAttributes {
  return @{ (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey: @(sourcePixelFormat),
           (__bridge NSString *)kCVPixelBufferOpenGLESCompatibilityKey: @YES };
}

- (void)startVideoCompositionRequest:(AVAsynchronousVideoCompositionRequest *)request {
  NSError *error = nil;
  CVPixelBufferRef resultPixels = [self outputForRequest:request];
  if (resultPixels) {
    [request finishWithComposedVideoFrame:resultPixels];
    CFRelease(resultPixels);
  } else {
    [request finishWithError:error];
  }
}

- (CVPixelBufferRef)outputForRequest:(AVAsynchronousVideoCompositionRequest *)request {
  
  // This line sometimes crashes due to a race condition caused when switching the instructions
  // held by an AVVideoComposition mid-play:
  MyVideoCompositionInstruction *instruction =
      (MyVideoCompositionInstruction *)request.videoCompositionInstruction;
  
  
  NSNumber *trackID =
      (NSNumber *)[[instruction requiredSourceTrackIDs] firstObject];
  CVPixelBufferRef source = [request sourceFrameByTrackID:[trackID intValue]];
  CVPixelBufferRef output = [request.renderContext newPixelBuffer];

  CIImage *image = [CIImage imageWithCVPixelBuffer:source];
  CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
  [filter setValue:image forKey:kCIInputImageKey];
  [filter setValue:@(instruction.filterStrength) forKey:kCIInputIntensityKey];
  CIImage *result = [filter valueForKey:kCIOutputImageKey];  
  
  [self.context render:result toCVPixelBuffer:output];

  return output;
}


@end
