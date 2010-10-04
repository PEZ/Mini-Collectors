//
//  SKProduct+LocalizedPrice.m
//  Mini Collector
//
//  Created by PEZ on 2010-10-02.
//

#import "SKProduct+LocalizedPrice.h"

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice {
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
  [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [numberFormatter setLocale:self.priceLocale];
  NSString *formattedString = [numberFormatter stringFromNumber:self.price];
  [numberFormatter release];
  return formattedString;
}

@end