//
//  LockedViewController.h
//  Mini Collector
//
//  Created by Peter Stromberg on 2011-08-14.
//  Copyright 2011 NA. All rights reserved.
//

#import <Three20UI/Three20UI.h>

@interface LockedViewController : TTViewController {
  @private
  NSInteger _series;
  BOOL _loaded;
  TTImageView *_imageView;
  TTActivityLabel *_purchaseActivityLabel;
}

@property (nonatomic, retain, readonly) TTButton *purchaseButton;
@property (nonatomic, retain, readonly) TTLabel *purchaseInfoLabel;

- (id)initWithSeries:(NSInteger)series;

@end
