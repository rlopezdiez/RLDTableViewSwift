import UIKit

class RLDWebViewController: UIViewController {
    var url:String = "" {
        didSet {
            if let view = view as? UIWebView {
                let urlRequest = NSURLRequest(URL:NSURL(string:url)!)
                view.loadRequest(urlRequest)
            }
        }
    }
}