#import "GradientView.h"


@implementation GradientView

@synthesize gradient;
@synthesize angle;
@synthesize selectedColor;
@synthesize selectedColorAlpha;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
			
		//NSLog(@"%f",angle);
		[self addObserver:self forKeyPath:@"selectedColor" options:(NSKeyValueObservingOptionNew |
														NSKeyValueObservingOptionOld) context:NULL];
		[self addObserver:self forKeyPath:@"selectedColorAlpha" options:(NSKeyValueObservingOptionNew |
														NSKeyValueObservingOptionOld) context:NULL];
		[self addObserver:self forKeyPath:@"angle" options:(NSKeyValueObservingOptionNew |
														NSKeyValueObservingOptionOld) context:NULL];
		[self addObserver:self forKeyPath:@"gradient" options:(NSKeyValueObservingOptionNew |
														NSKeyValueObservingOptionOld) context:NULL];
														
		hitDiamond = NO;
	}
    return self;
}

- (void)awakeFromNib
{
				
}

- (void)drawRect:(NSRect)rect {

	//gradient = mainView.gradient;
	//angle = mainView.angle;

	NSRect outerBounds = [self bounds];
	//[[NSColor whiteColor] set];
	//NSRectFill(outerBounds);
	
	innerBounds = NSMakeRect(outerBounds.origin.x +16.0, outerBounds.origin.y, outerBounds.size.width -32.0, outerBounds.size.height - 32.0);
	NSBezierPath* bounds = [NSBezierPath bezierPathWithRect:innerBounds];
	
	[[NSGraphicsContext currentContext] setShouldAntialias:NO]; // we want the control to be sharph, since it's made of straight lines!
	[gradient drawInBezierPath:bounds angle:(CGFloat)0.0];
	[[NSColor blackColor] set];
	[bounds stroke];
	
	
	NSColor *curColor; // pointer to current color
	CGFloat curLocation; //pointer to current location
	int i;
	[[NSGraphicsContext currentContext] setShouldAntialias:YES];
	[diamonds release];
	diamonds = [[NSMutableArray alloc] init];
	for( i=0 ; i < [gradient numberOfColorStops]; i++){
		[gradient getColor: &curColor location: &curLocation atIndex:(NSInteger)i];
		
		// Creating Diamond Bezier Path
		NSPoint _start = {curLocation*innerBounds.size.width + innerBounds.origin.x, innerBounds.size.height +3};
		NSPoint _left = {_start.x-8, _start.y+10};
		NSPoint _top = {_start.x, _start.y+20};
		NSPoint _right = {_start.x+8, _start.y+10};
		NSBezierPath* diamond = [NSBezierPath bezierPath];
		[diamond moveToPoint:_start];
		[diamond lineToPoint:_left];
		[diamond lineToPoint:_top];
		[diamond lineToPoint:_right];
		[diamond lineToPoint:_start];

		[diamonds addObject: diamond];
		
		// drawing diamond
		[curColor set];
		[diamond fill];
		[[NSColor blackColor]set];
		[diamond stroke];
		//[diamond release];
		//[bounds release];
		
	}
	
	
}


-(void)mouseDown:(NSEvent *)event
{
	NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil]; // click location
	//let's figure out if that was on a diamond
	int i = 0;
	for(NSBezierPath* path in diamonds){
		//NSRect pathBounds = [path bounds];
		//NSPoint relativePathLocation = { location.x - pathBounds.origin.x, location.y - pathBounds.origin.y };
		if([path containsPoint:location]){
			hitDiamond = YES;
			selected = i;
			NSColor* col;
			[gradient getColor:&col location:nil atIndex:i];
			self.selectedColor = col;
			self.selectedColorAlpha = [col alphaComponent];
			break;
		}
		i++;
	}
	
	if(!hitDiamond){
		if((location.x > innerBounds.origin.x && location.x < innerBounds.origin.x + innerBounds.size.width) &&
		   (location.y > innerBounds.size.height))
		{	
			// we hit something inbetween two diamonds
			CGFloat newDiamondLocation = ((location.x-innerBounds.origin.x)/innerBounds.size.width);

			NSColor* curColor; // pointer to current color
			NSColor* prevColor;
			CGFloat curLocation; //pointer to current location
			CGFloat prevLocation;
			NSMutableArray* colorsArray = [[NSMutableArray alloc] init];
			CGFloat* locations = (CGFloat *)malloc(sizeof(CGFloat)*50); //assume we dont have have more than 50 colors :)

			int j;
			BOOL inserted = NO;
			for(j=0; j < [gradient numberOfColorStops]; j++){
				if(j>0){
					prevColor = curColor;
					prevLocation = curLocation;
				}
				[gradient getColor: &curColor location: &curLocation atIndex:(NSInteger)j];
				if(!inserted && newDiamondLocation < curLocation){
					if(j>0){
						if(curLocation-newDiamondLocation < newDiamondLocation-prevLocation){
							[colorsArray addObject:curColor];
						}else{
							[colorsArray addObject:prevColor];
						}
					} else {
						[colorsArray addObject:curColor];
					}
					locations[j]=newDiamondLocation;
					selected = j;
					selectedColor = [colorsArray lastObject];
					inserted=YES;
					j--;
				} else {
					[colorsArray addObject:curColor];
					locations[(inserted)?j+1:j]=curLocation;
				}
			}
			if(!inserted){
				[colorsArray addObject:curColor];
				locations[j]=newDiamondLocation;
			}
			
		// finally the new gradient
		NSColorSpace* cspace = [[gradient colorSpace] retain];

		[gradient release];
		gradient = [[NSGradient alloc] initWithColors:colorsArray atLocations:locations colorSpace: [cspace autorelease]];
		[colorsArray release];
		free(locations);

		//redisplay
		[self setNeedsDisplay:YES];
		[self redisplayMainWindow];
		}
	}
	
}

- (void)mouseDragged:(NSEvent *) event 
{
	NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil]; // click location
	
	if(hitDiamond){ // we are dragging the diamond
		NSMutableArray* colorsArray = [[NSMutableArray alloc] init];
		CGFloat* locations = (CGFloat *)malloc(sizeof(CGFloat)*50); //assume we dont have have more than 50 colors :)
		NSColor* curColor; // pointer to current color
		CGFloat curLocation; //pointer to current location
		int j;
		BOOL removed = NO;
		for( j=0 ; j < [gradient numberOfColorStops] ; j++){
			[gradient getColor: &curColor location: &curLocation atIndex:(NSInteger)j];
			[colorsArray addObject:curColor];
			if(selected==j)
			{	
				if(!removed && ((location.y < innerBounds.size.height-5)||(location.y > [self bounds].size.height))){
				//we just drag the diamond out of dragging area, lets remove the color we just added
					[colorsArray removeLastObject];
					removed = YES;
				} else {
				//we are adding the moving
				locations[j] = ((location.x-innerBounds.origin.x)/innerBounds.size.width);
				if(locations[j]<0.0)
					locations[j]=0.0;
				if(locations[j]>1.0)
					locations[j]=1.0;
				}
			}
			else
			{
				//dealing with diamonds we did not select.
				locations[(removed)?j-1:j] = curLocation;
			}
		}
		
		// finally the new gradient
		NSColorSpace* cspace = [[gradient colorSpace] retain];
		[gradient release];
		gradient = [[NSGradient alloc] initWithColors:colorsArray atLocations:locations colorSpace: [cspace autorelease]];
		[colorsArray release];
		free(locations);
		
		//redisplay
		[self setNeedsDisplay:YES];
		[self redisplayMainWindow];
		
		if(removed)
			hitDiamond = NO;

	}

}

- (void) mouseUp:(NSEvent *)event
{
	hitDiamond = NO;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if([keyPath isEqual:@"selectedColor"]){
		int i;
		NSMutableArray* colorsArray = [[NSMutableArray alloc] init];
		CGFloat* locations = (CGFloat *)malloc(sizeof(CGFloat)*50); //assume we dont have have more than 50 colors :)
		NSColor* curColor; // pointer to current color
		CGFloat curLocation; //pointer to current location
		for(i=0 ; i< [gradient numberOfColorStops]; i++){
			[gradient getColor: &curColor location: &curLocation atIndex:(NSInteger)i];
			if(i==selected){
				[colorsArray addObject:[change objectForKey:NSKeyValueChangeNewKey]];
			}else{
				[colorsArray addObject:curColor];
			}
			locations[i] = curLocation;
			
		}
		// finally the new gradient
		NSColorSpace* cspace = [[gradient colorSpace] retain];
		[gradient release];
		gradient = [[NSGradient alloc] initWithColors:colorsArray atLocations:locations colorSpace: [cspace autorelease]];
		[colorsArray release];
		free(locations);
		
		//redisplay
		[self setNeedsDisplay:YES];
		[self redisplayMainWindow];
	
	}
		if([keyPath isEqual:@"selectedColorAlpha"]){
		int i;
		NSMutableArray* colorsArray = [[NSMutableArray alloc] init];
		CGFloat* locations = (CGFloat *)malloc(sizeof(CGFloat)*50); //assume we dont have have more than 50 colors :)
		NSColor* curColor; // pointer to current color
		CGFloat curLocation; //pointer to current location
		for(i=0 ; i< [gradient numberOfColorStops]; i++){
			[gradient getColor: &curColor location: &curLocation atIndex:(NSInteger)i];
			if(i==selected){
				[self willChangeValueForKey:@"selectedColor"];
				selectedColor = [curColor colorWithAlphaComponent:(CGFloat)[[change valueForKey:NSKeyValueChangeNewKey] floatValue]];
				[self didChangeValueForKey:@"selectedColor"];
				[colorsArray addObject:selectedColor];
			}else{
				[colorsArray addObject:curColor];
			}
			locations[i] = curLocation;
			
		}
		// finally the new gradient
		NSColorSpace* cspace = [[gradient colorSpace] retain];
		[gradient release];
		gradient = [[NSGradient alloc] initWithColors:colorsArray atLocations:locations colorSpace: [cspace autorelease]];
		[colorsArray release];
		free(locations);
		
		//redisplay
		[self setNeedsDisplay:YES];
	
	}
	if([keyPath isEqual:@"angle"]){
		[self redisplayMainWindow];
		mainView.angle = self.angle;
		[self setNeedsDisplay:YES];
	}
	if([keyPath isEqual:@"gradient"]){
		[self setNeedsDisplay:YES];
	}
}

- (void) redisplayMainWindow{
	mainView.gradient = gradient;
	[mainView setNeedsDisplay:YES];
}

@end
