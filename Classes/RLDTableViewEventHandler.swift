import UIKit

// MARK: RLDTableViewEventHandler class

public class RLDTableViewEventHandler {
    // MARK: Event handler registration
    public class func register() {
        RLDTableViewEventHandlerProvider.register(self)
    }
    
    // MARK: Suitability checking
    public class func canHandle(tableView:UITableView, viewModel:RLDTableViewReusableViewModel, view:UIView) -> Bool {
        return false
    }
    
    // MARK: Initialization and dependencies
    public var tableView:UITableView
    public var viewModel:RLDTableViewReusableViewModel
    public var view:UIView
    required public init(tableView:UITableView, viewModel:RLDTableViewReusableViewModel, view:UIView) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.view = view
    }
    
    // MARK: Display customization
    public func willReuseView() {}
    public func willDisplayView() {}
    public func didEndDisplayingView() {}
}

// MARK: RLDTableViewCellEventHandler class

public class RLDTableViewCellEventHandler:RLDTableViewEventHandler {
    
    // MARK: Accessories (disclosures)
    public func accessoryButtonTapped() {}
    
    // MARK: Selection
    public func shouldHighlightView() -> Bool { return false }
    public func didHighlightView() {}
    public func didUnhighlightView() {}
    public func willSelectView() -> NSIndexPath? { return nil }
    public func willDeselectView() -> NSIndexPath? { return nil }
    public func didSelectView() {}
    public func didDeselectView() {}
    
    // MARK: Editing
    public func willBeginEditing() {}
    public func didEndEditing() {}
    public func editActions() -> [UITableViewRowAction]? { return nil }
    
    // MARK: Copy and Paste
    public func canPerform(action:Selector, withSender sender:AnyObject) -> Bool { return false }
    public func performAction(action:Selector, withSender sender:AnyObject) {}
}

// MARK: RLDTableViewSectionAccessoryViewEventHandler class

public class RLDTableViewSectionAccessoryViewEventHandler:RLDTableViewEventHandler {
}