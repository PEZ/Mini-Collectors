//
//  BumpCodesViewController.m
//  Mini Collector
//
//  Created by Peter Stromberg on 2011-01-09.
//  Copyright 2011 NA. All rights reserved.
//

#import "BumpCodesViewController.h"
#import "NSMutableArray+Shuffle.h"

@implementation BumpCodesViewController

-(id)initWithSeries:(NSInteger)series {
  if (self = [super initWithNibName:nil	bundle:nil]) {
    self.autoresizesForKeyboard = YES;
    self.variableHeightRows = YES;
		self.title = @"Bump Codes";

    TTListDataSource* dataSource = [[[TTListDataSource alloc] init] autorelease];
		for (int i = 1; i < 17; i++) {
			[dataSource.items addObject:
			 [TTTableStyledTextItem itemWithText:
				[TTStyledText textFromXHTML:
				 [NSString stringWithFormat:
					@"<img src=\"bundle://bump-%d-%d.png\" width=\"232\" height=\"30\"/>", series, i]]
																			 URL:[NSString stringWithFormat:@"mc://hidden/%d-%d", series, i]]];
		}
		[dataSource.items shuffle];
	  NSString *help = @"The Series 3 bags don't have the barcodes that Series 1 &amp; 2 had. \
But there's still a code on the bags. \
Along the bottom seal of the bag you can feel some \"raised\" bumps. \
Match those bumps with the patterns below and tap it.\n\n\
See http://www.fbtb.net/2010/11/18/series-3-blind-pack-code-cracked/ for more info on the subject.\n\n\
Note that some of the patterns are very similar. \
You might want to use that \"Reveal\" button to combine this pattern matching with good 'ol feel-the-bag techniques.";
		[dataSource.items insertObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil] atIndex:0];
    self.dataSource = dataSource;
		[help release];
  }
  return self;
}

@end
