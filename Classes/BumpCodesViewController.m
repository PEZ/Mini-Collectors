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

-(void)addItemForNumber:(NSNumber*)n forSeries:(NSInteger)series toDataSource:(TTListDataSource*)dataSource  {
  [dataSource.items addObject:
			 [TTTableStyledTextItem itemWithText:
				[TTStyledText textFromXHTML:
				 [NSString stringWithFormat:
					@"<img src=\"bundle://bump-%d-%@.png\" width=\"232\" height=\"30\"/>", series, n]]
																			 URL:[NSString stringWithFormat:@"mc://hidden/%d-%@", series, n]]];

}

-(id)initWithSeries:(NSInteger)series {
  if (self = [super initWithNibName:nil	bundle:nil]) {
    self.autoresizesForKeyboard = YES;
    self.variableHeightRows = YES;
		self.title = @"Bump Codes";

		NSArray* trickies = [NSArray arrayWithObjects:N(2), N(7), N(13), nil];
		NSMutableArray* nonTrickies = [NSMutableArray arrayWithCapacity:16];
		for (int i = 1; i < 17; i++) {
			[nonTrickies addObject:N(i)];
		}
		[nonTrickies removeObjectsInArray:trickies];

    TTListDataSource* dataSource = [[[TTListDataSource alloc] init] autorelease];

		for (NSNumber* n in nonTrickies) {
			[self addItemForNumber:n forSeries:series toDataSource:dataSource];
		}
		[dataSource.items shuffle];

	  NSString *help = @"The Series 3 bags don't have the barcodes that Series 1 &amp; 2 had. \
But there's still a code on the bags. Along the <b>bottom seal</b> of the <b>back of the bag</b> \
you can see some \"raised\" bumps. Match those bumps with the patterns below and tap it.";
		[dataSource.items insertObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil] atIndex:0];

		help = @"Three of the patterns are extra similar. They are grouped together below. \
They represent the <b>Gorilla</b>, the <b>Indian Chief</b> and the <b>Samurai</b>, in that order.";	
		[dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil]];
		for (NSNumber* n in trickies) {
			[self addItemForNumber:n forSeries:series toDataSource:dataSource];
		}		

		help = @"Creds to FBTB's forum user <b>That guy</b> for cracking the codes. \
See http://www.fbtb.net/2010/11/18/series-3-blind-pack-code-cracked/ for more info on the subject.";	
		[dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil]];

		self.dataSource = dataSource;
		[help release];
  }
  return self;
}

@end
