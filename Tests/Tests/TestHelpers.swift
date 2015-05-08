import UIKit

// MARK: UITableViewCell subclass
class RLDTestTableViewCell:UITableViewCell {
}

// MARK: UITableViewHeaderFooterView subclass
class RLDTestAccessoryView : UITableViewHeaderFooterView {
}

// MARK: RLDTableViewCellModel subclasses
class RLDFirstTestCellModel:RLDTableViewCellModel {
}

class RLDSecondTestCellModel:RLDTableViewCellModel {
}

// MARK: Event handler for testing
class RLDTestEventHandler:RLDTableViewCellEventHandler {
    typealias canHandleClosureType = (tableView:UITableView, viewModel:RLDTableViewReusableViewModel, view:UIView) -> Bool
    private static var canHandleClosure:canHandleClosureType = { canHandleClosureType in return true }
    private static var callRegister:[String:String] = [:]

    class func setCanHandleClosure(newCanHandleClosure:canHandleClosureType) {
        canHandleClosure = newCanHandleClosure
    }

    class func reset() {
        canHandleClosure = { canHandleClosureType in return true }
    }

    // MARK: Suitability checking
    override class func canHandle(#tableView:UITableView, viewModel:RLDTableViewReusableViewModel, view:UIView) -> Bool {
        return canHandleClosure(tableView:tableView, viewModel:viewModel, view:view)
    }

    // MARK: Call registering
    override func willReuseView() { registerCall("willReuseView") }
    override func willDisplayView() { registerCall("willDisplayView") }
    override func didEndDisplayingView() { registerCall("didEndDisplayingView") }
    override func accessoryButtonTapped() { registerCall("accessoryButtonTapped") }
    override func shouldHighlightView() -> Bool {  registerCall("shouldHighlightView"); return false }
    override func didHighlightView() { registerCall("didHighlightView") }
    override func didUnhighlightView() { registerCall("didUnhighlightView") }
    override func willSelectView() -> NSIndexPath? {  registerCall("willSelectView"); return nil }
    override func willDeselectView() -> NSIndexPath? {  registerCall("willDeselectView"); return nil }
    override func didSelectView() { registerCall("didSelectView") }
    override func didDeselectView() { registerCall("didDeselectView") }
    override func willBeginEditing() { registerCall("willBeginEditing") }
    override func didEndEditing() { registerCall("didEndEditing") }
    override func editActions() -> [UITableViewRowAction]? {  registerCall("editActions"); return nil }
    override func canPerform(#action:Selector, withSender sender:AnyObject) -> Bool {  registerCall("canPerformAction:withSender:"); return false }
    override func performAction(#action:Selector, withSender sender:AnyObject) { registerCall("performAction:withSender:") }
    
    func registerCall(selector:String) {
        self.dynamicType.callRegister[NSStringFromClass(self.dynamicType)] = selector
    }
    
    class func isCallRegistered(selector:String) -> Bool {
        if let isCallRegistered = callRegister[selector] {
            return true
        } else {
            return false
        }
    }
}