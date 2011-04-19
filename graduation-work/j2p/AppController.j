/*
*	AppController.j
*	
*	Created by J2P
*/

@import <Foundation/CPObject.j>
@import "PageView.j"
@import "NumberPanel.j"

@implementation AppController : CPObject
{
	CPWindow		theWindow;
	CPView			view;
	CPImageView		bgImage;
	CPWindow		startWindow;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	// window
    theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

	[theWindow setBackgroundColor:[CPColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:1.0]];
	[theWindow orderFront:self];

	
	
	// background view
	view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 800.0, 600.0)];
    [view setCenter:[contentView center]];
    [view setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    
    [contentView addSubview:view];
	
	// background ImageView
	bgImage = [[CPImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 800.0, 600.0)];
	[bgImage setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/bg.png" size:CGSizeMake(800.0, 600.0)]];

	[view addSubview:bgImage];
	
	// alert 
	startWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0.0, 0.0, 400.0, 150.0) styleMask:CPHUDBackgroundWindowMask];
	[startWindow setAutoresizingMask: CPWindowMinYMargin | CPWindowMaxYMargin | CPWindowMinXMargin | CPWindowMaxXMargin];
	[startWindow orderFront:self];
	[startWindow center];

	startContent = [startWindow contentView];
	
	// foxicon
	var iconView = [[CPImageView alloc] initWithFrame:CGRectMake(20.0, 0.0, 100.0, 130.0)];

	[iconView setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/fox.png" size:CGSizeMake(100.0, 130.0)]];
	[iconView setImageScaling:CPScaleProportionally];
	
	// texticon
	var textView = [[CPImageView alloc] initWithFrame:CGRectMake(135.0, 10.0, 248.0, 56.0)];

	[textView setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/text_01.png" size:CGSizeMake(248.0, 56.0)]];
	[textView setImageScaling:CPScaleProportionally];


    var okButton = [[CPButton alloc] initWithFrame:CGRectMake(135.0, 85.0, 97.0, 32.0)];
	[okButton setBordered:NO];
	[okButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/start_btn.png" size:CGSizeMake(97.0, 32.0)]];
	[okButton setAction:@selector(startGame:)]; 
	
	[startContent addSubview:iconView];
	[startContent addSubview:textView];
	[startContent addSubview:okButton];
}

// start game - start button click
- (void)startGame:(id)sender
{
	[startWindow close];
	var bounds = [bgImage bounds],
        pageView = [[PageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds) / 2.0 - 55, CGRectGetHeight(bounds) / 2.0 - 200.0, 420.0, 420.0)];

    [pageView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];

    [view addSubview:pageView];
      
	[[[PhotoPanel alloc] init] orderFront:nil];				  
}


// end game - restart button click
- (void)restartGame:(id)sender
{
	[startWindow1 close];
	[startWindow2 close];

	var bounds = [bgImage bounds],
        pageView = [[PageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds) / 2.0 - 55, CGRectGetHeight(bounds) / 2.0 - 200.0, 420.0, 420.0)];

    [pageView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];

    [view addSubview:pageView];
}


@end