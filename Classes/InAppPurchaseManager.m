//
//  InAppPurchaseManager.m
//  Mini Collector
//
//  Created by PEZ on 2010-10-02.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "SKProduct+LocalizedPrice.h"

@implementation InAppPurchaseManager

static InAppPurchaseManager *_instance;


+ (InAppPurchaseManager*)getInstance {
  if (_instance == nil) {
    _instance = [[InAppPurchaseManager alloc] init];
  }
  return _instance;
}

- (NSDictionary*) seriesProducts {
	return [NSDictionary dictionaryWithDictionary:_seriesProducts];
}

+ (NSString*)productIdForSeries:(uint)series {
	switch (series) {
		case 3:
			return kInAppPurchaseSeries3UpgradeProductId;
			break;
		case 4:
			return kInAppPurchaseSeries4UpgradeProductId;
			break;
		default:
			break;
	}
	return nil;
}

+ (uint)seriesForProductId:(NSString*)productId {
	if ([productId isEqualToString:kInAppPurchaseSeries3UpgradeProductId]) {
		return 3;
	}
	else if ([productId isEqualToString:kInAppPurchaseSeries4UpgradeProductId]) {
		return 4;
	}
	else {
		return 0;
	}
}



#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore {
  // restarts any purchases if they were interrupted last time the app was open
  [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

  // get the product description (defined in early sections)
  [self requestSeriesUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases {
  return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchase:(NSString*)productId {
  [[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProductIdentifier:productId]];
}


- (void)requestSeriesUpgradeProductData {
  NSSet *productIdentifiers = [NSSet setWithObjects:kInAppPurchaseSeries3UpgradeProductId, kInAppPurchaseSeries4UpgradeProductId, nil];
  productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
  productsRequest.delegate = self;
  [productsRequest start];

  // we will release the request object in the delegate callback
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction {
	for (NSString *pId in kInAppPurchaseSeriesProducts) {
		if ([transaction.payment.productIdentifier isEqualToString:pId]) {
			[[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:productIdKey(kInAppPurchaseManagerSeriesUpgradeTransactionReceipt, pId)];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
}

//
// enable series features
//
- (void)provideContent:(NSString *)productId {
	for (NSString *pId in kInAppPurchaseSeriesProducts) {
		uint series = [[self class] seriesForProductId:pId];
		if ([productId isEqualToString:pId]) {
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:seriesKey(kIsSeriesProductUnlocked, series)];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[[NSNotificationCenter defaultCenter] postNotificationName:productIdKey(kInAppPurchaseManagerSeriesContentProvidedNotification, pId)
																													object:self];
		}
	}
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful {
  // remove the transaction from the payment queue.
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
  if (wasSuccessful) {
    [[NSNotificationCenter defaultCenter] postNotificationName:productIdKey(kInAppPurchaseManagerTransactionSucceededNotification,
																																						transaction.payment.productIdentifier)
																												object:self userInfo:userInfo];
  }
  else {
    [[NSNotificationCenter defaultCenter] postNotificationName:productIdKey(kInAppPurchaseManagerTransactionFailedNotification,
																																						transaction.payment.productIdentifier)
																												object:self userInfo:userInfo];
  }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
  [self recordTransaction:transaction];
  [self provideContent:transaction.payment.productIdentifier];
  [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
  [self recordTransaction:transaction.originalTransaction];
  [self provideContent:transaction.originalTransaction.payment.productIdentifier];
  [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
	[self finishTransaction:transaction wasSuccessful:NO];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState) {
      case SKPaymentTransactionStatePurchased:
        [self completeTransaction:transaction];
        break;
      case SKPaymentTransactionStateFailed:
        [self failedTransaction:transaction];
        break;
      case SKPaymentTransactionStateRestored:
        [self restoreTransaction:transaction];
        break;
      default:
        break;
    }
  }
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	_seriesProducts = [[NSMutableDictionary dictionaryWithCapacity:2] retain];
  NSArray *products = response.products;
	for (SKProduct *product in products) {
		[_seriesProducts setObject:product forKey:product.productIdentifier];
		DLog(@"Product title: %@" , product.localizedTitle);
		DLog(@"Product description: %@" , product.localizedDescription);
		DLog(@"Product price: %@" , [product localizedPrice]);
		DLog(@"Product id: %@" , product.productIdentifier);
	}

  for (NSString *invalidProductId in response.invalidProductIdentifiers) {
    DLog(@"Invalid product id: %@" , invalidProductId);
  }
  // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
  [productsRequest release];

  [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

@end
