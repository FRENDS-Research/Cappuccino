/*
*	PageView.j
*	
*	Created by J2P
*/

@import <AppKit/CALayer.j>
@import "NumberPanel.j"


@implementation PaneLayer : CALayer
{
    float       _rotationRadians;
    float       _scale;
    
    CPImage     _image;
    CALayer     _imageLayer;
    
    PageView    _pageView;
	
}

- (id)initWithPageView:(PageView)anPageView
{
    self = [super init];
    
    if (self)
    {
        _pageView = anPageView;
        
        _rotationRadians = 0.0;
        _scale = 1.0;
        
        _imageLayer = [CALayer layer];
        [_imageLayer setDelegate:self];
        
        
        [self addSublayer:_imageLayer];
    }
    
    return self;
}

- (PageView)pageView
{
    return _pageView;
}

- (void)setBounds:(CGRect)aRect
{
    [super setBounds:aRect];
    
    [_imageLayer setPosition:CGPointMake(CGRectGetMidX(aRect), CGRectGetMidY(aRect))];
}

- (void)setImage:(CPImage)anImage
{
    if (_image == anImage)
        return;
    
    _image = anImage;
    
    if (_image)
        [_imageLayer setBounds:CGRectMake(0.0, 0.0, [_image size].width, [_image size].height)];
    
    [_imageLayer setNeedsDisplay];
}

- (void)setRotationRadians:(float)radians
{
    if (_rotationRadians == radians)
        return;
        
    _rotationRadians = radians;
        
    [_imageLayer setAffineTransform:CGAffineTransformScale(CGAffineTransformMakeRotation(_rotationRadians), _scale, _scale)];
}

- (void)setScale:(float)aScale
{
    if (_scale == aScale)
        return;
    
    _scale = aScale;
    
    [_imageLayer setAffineTransform:CGAffineTransformScale(CGAffineTransformMakeRotation(_rotationRadians), _scale, _scale)];
}

- (void)imageDidLoad:(CPImage)anImage
{
    [_imageLayer setNeedsDisplay];
}

- (void)drawLayer:(CALayer)aLayer inContext:(CGContext)aContext
{
    var bounds = [aLayer bounds];
    
    if ([_image loadStatus] != CPImageLoadStatusCompleted)
        [_image setDelegate:self];
    else
        CGContextDrawImage(aContext, bounds, _image);
}

@end

@implementation PageView : CPView
{
    CALayer     _rootLayer;
    
    PaneLayer   _paneLayer;
	PaneLayer	_oxLayer;

	CPNumber	_randomNumber;
	CPNumber	_questionNumber;
	CPNumber	_okQ;
	CPNumber	_noQ;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
		_questionNumber = 5;	//전체 문제 갯수 초기화
		_rightQ			= 0;	//맞은갯수 초기화
		_wrongQ			= 0;	//틀린갯수 초기화

        _rootLayer = [CALayer layer];
        
        [self setWantsLayer:YES];
        [self setLayer:_rootLayer];
        
        [_rootLayer setBackgroundColor:[CPColor colorWithHexString:@"aeddc5"]];
        
        _paneLayer = [[PaneLayer alloc] initWithPageView:self];
        
        [_paneLayer setBounds:CGRectMake(0.0, 0.0, 420 - 2 * 20.0, 420.0 - 2 * 20.0)];
        [_paneLayer setAnchorPoint:CGPointMakeZero()];
        [_paneLayer setPosition:CGPointMake(20.0, 20.0)];
        
		_randomNumber = Math.floor(Math.random() * 6) + 1;

        [_paneLayer setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/"+_randomNumber+".jpg" size:CGSizeMake(400.0, 400.0)]];
        
        [_rootLayer addSublayer:_paneLayer]; 
        
        [self registerForDraggedTypes:[PhotoDragType]];
    }
    
    return self;
}

- (void)performDragOperation:(CPDraggingInfo)aSender
{
	var selImage	= [[aSender draggingPasteboard] dataForType:PhotoDragType] 
	var selNumber	= parseInt(/\d/.exec(selImage._propertyList._buckets.$objects[3]));
	var oxValue		= selNumber == _randomNumber ? "o" : "x";

	selNumber == _randomNumber ? _rightQ ++ : _wrongQ ++ ;
	_questionNumber = _questionNumber - 1;

	_oxLayer = [[PaneLayer alloc] initWithPageView:self];
	[_oxLayer setBounds:CGRectMake(0.0, 0.0, 420 - 2* 20.0, 420.0 - 2 * 20.0)];
	[_oxLayer setAnchorPoint:CGPointMakeZero()];
	[_oxLayer setPosition:CGPointMake(20.0, 20.0)];
	[_oxLayer setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/"+oxValue+".png" size:CGSizeMake(400.0, 400.0)]]; 

	[_rootLayer addSublayer:_oxLayer];
	
	if (_questionNumber <= 0) 
	{
		setTimeout(function(){
			// ox Layer hidden
			[_oxLayer setHidden:"none"];
			
			startWindow1 = [[CPWindow alloc] initWithContentRect:CGRectMake(0.0, 0.0, 810.0, 610.0) styleMask:CPWindowOut];
			[startWindow1 setBackgroundColor:[CPColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.5]];
			[startWindow1 setAutoresizingMask: CPWindowMinYMargin | CPWindowMaxYMargin | CPWindowMinXMargin | CPWindowMaxXMargin];
			[startWindow1 orderFront:self];
			[startWindow1 center];

			startWindow2 = [[CPWindow alloc] initWithContentRect:CGRectMake(0.0, 0.0, 400.0, 150.0) styleMask:CPHUDBackgroundWindowMask ];
			[startWindow2 setAutoresizingMask: CPWindowMinYMargin | CPWindowMaxYMargin | CPWindowMinXMargin | CPWindowMaxXMargin];
			[startWindow2 orderFront:self];
			[startWindow2 center];

			startContent = [startWindow2 contentView];

			iconView = [[CPImageView alloc] initWithFrame:CGRectMake(20.0, 0.0, 100.0, 130.0)],
			[iconView setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/fox.png" size:CGSizeMake(100.0, 130.0)]];
			[iconView setImageScaling:CPScaleProportionally];
			
			textView = [[CPImageView alloc] initWithFrame:CGRectMake(135.0, 10.0, 110.0, 61.0)],
			[textView setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/text_02.png" size:CGSizeMake(110.0, 61.0)]];
			[textView setImageScaling:CPScaleProportionally];
			
			var restartButton = [[CPButton alloc] initWithFrame:CGRectMake(135.0, 85.0, 97.0, 32.0)];
			[restartButton setBordered:NO];
			[restartButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/replay_btn.png" size:CGSizeMake(97.0, 32.0)]];
			[restartButton setAction:@selector(restartGame:)]; 

			rightTextField = [CPTextField labelWithTitle:@""+_rightQ+"개"];
			[rightTextField setTextColor:[CPColor whiteColor]];
			[rightTextField setFrameOrigin:CGPointMake(220.0, 35.0)];
			
			wrongTextField2 = [CPTextField labelWithTitle:@""+_wrongQ+"개"];
			[wrongTextField2 setTextColor:[CPColor whiteColor]];
			[wrongTextField2 setFrameOrigin:CGPointMake(220.0, 55.0)];

			[startContent addSubview:iconView];
			[startContent addSubview:textView];
			[startContent addSubview:restartButton];
			[startContent addSubview:rightTextField];
			[startContent addSubview:wrongTextField2];
		},500);

	}else{
		setTimeout(function(){
			_randomNumber = Math.floor(Math.random() * 6) + 1;
			[_paneLayer setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/"+_randomNumber+".jpg" size:CGSizeMake(400.0, 400.0)]];

			// ox Layer hidden
			[_oxLayer setHidden:"none"];
		},500);
	}
}

@end
