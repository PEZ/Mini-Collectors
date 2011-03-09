//
//  InAppPurchaseManager.h
//  Mini Collector
//
//  Created by PEZ on 2010-10-02.

#import <StoreKit/StoreKit.h>
#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseManagerSeries3ContentProvidedNotification @"kInAppPurchaseManagerSeries3ContentProvidedNotification"

#define kInAppPurchaseSeries3UpgradeProductId @"com.pezius.minicollector.series3"
#define kIsSeriesProductUnlocked @"isSeries%dProductUnlocked"
#define kInAppPurchaseSeries4UpgradeProductId @"com.pezius.minicollector.series4"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
  SKProduct *_series3Product;
  SKProductsRequest *productsRequest;
}

- (void)requestSeries3UpgradeProductData;
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseSeries3;
- (void)provideContent:(NSString *)productId;
+ (InAppPurchaseManager *) getInstance;
- (SKProduct*) series3Product;

@end
