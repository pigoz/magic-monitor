#import <Cocoa/Cocoa.h>
#import "CustomView.h"
#import "GradientView.h"

@interface Controller : NSObject {
    IBOutlet NSWindow* controlsWindow;
	IBOutlet CustomView* customView;
	IBOutlet GradientView* gradientView;
    IBOutlet NSMenu* menuBar;
    NSStatusItem* statusItem;
}
@property(retain) NSWindow* controlsWindow;
@property(retain) CustomView* customView;
@property(retain) GradientView* gradientView;
@property(retain) NSStatusItem* statusItem;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)applicationWillTerminate:(NSNotification *)aNotification;
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;
@end
