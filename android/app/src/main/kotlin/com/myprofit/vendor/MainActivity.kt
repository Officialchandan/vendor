package com.myprofit.vendor

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"
    private val paytmUpiPayment = "com.myprofit.vendor/paytmUpiPayment"

    private val UPI_TRANSACTION_RESULT_CODE = 20;

    lateinit var methodChannel : MethodChannel.Result

//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        fun getBatteryLevel(): Int {
//            val batteryLevel: Int
//            if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
//                val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
//                batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
//            } else {
//                val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
//                batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
//            }
//            Log.v("battery", batteryLevel.toString());
//            return batteryLevel
//        }
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//            // Note: this method is invoked on the main thread.
//            call, result ->
//
//            methodChannel = result
//            if (call.method == "getBatteryLevel") {
//                val batteryLevel = getBatteryLevel()
//
//                if (batteryLevel != -1) {
//                    result.success(batteryLevel)
//                } else {
//                    result.error("UNAVAILABLE", "Battery level not available.", null)
//                }
//            } else if (call.method == "paytmUpiPayment") {
//
//
//                Log.e(javaClass.simpleName, "data--->" + call.arguments)
//
//                var data: Map<String, String> = call.arguments()
//
//
//                var deepLink: String = data["callbackurl"].toString()
//
//
//                getUpiAppsInstalled(deepLink)
//            } else {
//                result.notImplemented()
//            }
//        }
//    }

    private fun getUpiAppsInstalled(deepLink: String) {
        try {
            val blacklist = arrayOf("com.olacabs.customer", "com.whatsapp")
            val intent = Intent()
            intent.action = Intent.ACTION_VIEW

//            var link :String = "upi://pay?pa=paytm-14661518@paytm&pn=Ondoor&mc=5411&am=85.00&tr=4379827&tn=ondoor";
            intent.data = Uri.parse(deepLink)


            this.startActivityForResult(Upi(applicationContext).generateCustomChooserIntent(intent, blacklist), UPI_TRANSACTION_RESULT_CODE)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        Log.e(javaClass.simpleName,"onActivityResult-->")

        if(resultCode == RESULT_OK){

            if(requestCode==UPI_TRANSACTION_RESULT_CODE){

                Log.e(javaClass.simpleName,"response-->"+data.getStringExtra("response"))
                methodChannel.success(data)


            }



        }else{
            methodChannel.success("Payment failed ")
            Toast.makeText(applicationContext,"Payment failed ",Toast.LENGTH_LONG).show()
        }






    }



}
