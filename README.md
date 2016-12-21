# WeChatWebViewController

仿造 微信webView效果，包括：

an iOS native ViewController like WeChat webview Controller, which includes:


1进度条，

1 progress bar

2左滑返回上个网页或者直接关闭(像UINavigationController)，

2 back button to go back in webview OR pop back in navigation stack

3适配iOS8.0的UIWebView(特别处理UIWebView内存泄漏)和WKWebView，

3 adapt to iOS 8.0 for UIWebView(especially for memory leaks of UIWebView) and WKWebView

4支持JS和OC交互HybridApp，

4 send messages between JS and OC, that's part of Hybrid App.

5支持WebViewProxy

5 support WebViewProxy


支持JS和OC交互，说明：http://hawkingouyang.com/2016/08/10/6_ObjC-JS-and-Native-WebView/


Here is a demo gif:

![wechatwebviewcontroller_demo_gif](https://cloud.githubusercontent.com/assets/12937445/21358060/7a194c90-c712-11e6-8840-6f834538cf18.gif)
