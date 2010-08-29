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
//  TTButton *_downButton;
//  TTButton *_upButton;
  TTLabel *_figureCountLabel;
}


@property (nonatomic, retain) Figure *figure;
@property (nonatomic, retain) TTImageView *imageView;
//@property (nonatomic, retain) TTButton *downButton;
//@property (nonatomic, retain) TTButton *upButton;
@property (nonatomic, retain) TTLabel *figureCountLabel;

@end
