//
//  TTPageControl+SeriesDots.m
//  Mini Collector
//
//  Created by Peter Stromberg on 2011-08-10.
//  Copyright 2011 NA. All rights reserved.
//

#import "TTPageControl+SeriesDots.h"
#import "DefaultStyleSheet.h"

@implementation TTPageControl (TTPageControl_SeriesDots)

- (UIColor*)colorForPage:(NSInteger)page {
  float alpha = (page == _currentPage) ? 1.0 : 0.5;
  switch (page) {
    case 0:
      return RGBACOLOR(255, 255, 0, alpha);
      break;
    case 1:
      return RGBACOLOR(0, 0, 255, alpha);
      break;
    case 2:
      return RGBACOLOR(0, 255, 0, alpha);
      break;
    case 3:
      return RGBACOLOR(255, 175, 0, alpha);
      break;
    case 4:
      return RGBACOLOR(100, 100, 255, alpha);
      break;      
    default:
      return nil;
      break;
  }
}

- (void)drawDotForPage:(NSInteger)page inContext:(TTStyleContext *)context  {
    [[(DefaultStyleSheet*)[TTStyleSheet globalStyleSheet] pageDotWithColor:[self colorForPage:page]] draw:context];
}

#pragma mark -
#pragma mark Properties

- (TTStyle*)normalDotStyle {
  if (!_normalDotStyle) {
    _normalDotStyle = [[[TTStyleSheet globalStyleSheet] styleWithSelector:_dotStyle
                                                                 forState:UIControlStateNormal] retain];
  }
  return _normalDotStyle;
}

- (TTStyle*)currentDotStyle {
  if (!_currentDotStyle) {
    _currentDotStyle = [[[TTStyleSheet globalStyleSheet] styleWithSelector:_dotStyle
                                                                  forState:UIControlStateSelected] retain];
  }
  return _currentDotStyle;
}

#pragma mark -
#pragma mark UIView

- (void)drawRect:(CGRect)rect {
  if (_numberOfPages <= 1 && _hidesForSinglePage) {
    return;
  }
  
  TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
  TTBoxStyle* boxStyle = [self.normalDotStyle firstStyleOfClass:[TTBoxStyle class]];
  
  CGSize dotSize = [self.normalDotStyle addToSize:CGSizeZero context:context];
  
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
