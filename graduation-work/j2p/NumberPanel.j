/*
*	NumberPanel.j
*	
*	Created by J2P
*/

@import <AppKit/CPPanel.j>


PhotoDragType = "PhotoDragType";

@implementation PhotoPanel : CPPanel
{
    CPArray		images;
}

- (id)init
{
	var size = navigator.userAgent.indexOf("Firefox") > 0 ? { width : window.innerWidth, height : window.innerHeight } : 
		{ width : window.document.width, height : window.document.height };

    self = [self initWithContentRect:CGRectMake((size.width / 2) - 365 , (size.height / 2) - 150 , 250.0, 340.0) styleMask:CPHUDBackgroundWindowMask];

    if (self)
    {
        [self setTitle:@"Numbers"];
		[self setAutoresizingMask: CPWindowMinYMargin | CPWindowMaxYMargin | CPWindowMinXMargin | CPWindowMaxXMargin];
        
        var contentView = [self contentView],
            bounds = [contentView bounds];

        bounds.size.height -= 20.0;
        
        var photosView = [[CPCollectionView alloc] initWithFrame:bounds];
        
        [photosView setAutoresizingMask:CPViewWidthSizable];
        [photosView setMinItemSize:CGSizeMake(100, 100)];
        [photosView setMaxItemSize:CGSizeMake(100, 100)];
        [photosView setDelegate:self];
        
        var itemPrototype = [[CPCollectionViewItem alloc] init];
        
        [itemPrototype setView:[[PhotoView alloc] initWithFrame:CGRectMakeZero()]];
        
        [photosView setItemPrototype:itemPrototype];
        
        var scrollView = [[CPScrollView alloc] initWithFrame:bounds];
        
        [scrollView setDocumentView:photosView];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [scrollView setAutohidesScrollers:YES];
        [[scrollView contentView] setBackgroundColor:[CPColor whiteColor]];

        [contentView addSubview:scrollView];
        
        images = [ [[CPImage alloc] initWithContentsOfFile:@"Resources/num_1.png"
                                                      size:CGSizeMake(100.0, 100.0)], 
                    [[CPImage alloc] initWithContentsOfFile:@"Resources/num_2.png"
                                                       size:CGSizeMake(100.0, 100.0)],
                    [[CPImage alloc] initWithContentsOfFile:@"Resources/num_3.png"
                                                       size:CGSizeMake(100.0, 100.0)],
                    [[CPImage alloc] initWithContentsOfFile:@"Resources/num_4.png"
                                                       size:CGSizeMake(100.0, 100.0)],
                    [[CPImage alloc] initWithContentsOfFile:@"Resources/num_5.png"
                                                       size:CGSizeMake(100.0, 100.0)],
                    [[CPImage alloc] initWithContentsOfFile:@"Resources/num_6.png"
                                                       size:CGSizeMake(100.0, 100.0)]  ];
                    
        [photosView setContent:images];
    }

    return self;
}


- (CPData)collectionView:(CPCollectionView)aCollectionView dataForItemsAtIndexes:(CPIndexSet)indices forType:(CPString)aType
{
    return [CPKeyedArchiver archivedDataWithRootObject:[images objectAtIndex:[indices firstIndex]]];
}

- (CPArray)collectionView:(CPCollectionView)aCollectionView dragTypesForItemsAtIndexes:(CPIndexSet)indices
{
    return [PhotoDragType];
}

@end


@implementation PhotoView : CPImageView
{
    CPImageView _imageView;
}

- (void)setSelected:(BOOL)isSelected
{
    [self setBackgroundColor:isSelected ? [CPColor grayColor] : nil];
}

- (void)setRepresentedObject:(id)anObject
{
    if (!_imageView)
    {
        _imageView = [[CPImageView alloc] initWithFrame:CGRectInset([self bounds], 5.0, 5.0)];
        
        [_imageView setImageScaling:CPScaleProportionally];
        [_imageView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        [self addSubview:_imageView];
    }
    
    [_imageView setImage:anObject];
}

@end