import UIKit
import RLDTableViewSwift

// MARK: UIView extension to find the first responder

private extension UIView {
    private weak static var _firstResponder:UIView?
    
    class func rld_firstResponder() -> UIView? {
        UIApplication.sharedApplication().sendAction(Selector("setFirstResponder"), to:nil, from:nil, forEvent:nil)
        return _firstResponder
    }
    
    func setFirstResponder() {
        UIView._firstResponder = self
    }
}

// MARK: UITableView extension to scroll to the first responder cell

private extension UITableView {
    func scrollToFirstResponder(animated:Bool) {
        if let firstResponder = UIView.rld_firstResponder() {
            let firstResponderFrame = firstResponder.convertRect(firstResponder.bounds, toView:self)
            self.scrollRectToVisible(firstResponderFrame, animated:animated)
        }
    }
}

// MARK: UITableView extension to know wether multiple selection is enabled

private extension UITableView {
    var multipleSelectionModeEnabled: Bool {
        return (self.editing
            ? self.allowsMultipleSelectionDuringEditing
            : self.allowsMultipleSelection)
    }
}

// MARK: RLDTableViewController class

public class RLDTableViewController:UIViewController {
    
    // MARK: Initialization
    required public init(style: UITableViewStyle) {
        super.init(nibName:nil, bundle:nil)
        tableView = UITableView(frame:CGRectZero, style:style)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    // MARK: Data source and delegate configuration
    private var tableViewDataSource:RLDTableViewDataSource?
    private var tableViewDelegate:RLDTableViewDelegate?
    
    public var tableViewModel:RLDTableViewModel? {
        didSet {
            if let tableViewModel = tableViewModel {
                tableViewDataSource = RLDTableViewDataSource(tableViewModel:tableViewModel)
                tableViewDelegate = RLDTableViewDelegate(tableViewModel:tableViewModel)
                
                tableView?.dataSource = tableViewDataSource
                tableView?.delegate = tableViewDelegate
                tableView?.reloadData()
            }
        }
    }
    
    // MARK: View management
    lazy public var tableView: UITableView? = {
        return UITableView(frame:CGRectZero)
        }()
    
    override public var view: UIView! {
        get {
            return super.view
        }
        set {
            if let tableView = newValue as? UITableView {
                self.tableView = tableView
                super.view = tableView
            } else {
                fatalError("The view must be an UITableView")
            }
        }
    }
    
    var clearsSelectionOnViewWillAppear: Bool = true
    var refreshControl: UIRefreshControl? {
        didSet {
            if let refreshControl = refreshControl {
                self.tableView!.insertSubview(refreshControl, atIndex:0)
            }
        }
    }
    
    override public func viewWillAppear(animated:Bool) {
        startObservingKeyboardNotifications()
        
        if clearsSelectionOnViewWillAppear {
            clearTableViewSelection(animated)
        }
        
        super.viewWillAppear(animated)
    }
    
    override public func viewWillDisappear(animated:Bool) {
        super.viewWillDisappear(animated)
        
        stopObservingKeyboardNotifications()
    }
    
    override public func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        
        tableView!.flashScrollIndicators()
    }
    
    override public func setEditing(editing:Bool, animated:Bool) {
        super.setEditing(editing, animated:animated)
        
        tableView!.setEditing(editing, animated:animated)
    }
    
    // MARK: Keyboard notifications handling
    private func startObservingKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShowWithKeyboardChangeNotification:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHideWithKeyboardChangeNotification:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    private func stopObservingKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShowWithKeyboardChangeNotification(notification:NSNotification) {
        synchronizeAnimationWithKeyboardChangeNotification(notification,
            animations: { () -> Void in
                self.tableView!.frame = CGRect(x:self.tableView!.frame.origin.x,
                    y:self.tableView!.frame.origin.y,
                    width:self.tableView!.frame.size.width,
                    height:self.tableView!.superview!.bounds.size.height - self.keyboardHeightWithKeyboardNotification(notification))
                
                self.tableView?.scrollToFirstResponder(false)
        })
    }
    
    func keyboardWillHideWithKeyboardChangeNotification(notification:NSNotification) {
        synchronizeAnimationWithKeyboardChangeNotification(notification,
            animations: { () -> Void in
                self.tableView!.frame = self.tableView!.superview!.bounds
        })
    }
    
    private func synchronizeAnimationWithKeyboardChangeNotification(notification:NSNotification, animations:(()->Void)?) {
        if let animations = animations,
            let userInfo = notification.userInfo as? [String:AnyObject] {
                
                let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
                
                if (animationDuration == 0) {
                    animations()
                } else {
                    let animationCurve = UIViewAnimationCurve(rawValue:(userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue)!
                    
                    UIView.beginAnimations(nil, context:nil)
                    UIView.setAnimationDuration(animationDuration)
                    UIView.setAnimationCurve(animationCurve)
                    UIView.setAnimationBeginsFromCurrentState(true)
                    animations()
                    
                    UIView.commitAnimations()
                }
        }
    }
    
    private func keyboardHeightWithKeyboardNotification(notification:NSNotification) -> CGFloat {
        let keyboardBounds = keyboardBoundsWithKeyboardNotification(notification)
        return keyboardBounds.size.height
    }
    
    private func keyboardBoundsWithKeyboardNotification(notification:NSNotification) -> CGRect {
        if let userInfo = notification.userInfo as? [String:NSValue],
            let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] {
                return keyboardFrameValue.CGRectValue()
        }
        return CGRectZero
    }
    
    // MARK: Selection clearing
    private func clearTableViewSelection(animated:Bool) {
        if !tableView!.multipleSelectionModeEnabled {
            if let indexPathForSelectedRow = tableView?.indexPathForSelectedRow() {
                synchronizeDeselectionAnimationOfRow(indexPathForSelectedRow, animated:animated)
            }
        }
    }
    
    private func synchronizeDeselectionAnimationOfRow(indexPathForSelectedRow:NSIndexPath, animated:Bool) {
        if let transitionCoordinator = transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransitionInView(tableView,
                animation: { (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                    self.tableView!.deselectRowAtIndexPath(indexPathForSelectedRow, animated:animated)
                }, completion: { (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                    if context.isCancelled() {
                        self.tableView!.selectRowAtIndexPath(indexPathForSelectedRow, animated:false, scrollPosition:UITableViewScrollPosition.None)
                    }
            })
        }
    }
}