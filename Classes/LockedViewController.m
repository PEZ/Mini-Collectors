//
//  LockedViewController.m
//  Mini Collector
//
//  Created by Peter Stromberg on 2011-08-14.
//  Copyright 2011 NA. All rights reserved.
//

#import <Three20UI/UIViewAdditions.h>

#import "LockedViewController.h"
#import "AppDelegate.h"
#import "InAppPurchaseManager.h"
#import "SKProduct+LocalizedPrice.h"

#define MARGIN 5

@implementation LockedViewController

- (id)initWithSeries:(NSInteger)series {
  self = [super init];
  if (self) {
    _series = series;
    self.title = [NSString stringWithFormat:@"Series %d is locked", _series];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                              target:self
                                              action:@selector(dismiss)] autorelease];
  }
  return self;
}

static NSMutableDictionary *_purchaseButtons;
static NSMutableDictionary *_purchaseInfoLabels;

- (void)dealloc {
  TT_RELEASE_SAFELY(_purchaseActivityLabel);
  [super dealloc];
}

- (void)dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

+ (void)createPurchaseButtons {
	if (_purchaseButtons == nil) {
		_purchaseButtons = [[NSMutableDictionary dictionaryWithCapacity:2] retain];
		for (NSString *productId in kInAppPurchaseSeriesProducts) {
			[_purchaseButtons setObject:[[TTButton buttonWithStyle:@"defaultButton:"
																											 title:@"Unlock"] retain]
													 forKey:productId];
		}
	}
}

+ (void)createPurchaseInfoLabels {
	if (_purchaseInfoLabels == nil) {
		_purchaseInfoLabels = [[NSMutableDictionary dictionaryWithCapacity:2] retain];
		for (NSString *productId in kInAppPurchaseSeriesProducts) {
			[_purchaseInfoLabels setObject:[[[TTLabel alloc] initWithText:[NSString stringWithFormat:@"Series %d support",
                                                                     [InAppPurchaseManager seriesForProductId:productId]]] retain]
                              forKey:productId];
		}
	}
}

- (NSString*)productId {
	return [InAppPurchaseManager productIdForSeries:_series];
}

- (TTButton*)purchaseButton {
	return [_purchaseButtons objectForKey:[self productId]];
}

- (TTLabel*)purchaseInfoLabel {
	return [_purchaseInfoLabels objectForKey:[self productId]];
}

- (void)createPurchaseActivityLabel {
	if (_purchaseActivityLabel == nil) {
		_purchaseActivityLabel = [[[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleBlackBox] retain];
		_purchaseActivityLabel.text = @"Purchase in progress...";
		[_purchaseActivityLabel sizeToFit];
		_purchaseActivityLabel.frame = CGRectMake(0, _imageView.bottom + MARGIN, self.view.width, _purchaseActivityLabel.height);
		[self.view addSubview:_purchaseActivityLabel];
	}
}

- (void)purchase {
	[self createPurchaseActivityLabel];
	_purchaseActivityLabel.hidden = NO;
	self.purchaseButton.hidden = YES;
	InAppPurchaseManager *purchaseManager = [InAppPurchaseManager getInstance];
	if ([purchaseManager canMakePurchases]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:productIdKey(kInAppPurchaseManagerSeriesContentProvidedNotification, [self productId])
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seriesContentProvided)
                                                 name:productIdKey(kInAppPurchaseManagerSeriesContentProvidedNotification, [self productId])
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:productIdKey(kInAppPurchaseManagerTransactionFailedNotification, [self productId])
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(purchaseFailed)
                                                 name:productIdKey(kInAppPurchaseManagerTransactionFailedNotification, [self productId])
                                               object:nil];	
		[purchaseManager purchase:[self productId]];		
	}
	else {
#if TARGET_IPHONE_SIMULATOR
		[purchaseManager provideContent:[self productId]];
    [self dismiss];
#else
		TTAlert(@"Purchases are not available.");
#endif
	}
}

+ (void)sizePurchaseButton:(TTButton*)button {
	button.font = [UIFont systemFontOfSize:18];
	[button sizeToFit];
	button.width += 40;
	button.height += 15;
	button.left = (320 - button.width) / 2;
}

- (TTStyle*)purchaseInfoLabelStyle {
  return
  [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:16]
                       color:[UIColor blackColor]
             minimumFontSize:0
                 shadowColor:[UIColor colorWithWhite:0 alpha:0.9] 
                shadowOffset:CGSizeMake(0, 0) 
               textAlignment:UITextAlignmentCenter 
           verticalAlignment:UIControlContentVerticalAlignmentBottom 
               lineBreakMode:UILineBreakModeTailTruncation 
               numberOfLines:6
                        next:nil];
}

- (void)loadView {
  if (!_loaded) {
    _loaded = YES;
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];

    _imageView = [[TTImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    _imageView.autoresizesToImage = YES;
    _imageView.urlPath = [NSString stringWithFormat:@"bundle://Locked-%d.png", _series];
    [self.view addSubview:_imageView];

    [[self class] createPurchaseButtons];
    [[self class] createPurchaseInfoLabels];
    [[self class] sizePurchaseButton:self.purchaseButton];
    self.purchaseButton.hidden = NO;
    self.purchaseButton.top = _imageView.bottom + MARGIN;
    [self.purchaseButton removeTarget:nil action:@selector(purchase) forControlEvents:UIControlEventTouchUpInside];
    [self.purchaseButton addTarget:self action:@selector(purchase) forControlEvents:UIControlEventTouchUpInside];			
    [self.view addSubview:self.purchaseButton];
    self.purchaseInfoLabel.frame = CGRectMake(MARGIN, _imageView.bottom - 200, self.view.frame.size.width - MARGIN * 2, 140);
    self.purchaseInfoLabel.style = [self purchaseInfoLabelStyle];
    self.purchaseInfoLabel.backgroundColor = RGBACOLOR(0,0,0,0);
    [self.view addSubview:self.purchaseInfoLabel];
  }
}

#pragma mark -
#pragma mark Notifications

-(void)seriesContentProvided {
	[self dismiss];
}

-(void)purchaseFailed {
	_purchaseActivityLabel.hidden = YES;
	self.purchaseButton.hidden = NO;
	self.purchaseButton.hidden = NO;
}

+(void)purchaseProductFetched {
	[self createPurchaseButtons];
	[self createPurchaseInfoLabels];
	for (NSString *productId in kInAppPurchaseSeriesProducts) {
		SKProduct *product = [[[InAppPurchaseManager getInstance] seriesProducts] objectForKey:productId];
		TTButton *button = [_purchaseButtons objectForKey:productId];
		[button setTitle:[NSString stringWithFormat:@"%@", [product localizedPrice]]
						forState:UIControlStateNormal];
		[self sizePurchaseButton:button];
		TTLabel *label = [_purchaseInfoLabels objectForKey:productId];
		label.text = [NSString stringWithFormat:@"%@\n%@", product.localizedTitle, product.localizedDescription];
	}
}


@end
