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


+ (InAppPurchaseManager *) getInstance {
  if (_instance == nil) {
    _instance = [[InAppPurchaseManager alloc] init];
  }
  return _instance;
}

- (SKProduct*)series3Product {
	return _series3Product;
}

#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore
{
  // restarts any purchases if they were interrupted last time the app was open
  [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

  // get the product description (defined in early sections)
  [self requestSeries3UpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
  return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseSeries3
{
  SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseSeries3UpgradeProductId];
  [[SKPaymentQueue defaultQueue] addPayment:payment];
}


- (void)requestSeries3UpgradeProductData {
  NSSet *productIdentifiers = [NSSet setWithObject:kInAppPurchaseSeries3UpgradeProductId];
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
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
  if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseSeries3UpgradeProductId])
  {
    // save the transaction receipt to disk
    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"series3UpgradeTransactionReceipt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

//
// enable series 3 features
//
- (void)provideContent:(NSString *)productId
{
  if ([productId isEqualToString:kInAppPurchaseSeries3UpgradeProductId])
  {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsSeries3ProductUnlocked];
    [[NSUserDefaults standardUserDefaults] synchronize];
		[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerSeries3ContentProvidedNotification object:self];
  }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
  // remove the transaction from the payment queue.
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
  if (wasSuccessful)
  {
    // send out a notification that we’ve finished the transaction
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
  }
  else
  {
    // send out a notification for the failed transaction
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
  }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
  [self recordTransaction:transaction];
  [self provideContent:transaction.payment.productIdentifier];
  [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
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
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
  for (SKPaymentTransaction *transaction in transactions)
  {
    switch (transaction.transactionState)
    {
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
  NSArray *products = response.products;
  _series3Product = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;
  if (_series3Product) {
    DLog(@"Product title: %@" , _series3Product.localizedTitle);
    DLog(@"Product description: %@" , _series3Product.localizedDescription);
    DLog(@"Product price: %@" , [_series3Product localizedPrice]);
    DLog(@"Product id: %@" , _series3Product.productIdentifier);
  }

  for (NSString *invalidProductId in response.invalidProductIdentifiers) {
    DLog(@"Invalid product id: %@" , invalidProductId);
  }
  // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
  [productsRequest release];

  [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

@end
