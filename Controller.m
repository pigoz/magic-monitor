#import "Controller.h"
@implementation Controller
@synthesize customView;
@synthesize gradientView;
- (id) init
{
	self = [super init];
	if (self != nil) {
	}
	return self;
}


- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{
	[controlsWindow showWindow];
	[controlsWindow makeKeyAndOrderFront:self];
	return NO;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults){
		if([standardUserDefaults boolForKey:@"gradientEnabled"])
			customView.gradientEnabled = [standardUserDefaults boolForKey:@"gradientEnabled"];
		else
			customView.gradientEnabled = YES;
		if([standardUserDefaults valueForKey:@"brightness"])
			customView.brightness = [[standardUserDefaults valueForKey:@"brightness"] floatValue];
		else
			customView.brightness = 1.0;
		if([standardUserDefaults valueForKey:@"angle"])
			customView.angle = [[standardUserDefaults valueForKey:@"angle"] floatValue];
		else
			customView.angle = 90;
			
		NSData *theGradient=[standardUserDefaults dataForKey:@"gradient"];
		if (theGradient != nil)
			customView.gradient =(NSGradient *)[NSKeyedUnarchiver unarchiveObjectWithData:theGradient];
		else
			customView.gradient = [[NSGradient alloc] 
			initWithStartingColor:[[NSColor blackColor] colorWithAlphaComponent: 0.32]
			endingColor: [[NSColor blackColor] colorWithAlphaComponent:0.0]];
			
	}

    [customView setNeedsDisplay:YES];
	
	gradientView.gradient = customView.gradient;
	gradientView.angle = (CGFloat)customView.angle;
	
	[controlsWindow showWindow];
	
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

	if (standardUserDefaults) {
		[standardUserDefaults setBool:customView.gradientEnabled forKey:@"gradientEnabled"];
		[standardUserDefaults setValue:[NSNumber numberWithFloat:customView.brightness] forKey:@"brightness"];
		[standardUserDefaults setValue:[NSNumber numberWithFloat:customView.angle] forKey:@"angle"];
		[standardUserDefaults synchronize];
		
		NSData *theGradient = [NSKeyedArchiver archivedDataWithRootObject:customView.gradient];
		NSLog(@"%@", theGradient);
		[standardUserDefaults setObject:theGradient forKey:@"gradient"];
		[standardUserDefaults synchronize];
	}

}

@end
