//
//  DefaultStyleSheet.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DefaultStyleSheet.h"

#define kFigureImageWidth 57
#define kDisclosureWidth 10
#define kTableCellSmallMargin 2

@implementation DefaultStyleSheet

- (UIColor*)navigationBarTintColor {
  return RGBCOLOR(11, 11, 11);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)badgeWithFontSize:(CGFloat)fontSize {
  return
  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:3] next:
   [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) next:
    [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.8) blur:3 offset:CGSizeMake(0, 4) next:
     [TTReflectiveFillStyle styleWithColor:RGBACOLOR(12,140,21,0.9) next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
       [TTSolidBorderStyle styleWithColor:[UIColor whiteColor] width:2 next:
        [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(1, 7, 2, 7) next:
         [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:fontSize]
                              color:[UIColor whiteColor] next:nil]]]]]]]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)largeBadge {
  return [self badgeWithFontSize:14];
}


- (TTStyle*)defaultButton:(UIControlState)state {
  if (state == UIControlStateNormal) {
    return
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(5, 0, 0, 0) next:
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:2] next:
      [TTReflectiveFillStyle styleWithColor:RGBACOLOR(12,14,21,0.9) next:
      [TTSolidBorderStyle styleWithColor:[UIColor whiteColor] width:1 next:
      [TTTextStyle styleWithFont:nil color:[UIColor whiteColor]
                     shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                    shadowOffset:CGSizeMake(0, -1) next:nil]]]]];
  } else if (state == UIControlStateHighlighted) {
    return
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(6, -2, -2, -2) next:
     [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:3] next:
      [TTReflectiveFillStyle styleWithColor:RGBACOLOR(12,14,21,0.9) next:
       [TTSolidBorderStyle styleWithColor:[UIColor grayColor] width:1 next:
       [TTTextStyle styleWithFont:nil color:[UIColor whiteColor]
                      shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                     shadowOffset:CGSizeMake(0, -1) next:nil]]]]];
  } else {
    return nil;
  }
}



- (TTShapeStyle*)figureImage {
  return [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
          [TTContentStyle styleWithNext:nil]];
  
}

- (TTBoxStyle*)figureImageRight {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(0, kTableCellSmallMargin, kTableCellSmallMargin, 0)
                             padding:UIEdgeInsetsZero
                             minSize:CGSizeZero
                            position:TTPositionFloatRight
                                next:[self figureImage]];
}

- (TTStyle*)figureTableImage {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(kTableCellSmallMargin, kTableCellSmallMargin, kTableCellSmallMargin, 0)
                             padding:UIEdgeInsetsZero
                             minSize:CGSizeZero
                            position:TTPositionAbsolute
                                next:[self figureImage]];
}

- (TTStyle*)tableMessageContent {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(kTableCellSmallMargin,
                                                      kFigureImageWidth + kTableCellSmallMargin * 2,
                                                      kTableCellSmallMargin,
                                                      kTableCellSmallMargin + kDisclosureWidth)
                             padding:UIEdgeInsetsZero
                             minSize:CGSizeZero
                            position:TTPositionStatic
                                next:nil];
}

@end
