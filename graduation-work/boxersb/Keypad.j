@import <AppKit/CPView.j>

@implementation Keypad : CPView
{
	CPArray _numbers;
	int _current;
	int _maxSize;
	int _combo;
	int _maxCombo;
	BOOL _done;
	CPString _message;
}
- (id)initWithSize:(CGRect)aFrame size:(int)s {
	_current = 1;
	_combo = 0;
	_maxCombo = 0;
	_maxSize = s;
	_done = NO;
	_message = "";
	
	self = [super initWithFrame:aFrame];
	if(self){
		_numbers = [self getRandomArray];
	};
	
	return self;
}
- (CPArray)getRandomArray
{
	var arr = [[CPArray alloc] init];
	
	for(var i=0; i<_maxSize; i++){
		[arr addObject:(i+1)];
	};
	
	return [self shuffleArray:arr];
}
- (CPArray)shuffleArray:(CPArray)arr
{
	var ret = [[CPArray alloc] init],
		i = 0;

	while([arr count]){
		var idx = Math.floor(Math.random() * [arr count]),
			value = [arr objectAtIndex:idx];
		[ret addObject:value];
		[arr removeObjectAtIndex:idx];

		var y = Math.floor(i / 6),
			x = i - (y * 6);
		
		[self makeButton:value atX:x * 50 + 10 y:y * 24 + 20 action:@selector(onNumberClick:)];
		
		i++;
	}
	
	return ret;
}
- (void)add:(CPView)subview
{
	[self addSubview:subview];
}
- (CPButton)makeButton:(id)value atX:(int)x y:(int)y action:(SEL)action
{
	var frame = CGRectMake(x, y, 50, 24);
	var button = [[CPButton alloc] initWithFrame:frame];
	
	[button setTitle:value.toString()];
	
	[button setTarget:self];
	[button setAction:action];
	
	[self add:button];
	
	return button;
}
- (void)onNumberClick:(CPButton)source
{
	if(_done === YES) return;
	
	if(_current == [source title]){
		_combo++;
		if(_maxCombo < _combo) _maxCombo = _combo;
		
		[source setEnabled:NO];
		if(_maxSize == _current){
			_done = YES;
			
			if(_maxSize == _maxCombo){
				_message = @"Amazing!!\r\nYou did it ALL COMBOS!!";
			}else{
				_message = @"Congratulations!\r\nYou have been finished with MAX "+ _maxCombo +"Combos!";
			};			

			return;
		}else{			
			if(_combo == 1){
				_message = @"Good!";
			}else if(_combo == 2){
				_message = @"Perfect! - "+ _combo +"Combos!";
			}else if(_combo == 3){
				_message = @"Awesome!! - "+ _combo +"Combos!";
			}else if(_combo == 4){
				_message = @"Amazing!! - "+ _combo +"Combos!";
			}else if(_combo >= 5){
				_message = @"Beautiful!! - "+ _combo +"Combos!";
			}
		};
		_current++;
	}else{		
		_done = NO;
		_combo = 0;
		_message = @"find "+ _current +" !!";
	};
}
- (BOOL)done
{
	return _done;
}
- (CPString)message
{
	return _message;
}
@end
