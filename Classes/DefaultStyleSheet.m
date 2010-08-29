//
//  DefaultStyleSheet.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DefaultStyleSheet.h"


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
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
     [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.7) blur:3 offset:CGSizeMake(2, 2) next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0.25, 0.25, 0.25, 0.25) next:
       [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-0.25, -0.25, -0.25, -0.25) next:
         [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
          [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 0, 0) next:
           [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
            [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                           shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                          shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]]]];
  } else if (state == UIControlStateHighlighted) {
    return
    [TTInsetStyle styleWithInset:UIEdgeInsetsMake(3, 3, 0, 0) next:
     [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
      [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
       [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 0, 0) next:
         [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
          [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                         shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                        shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
  } else {
    return nil;
  }
}

@end
