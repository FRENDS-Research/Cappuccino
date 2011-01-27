/*
 * AppController.j
 * onetofifty
 *
 * Created by outsider on January 9, 2011.
 * Copyright 2011, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>


@implementation AppController : CPObject
{
   CPView _contentView;
   int _currentNumber;
   int _nextNumber;
   int _initNumber;
   CPTextField _timeLabel;
   CPDate _startTime;
   CPTimer _timer;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
    _contentView = [theWindow contentView];
    
    var frame = CGRectMake(50, 65, 200, 24);
    var button = [[CPButton alloc] initWithFrame: frame];

    [button setTitle:"Start"];
    [button setTarget:self];
    [button setAction:@selector(startGame:)];
    [button setFont:[CPFont boldSystemFontOfSize:20]];

    [self add:button];
    
     _timeLabel = [CPTextField labelWithTitle:"0"];
     [_timeLabel setAlignment:CPCenterTextAlignment];
     [_timeLabel setFrame:CGRectMake(45, 0, 230, 65)];
     [_timeLabel setFont:[CPFont boldSystemFontOfSize:50]];

     [self add:_timeLabel];
	
    [theWindow orderFront:self];
    
    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

- (void)add:(CPView)subview
{
   [_contentView addSubview:subview];
}

- (CPButton)makeButton:(id)value atX:(int)x y:(int)y 
{
    var frame = CGRectMake(45 * x + 5, 30 * y + 35, 40, 24);
    var button = [[CPButton alloc] initWithFrame: frame];

    [button setTitle:value.toString()];

    [button setTarget:self];
    [button setAction:@selector(clickNumber:)];
    [button setFont:[CPFont boldSystemFontOfSize:20]];

    [self add:button];

    return button;
}

- (int)generateNumber
{
   var num = Math.floor(Math.random() * _initNumber.length);
   var result = _initNumber.splice(num, 1);
   return result;
}

- (void)clickNumber:(CPButton)source 
{
   if (_currentNumber.toString() == [source title]) {
      if (_nextNumber <= 50) {
        [source setTitle:_nextNumber.toString()];  
      } else {
        [source removeFromSuperview]; 
      }
      
      if (_currentNumber == 50) {
      	[self stopTimer];
      }
      
      _currentNumber++;
      _nextNumber++;
   } else {
        return; 
   }
}

- (void)startGame:(CPButton)source 
{
	_initNumber = new Array();
    _currentNumber = 1;

    for(var i=1; i<=25; i++) {
        _initNumber[i-1] = i; 
    }
    _nextNumber = 26;
    
    var x = 1, y = 1;
    
    [source removeFromSuperview]; 

    for (var i = 1; i <= 25; i++) {
        [self makeButton:[self generateNumber] atX:x y:y];

        if (x < 5) {
           x++;
        } else {
           x = 1;
           y++;
        }

    }
    
    [self startTimer];
     _timer = [CPTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showTimer) userInfo:null repeats:YES];
}

- (void)startTimer
{
	_startTime = [CPDate timeIntervalSinceReferenceDate];	 
}

- (void)stopTimer
{
	[_timer invalidate];
}

- (void)showTimer
{
	var nowTime = [CPDate timeIntervalSinceReferenceDate];
	var elapsedTime = nowTime - _startTime;
	[_timeLabel setFloatValue:elapsedTime.toFixed(1)];
}

@end
