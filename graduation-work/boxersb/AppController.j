/*
 * AppController.j
 * numseq
 *
 * Created by You on January 18, 2011.
 * Copyright 2011, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "Keypad.j"

@implementation AppController : CPObject
{
	CPView _contentView;
	CPView _view;
	float _currentSec;
	CPTextField _timeLabel;
	CPTextField _dialog;
	CPTimer _timer;
}
- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(200, 30, 320, 480) styleMask:CPMiniaturizableWindowMask];
	_contentView = [theWindow contentView];
	
	_current = 1;
	_maxSize = 10;

	[self ready];
	
    [theWindow orderFront:self];
}
- (void)ready
{
	[self createTimer];
	[self createDialog];
	_view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	
	var viewBound = [_view bounds];
	var frame = CGRectMake(CGRectGetWidth(viewBound)/2.0 - 40, CGRectGetHeight(viewBound)/2.0 - 12, 80, 24);
	var button = [[CPButton alloc] initWithFrame:frame];
	
	[button setTitle:@"Game Start"];
	[button setFont:[CPFont boldSystemFontOfSize:14.0]];
	
	[button setTarget:self];
	[button setAction:@selector(startGame:)];
	
	[_view addSubview:button];
	[self add:_view];
	
	return button;
}
- (void)startGame:(CPButton)source
{
	[_view removeFromSuperview];
	_view = nil;
	_view = [[Keypad alloc] initWithSize:CGRectMake(0, 0, 320, 480) size:_maxSize];
	[self add:_view];
	
	[self printMessage:"Find 1!"];
	_timer = [CPTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];	
}
- (void)createDialog
{
	_dialog = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	
	[_dialog setStringValue:@"Click to start game"];
	[_dialog setFont:[CPFont boldSystemFontOfSize:12.0]];
	
	[self resizeMessage];
	
	[self add:_dialog];
}
- (void)resizeMessage
{
	[_dialog sizeToFit];
	var center = [_contentView center];

	[_dialog setCenter:CGPointMake(center.x, 440.0)];
}
- (void)printMessage:(CPString)msg
{
	if([msg hasPrefix:"find"]){
		[_dialog setTextColor:[CPColor redColor]];
	}else{
		[_dialog setTextColor:[CPColor blackColor]];
	};
	
	[_dialog setStringValue:msg];
	[self resizeMessage];
}
- (void)createTimer
{
	_timeLabel = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];

    [_timeLabel setStringValue:@"00:00:00"];
    [_timeLabel setFont:[CPFont boldSystemFontOfSize:24.0]];

    [_timeLabel sizeToFit];
    [_timeLabel setCenter:[_contentView center]];	

	_currentSec = 0;
	
    [self add:_timeLabel];
}
- (void)timerFireMethod:(CPTimer)source
{
	if([_view done]){
		[source invalidate];
		var msg = [_view message];
		
		if(_currentSec >= (_maxSize * 1.5)){
			msg = @"Poor. You are too late.\r\n Needs more practice.";
		}

		[self printMessage:msg];
		
		return;
	}else{
		if([_view message] != "") [self printMessage:[_view message]];
	}
	
	_currentSec = ((_currentSec*100) + 1) / 100;
	var min = ""+Math.floor(_currentSec / 60),
		sec = ""+Math.floor(_currentSec - (min * 60)),
		msec = ""+Math.ceil((_currentSec - Math.floor(_currentSec)) * 100);
		
	if(min.length < 2) min = "0"+min;
	if(sec.length < 2) sec = "0"+sec;
	if(msec.length < 2) msec = "0"+msec;

	[_timeLabel setStringValue:(min+":"+sec+":"+msec)];
	[_timeLabel sizeToFit];
}
- (void)add:(CPView)subview
{
	[_contentView addSubview:subview];
}
@end
