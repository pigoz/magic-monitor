#import "CustomView.h"

@implementation CustomView

@synthesize gradient;
@synthesize angle;
@synthesize gradientEnabled;
@synthesize brightness;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self->brightness = 1.0;
	}
	return self;
}

//This routine is called at app launch time when this class is unpacked from the nib.
//We get set up here.
-(void)awakeFromNib
{
	[self addObserver:self forKeyPath:@"brightness" options:(NSKeyValueObservingOptionNew |
											NSKeyValueObservingOptionOld) context:NULL];
	[self addObserver:self forKeyPath:@"gradientEnabled" options:(NSKeyValueObservingOptionNew |
											NSKeyValueObservingOptionOld) context:NULL];
	[self addObserver:self forKeyPath:@"angle" options:(NSKeyValueObservingOptionNew |
											NSKeyValueObservingOptionOld) context:NULL];
	[self addObserver:self forKeyPath:@"gradient" options:(NSKeyValueObservingOptionNew |
											NSKeyValueObservingOptionOld) context:NULL];
}

//When it's time to draw, this routine is called.
//This view is inside the window, the window's opaqueness has been turned off,
//and the window's styleMask has been set to NSBorderlessWindowMask on creation,
//so what this view draws *is all the user sees of the window*.  The first two lines below
//then fill things with "clear" color, so that any images we draw are the custom shape of the window,
//for all practical purposes.  Furthermore, if the window's alphaValue is <1.0, drawing will use
//transparency.
-(void)drawRect:(NSRect)rect
{
	NSRect bounds = [self bounds];
	[[[NSColor blackColor] colorWithAlphaComponent:(1-brightness)] set];
	NSRectFill(bounds);
	if(gradientEnabled){
		[gradient drawInRect:bounds angle:angle];
	}
}

//mouseDown workaround to the spaces bug
-(void)mouseDown:(NSEvent*)theEvent
{
	[[self window] setIgnoresMouseEvents:YES];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if([keyPath isEqual:@"brightness"]){
		[self setNeedsDisplay:YES];
	}
	if([keyPath isEqual:@"gradientEnabled"]){
		[self setNeedsDisplay:YES];
	}
	if([keyPath isEqual:@"angle"]){
		[self setNeedsDisplay:YES];
	}
	if([keyPath isEqual:@"gradient"]){
		[self setNeedsDisplay:YES];
	}
	
}
@end
