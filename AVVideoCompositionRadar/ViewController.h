//
//  ViewController.h
//  AVVideoCompositionRadar
//
//  Created by Hagai Weinfeld on 20/06/2016.
//  Copyright © 2016 Hagai Weinfeld. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

/// Slider used to change the filter's strength by replacing the AVVideoComposition.
@property (weak, nonatomic) IBOutlet UISlider *replaceCompositionSlider;

/// Slider used to change the filter's strength by changing the instruction's held by the
/// currently used AVVideoComposition.
@property (weak, nonatomic) IBOutlet UISlider *changeValueSlider;

@end

