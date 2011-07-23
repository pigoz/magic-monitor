#import "NSWindowFade.h"


@implementation NSWindowFade

- (void)awakeFromNib
{
	[self setAlphaValue:0.0];
}

//overriding method
- (void)showWindow
{
	[self.animator setAlphaValue:1.0];
}

@end
