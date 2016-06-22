//
//  VideoCompositionInstruction.m
//  AVVideoCompositionRadar
//
//  Created by Hagai Weinfeld on 20/06/2016.
//  Copyright © 2016 Hagai Weinfeld. All rights reserved.
//

#import "MyVideoCompositionInstruction.h"

@implementation MyVideoCompositionInstruction

@synthesize containsTweening = _containsTweening;
@synthesize enablePostProcessing = _enablePostProcessing;
@synthesize requiredSourceTrackIDs = _requiredSourceTrackIDs;
@synthesize passthroughTrackID = _passthroughTrackID;
@synthesize timeRange = _timeRange;

- (instancetype)initWithTimeRange:(CMTimeRange)timeRange trackID:(NSUInteger)trackID
                   filterStrength:(CGFloat)filterStrength {
    if (self = [super init]) {
        _containsTweening = YES;
        _enablePostProcessing = NO;
        _requiredSourceTrackIDs = @[@(trackID)];
        _passthroughTrackID = kCMPersistentTrackID_Invalid;
        _timeRange = timeRange;
        _filterStrength = filterStrength;
    }
    return self;
}

@end
