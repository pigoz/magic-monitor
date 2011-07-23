#import <Cocoa/Cocoa.h>

@interface CustomView : NSView
{
    float brightness;
	NSGradient* gradient;
	CGFloat angle;
	BOOL gradientEnabled;
    NSStatusBar* statusItem;    
}
@property(retain) NSGradient* gradient;
@property(assign) CGFloat angle;
@property(assign) BOOL gradientEnabled;
@property(assign) float brightness;
@end
