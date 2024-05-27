import ExpoModulesCore
import WebKit

let webView = WKWebView()

extension UIView {
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    
    return renderer.image { (context) in
      layer.render(in: context.cgContext)
    }
  }
}

class ScreenshotableView: UIView {
  let backgroundImageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundImageView.contentMode = .top
    self.insertSubview(backgroundImageView, at: 0)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func layoutSubviews() {
    backgroundImageView.frame = bounds
  }
  
  func screenshot() {
    guard !self.subviews.isEmpty else {
      return
    }
    let child = self.subviews[1]
    let image = child.asImage()
    backgroundImageView.image = image
    
  }
}

class NavigationDelegateSingleton: UIViewController, WKNavigationDelegate  {
  @IBOutlet weak var webView: WKWebView!
  
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == #keyPath(WKWebView.url) {
      print("### URL:", self.webView.url!)
      let currentSharedWebviewView = webView.superview?.superview as? SharedWebviewView
      if let url = self.webView.url?.absoluteString {
        currentSharedWebviewView?.navigationAction(url)
      }
      
    }
    
    if keyPath == #keyPath(WKWebView.estimatedProgress) {
      if (self.webView.estimatedProgress == 1) {
        print("### EP:", self.webView.estimatedProgress)
        let currentSharedWebviewView = webView.superview?.superview as? SharedWebviewView
        if let scrollOffset = currentSharedWebviewView?.scrollOffset {
          webView.scrollView.contentOffset = scrollOffset
        }
        let seconds = 0.05
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
          self.webView.isHidden = false
        }
      }
    }
  }
  
}
let navigationDelegateSingleton = NavigationDelegateSingleton()

class SharedWebviewView: ExpoView {
  
  let onNavigation = EventDispatcher()
  
  let container = ScreenshotableView()
  var url: URL?
  var scrollOffset: CGPoint?
  var hasFocus: Bool = false
  
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    clipsToBounds = true
    addSubview(container)
    if(webView.navigationDelegate == nil) {
      webView.navigationDelegate = navigationDelegateSingleton
      navigationDelegateSingleton.webView = webView
      webView.addObserver(navigationDelegateSingleton, forKeyPath: "URL", options: .new, context: nil)
      webView.addObserver(navigationDelegateSingleton, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
  }
  
  func navigationAction(_ url: String) {
    onNavigation(["url": url])
  }
  
  override func layoutSubviews() {
    webView.frame = bounds
    container.frame = bounds
  }
  
  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    
    if newSuperview == nil {
      setFocused(focused: false)
    }
  }
  
  func setFocused(focused: Bool) {
    if(focused) {
      
      if(webView.superview != container){
        if(webView.superview != nil) {
          
          if let screenshotableView = webView.superview as? ScreenshotableView {
            screenshotableView.screenshot()
          }
          let currentSharedWebviewView = webView.superview?.superview as? SharedWebviewView
          currentSharedWebviewView?.scrollOffset = webView.scrollView.contentOffset
        }
        webView.removeFromSuperview()
        if(url != nil && !areURLsEqual(webView.url,url)){
          
          if(container.backgroundImageView.image != nil) {
            webView.isHidden = true
          }
          
          loadUrl(url!)
        }
        container.addSubview(webView)
      }else {
        if(url != nil && !areURLsEqual(webView.url,url)){
          loadUrl(url!)
        }
      }
    }
  }
  
  func loadUrl(_ url: URL) {
    //    if(!areURLsEqual(webView.url,url)) {
    let urlRequest = URLRequest(url:url)
    print("loading URL", url)
    webView.load(urlRequest)
    //    }
  }
  
  func setUrl(url: String) {
    let url = URL(string:url)!
    self.url = url
    if(hasFocus) {
      loadUrl(url)
    }
  }
}

func areURLsEqual(_ url1: URL?, _ url2: URL?) -> Bool {
  guard let url1 = url1, let url2 = url2 else {
    return false // At least one of the URLs is nil
  }
  let standardUrl1 = url1.absoluteString.hasSuffix("/") ? url1.absoluteString : url1.absoluteString + "/"
  let standardUrl2 = url2.absoluteString.hasSuffix("/") ? url2.absoluteString : url2.absoluteString + "/"
  return standardUrl1 == standardUrl2
}
