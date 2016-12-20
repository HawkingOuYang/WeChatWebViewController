//
//  LuckDrawShare.js
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/12/1.
//  Copyright © 2015年 [OYXJlucky@163.com] . All rights reserved.
//


/**
 这里的脚本，将注入webView，具体解释看：
 http://hawkingouyang.com/2016/08/10/6_ObjC-JS-and-Native-WebView/
 */


function shareContentToObjC() {
    var shareContentDic = sendMessageToObjC()
    window.webkit.messageHandlers.showShareWindow.postMessage(shareContentDic);
}

var shareBtn = document.getElementById("share")
shareBtn.addEventListener("click", function(){shareContentToObjC()}, false)


// 以下代码已由web端实现

// 创建了一个connectWebViewJavascriptBridge方法，该方法名是固定的, (iOS7 UIWebView)
//function connectWebViewJavascriptBridge(callback) {
//    if (window.WebViewJavascriptBridge) {
//        callback(WebViewJavascriptBridge)
//    } else {
//        document.addEventListener('WebViewJavascriptBridgeReady', function() {
//                                  callback(WebViewJavascriptBridge)
//                                  }, false)
//    }
//}
//
//connectWebViewJavascriptBridge(function(bridge) {
//
//    bridge.init(function(message, responseCallback) {
//
//    })
//
//    var shareBtn = document.getElementById("share")
//    shareBtn.addEventListener("click", function(){bridge.callHandler('showShareWindow', sendMessageToObjC())}, false)
//
//})

