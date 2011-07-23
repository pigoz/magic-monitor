#import <Cocoa/Cocoa.h>

@interface CustomWindow : NSWindow
{
    //This point is used in dragging to mark the initial click location
	NSWindow* result;
    NSPoint initialLocation;
}

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag;

- (BOOL) canBecomeKeyWindow;
@end
