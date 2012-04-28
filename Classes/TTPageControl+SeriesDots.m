//
//  TTPageControl+SeriesDots.m
//  Mini Collector
//
//  Created by Peter Stromberg on 2011-08-10.
//  Copyright 2011 NA. All rights reserved.
//

#import "TTPageControl+SeriesDots.h"
#import <Three20UI/UIViewAdditions.h>
#import "DefaultStyleSheet.h"

@implementation TTPageControl (TTPageControl_SeriesDots)

- (UIColor*)colorForPage:(NSInteger)page {
  float alpha = (page == _currentPage) ? 1.0 : 0.4;
  switch (page) {
    case 0:
      return RGBACOLOR(255, 200, 0, alpha);
      break;
    case 1:
      return RGBACOLOR(1, 129, 200, alpha);
      break;
    case 2:
      return RGBACOLOR(150, 200, 50, alpha);
      break;
    case 3:
      return RGBACOLOR(255, 150, 50, alpha);
      break;
    case 4:
      return RGBACOLOR(0, 175, 205, alpha);
      break;      
    case 5:
      return RGBACOLOR(225, 225, 225, alpha);
      break;      
    case 6:
      return RGBACOLOR(221, 40, 31, alpha);
      break;      
    default:
      return nil;
      break;
  }
}

- (TTStyle*)dotStyleForPage:(NSInteger)page {
  return [(DefaultStyleSheet*)[TTStyleSheet globalStyleSheet] pageDotWithColor:[self colorForPage:page]];
}

- (void)drawDotForPage:(NSInteger)page inContext:(TTStyleContext *)context {
    [[self dotStyleForPage:page] draw:context];
}

#pragma mark -
#pragma mark UIView

- (void)drawRect:(CGRect)rect {
  if (_numberOfPages <= 1 && _hidesForSinglePage) {
    return;
  }
  
  TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
  TTBoxStyle* boxStyle = [[self dotStyleForPage:0] firstStyleOfClass:[TTBoxStyle class]];
  
  CGSize dotSize = [[self dotStyleForPage:0] addToSize:CGSizeZero context:context];
  
  CGFloat dotWidth = dotSize.width + boxStyle.margin.left + boxStyle.margin.right;
  CGFloat totalWidth = (dotWidth * _numberOfPages) - (boxStyle.margin.left + boxStyle.margin.right);
  CGRect contentRect = CGRectMake(round(self.width/2 - totalWidth/2),
                                  round(self.height/2 - dotSize.height/2),
                                  dotSize.width, dotSize.height);
  
  for (NSInteger i = 0; i < _numberOfPages; ++i) {
    contentRect.origin.x += boxStyle.margin.left;
    
    context.frame = contentRect;
    context.contentFrame = contentRect;
    
    [self drawDotForPage:i inContext:context];

    contentRect.origin.x += dotSize.width + boxStyle.margin.right;
  }
}

@end
