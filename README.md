This is a demo app demonstrating performance and race condition issues when performing live video 
editing via AVFoundation.

Using the "Replace Composition" slider causes the strength of the applied sepia filter to change by 
replacing the AVVideoComposition currently used by the AVPlayerItem.

Using the "Change Value in Composition" slider causes the strength of the applied sepia filter to 
change by replacing the instructions property of the AVVideoComposition currently used by the 
AVPlayerItem.
