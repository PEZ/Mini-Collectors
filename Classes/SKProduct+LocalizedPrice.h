//
//  SKProduct+LocalizedPrice.h
//  Mini Collector
//
//  Created by PEZ on 2010-10-02.

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end