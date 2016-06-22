//
//  MyVideoCompositor.h
//  AVVideoCompositionRadar
//
//  Created by Hagai Weinfeld on 20/06/2016.
//  Copyright © 2016 Hagai Weinfeld. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

/// Custom video compositor used to apply a filter to the video.
@interface MyVideoCompositor : NSObject <AVVideoCompositing>

@end
