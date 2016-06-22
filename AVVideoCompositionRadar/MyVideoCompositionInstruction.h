//
//  MyVideoCompositionInstruction.h
//  AVVideoCompositionRadar
//
//  Created by Hagai Weinfeld on 20/06/2016.
//  Copyright © 2016 Hagai Weinfeld. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

/// Custom \c AVVideoCompositionInstruction that includes a strength value to be used by a filter
/// applied to the whole scene.
@interface MyVideoCompositionInstruction : NSObject <AVVideoCompositionInstruction>

- (instancetype)init NS_UNAVAILABLE;

/// Initialize with \c timeRange, \c trackID, value.
- (instancetype)initWithTimeRange:(CMTimeRange)timeRange trackID:(NSUInteger)trackID
                   filterStrength:(CGFloat)filterStrength;

/// Strength of filter to apply.
@property (readonly, nonatomic) CGFloat filterStrength;

@end
