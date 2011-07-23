#import <Cocoa/Cocoa.h>
#import "CustomView.h"
#import "GradientView.h"
#import "NSWindowFade.h"

@interface Controller : NSObject
{
	IBOutlet CustomView* customView;
	IBOutlet GradientView* gradientView;
	IBOutlet NSWindowFade *controlsWindow;
}
@property(retain) CustomView* customView;
@property(retain) GradientView* gradientView;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)applicationWillTerminate:(NSNotification *)aNotification;
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;
@end
