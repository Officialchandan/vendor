class Endpoint {
  // static const String BASE_URL = "http://vendor.tekzee.in/api/v1/";
  // http://vendor.myprofitinc.com/
  static const String BASE_URL = "http://vendor.myprofitinc.com/api/v1/";
  static const String GENERATE_OTP = "genereateOTP";

  static const String VERIFY_OTP = "verifyOTP";

  static const String GET_CUSTOMER_COINS = "getCustomerCoins";

  static const String GET_ALL_CATEGORY = "getAllCategoryByVendorID";

  static const String GET_ALL_VENDOR_PRODUCTS = "getAllVendorProducts";

  static const String GET_VENDOR_PRODUCT_BY_CATEGORY =
      "getVendorProductByCategory";

  static const String GET_SUGGESTED_PRODUCTS = "getSuggestedProducts";

  static const String ADD_SUGGESTED_PRODUCTS = "addSuggestedProducts";

  static const String GET_UNITS_BY_CATEGORY = "getUnitsByCategoryId";

  static const String GET_SIZE_BY_CATEGORY = "getSizeByCategoryId";

  static const String GET_SUB_CATEGORY = "getSubCategory";

  static const String ADD_PRODUCT_SUBCATEGORY = "addProductSubCategory";

  // static const String GET_PRODUCT_VARIANT_TYPE = "getProductVariants";

  static const String BILLING_PRODUCT = "billingProducts";

  static const String GET_PRODUCT_VARIANT_TYPE = "getVariants";

  static const String GET_COLORS = "getColors";

  static const String ADD_VENDOR_PRODUCT = "addVendorProduct";

  static const String EDIT_VENDOR_PRODUCT = "editVendorProduct";

  static const String ADD_PRODUCT_IMAGE = "addProductImage";

  static const String GET_SUBCATEGORY_VENDORID = "getAllCategoryByVendorID";

  static const String DELETE_PRODUCT_IMAGE = "deleteProductImage";

  static const String DELETE_PRODUCT_VARIANT = "deleteProductVariant";

  static const String GET_BRANDS = "getBrands";

  static const String GET_PURCHASED_PRODUCTS = "getCustomerPurchasedProducts";

  static const String SALES_RETURN = "salesReturn";

  static const String SALES_RETURN_OTP = "verifySalesReturnByOTP";

  static const String PURCHASE_RETURN = "purchaseReturn";

  static const String GET_VERIFY_EARNING_COINOTP_VENDORID =
      "verifyEarningCoinsByOTP";

  static const String GET_DAILY_SALE_AMOUNT = "dailySaleAmount";

  static const String GET_MONTHLY_SALE_AMOUNT = "monthlySaleAmount";

  static const String GENERATE_REPORT = "generateReports";

  static const String GET_GENERATE_COIN_REPORT_BY_DAY =
      "getGenerateCoinReportByDay";

  static const String GET_GENERATE_COIN_REPORT_BY_DATE_OF_CHAT_PAPDI =
      "getChatPapdiGenerateCoinReportByDate";

  static const String GET_GENERATE_COIN_REPORT_BY_DATE =
      "getGenerateCoinReportByDate";

  static const String GET_GENERATE_COIN_REPORT_BY_DAY_OF_CHAT_PAPDI =
      "getChatPapdiGenerateCoinReportByDay";

  static const String GET_SALE_RETURN_REPORT_BY_DATE =
      "getSaleReturnReportbyDate";

  static const String GET_SALE_RETURN_REPORT_BY_DAY =
      "getSaleReturnReportbyDay";

  static const String GET_PRODUCT_REDEEM_REPORT_BY_DATE =
      "getProductRedeemReportByDate";

  static const String GET_PRODUCT_REDEEM_REPORT_BY_DAY =
      "getProductRedeemReportByDay";

  static const String GET_COIN_REDEEM_REPORT_BY_DATE =
      "getCoinRedeemedReportByDate";

  static const String GET_COIN_REDEEM_REPORT_BY_DATE_OF_CHAT_PAPDI =
      "getChatPapdiRedeemedCoinReportByDate";

  static const String GET_COIN_REDEEM_REPORT_BY_DAY =
      "getCoinRedeemedReportByDay";

  static const String GET_COIN_REDEEM_REPORT_BY_DAY_OF_CHAT_PAPDI =
      "getChatPapdiRedeemedCoinReportByDay";

  static const String GET_READY_STOCK_REPORT = "getReadyStockReport";

  static const String GET_DAILY_REPORT = "getDailyReport";

  static const String GET_DAILY_REPORT_CHAT_PAPDI = "getChatPapdiDailyReport";

  static const String GET_HOURLY_SALE_AMOUNT = "hourlySaleAmount";

  static const String GET_HOURLY_EARNING_AMOUNT = "hourlyEarningAmount";

  static const String GET_HOURLY_WALKIN_AMOUNT = "hourlyWalkIns";

  static const String GET_LOG_OUT = "logout";

  static const String GET_VENDOR_PROFILE = "getVendorDetails";

  static const String GET_DAILY_EARNING_AMOUNT = "dailyEarningAmount";

  static const String GET_MONTHLY_EARNING_AMOUNT = "monthlyEarningAmount";

  static const String GET_DAILY_WALKIN_AMOUNT = "dailyWalkIns";

  static const String GET_MONTHLY_WALKIN_AMOUNT = "monthlyWalkIns";

  static const String GET_DIRECT_BILLING = "directBilling";

  static const String GET_DIRECT_BILLING_OTP = "confirmBillingByOtp";

  static const String GET_MY_CUSTOMER = "getAllCustomersByVendorID";

  static const String GET_CUSTOMER_OF_CHAT_PAPDI =
      "getAllChatPapdiCustomersByVendorID";

  static const String GET_CUSTOMER_PRODUCT = "getAllProductByCustomerID";

  static const String GET_TOTAL_MONEY_DUE = "getTotalMoneyDue";

  static const String GET_CHATPAPDI_BILLING = "chatPapdiBilling";

  static const String GET_CHATPAPDI_BILLING_OTP =
      "confirmChatPapdiBillingByOtp";

  static const String GET_CHATPAPDI_DAILY_REPORT = "chatPapdiDailySaleAmount";

  static const String GET_CHATPAPDI_HOURLY_SALE_AMOUNT =
      "chatPapdiHourlySaleAmount";

  static const String GET_CHATPAPDI_MONTHLY_SALE_AMOUNT =
      "chatPapdiMonthlySaleAmount";

  static const String GET_CHATPAPDI_HOURLY_WALKIN_AMOUNT =
      "chatPapdiHourlyWalkIns";

  static const String GET_CHATPAPDI_DAILY_WALKIN_AMOUNT =
      "chatPapdiDailyWalkIns";

  static const String GET_CHATPAPDI_MONTHLY_WALKIN_AMOUNT =
      "chatPapdiMonthlyWalkIns";

  static const String GET_CHATPAPDI_HOURLY_EARNING_AMOUNT =
      "chatPapdiHourlyEarningAmount";

  static const String GET_CHATPAPDI_DAILY_EARNING_AMOUNT =
      "chatPapdiDailyEarningAmount";

  static const String GET_CHATPAPDI_MONTHLY_EARNING_AMOUNT =
      "monthlyEarningAmount";

  static const String GET_CHATPAPDI_PARTIAL_USER_REGISTER =
      "customerPartialRegistration";

  static const String GET__VENDOR_GIFT_SCHEME = "getVendorGiftSchemes";

  static const String GET_UPDATE_VENDOR_GIFT_RECEIVED_STATUS =
      "updateVendorGiftReceivedStatus";

  static const String GET_QR_CODE = "scanQRCode";

  static const String GET_NORMAL_QR_CODE = "scanQRCodeNormalBilling";

  static const String GET_NOTIFICATION_COUNT = "getNotificatonList";

  static const String GET_NOTIFICATIONS = "getVendorSendNotificatonList";

  static const String UPDATE_NOTIFICATION_STATUS =
      "updateSendNotificationStatus";

  static const String GET_VENDOR_FREE_COINS = "getVendorFreeCoins";

  static const String GET_VENDOR_COINS_HISTORY = "getVendorCoinsHistory";

  static const String GET_REDEEM_COINS = "getRedeemCoins";

  static const String GET_VALIDATE_APP_VERSION = "validateAppVersion";

  static const String GET_MASTER_LEDGER_HISTORY = "getMasterLedger";

  static const String GET_SALES_RETURN_HISTORY = "getSaleReturnOrder";
}
