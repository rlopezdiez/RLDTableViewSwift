import UIKit
import RLDTableViewSwift

class RLDTableViewHeaderViewEventHandler:RLDTableViewSectionAccessoryViewEventHandler {
    // MARK: Suitability checking
    override class func canHandle(tableView:UITableView, viewModel:RLDTableViewReusableViewModel, view:UIView) -> Bool {
        if let viewModel = viewModel as? RLDTableViewHeaderViewModel,
            let view = view as? RLDTableViewHeaderView {
                return true
        }
        
        return false
    }
    
    // MARK: View customization
    override func willDisplayView() {
        if let view = view as? RLDTableViewHeaderView {
            view.model = (viewModel as! RLDTableViewHeaderViewModel)
        }
    }
}