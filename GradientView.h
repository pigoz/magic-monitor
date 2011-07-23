#import <Cocoa/Cocoa.h>
#import "CustomView.h"

@interface GradientView : NSView {
	NSGradient* gradient;
	CGFloat angle;
	NSMutableArray* diamonds;
	NSColor* selectedColor;
	CGFloat selectedColorAlpha;
	
	NSRect innerBounds;
	
	BOOL hitDiamond;
	int selected;
	
	IBOutlet CustomView* mainView;
}
-(void)redisplayMainWindow;
@property(retain) NSGradient* gradient;
@property(assign) CGFloat angle;
@property(retain) NSColor* selectedColor;
@property(assign) CGFloat selectedColorAlpha;

@end
