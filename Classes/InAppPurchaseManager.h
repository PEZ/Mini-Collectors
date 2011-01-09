//
//  InAppPurchaseManager.h
//  Mini Collector
//
//  Created by PEZ on 2010-10-02.

#import <StoreKit/StoreKit.h>
#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
  SKProduct *scannerProduct;
  SKProductsRequest *productsRequest;
}

- (void)requestSeries3UpgradeProductData;
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseSeries3;
+ (InAppPurchaseManager *) getInstance;

@end
