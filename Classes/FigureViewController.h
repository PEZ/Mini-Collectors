//
//  FigureViewController.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "Figure.h"

@interface FigureViewController : TTModelViewController {
  Figure *_figure;
  TTImageView *_imageView;
  TTButton *_downButton;
  TTButton *_upButton;
}

@property (nonatomic, retain) Figure *figure;
@property (nonatomic, copy) TTImageView *imageView;
@property (nonatomic, copy) TTButton *downButton;
@property (nonatomic, copy) TTButton *upButton;

@end
