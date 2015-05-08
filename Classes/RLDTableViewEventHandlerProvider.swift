import UIKit

class RLDTableViewEventHandlerProvider {
    private static var availableEventHanlderClasses:[RLDTableViewEventHandler.Type] = []
    
    class func register(eventHandlerClass:RLDTableViewEventHandler.Type) {
        availableEventHanlderClasses.append(eventHandlerClass)
    }
    
    class func eventHandler(#tableView:UITableView, viewModel:RLDTableViewReusableViewModel, view:UIView) -> RLDTableViewEventHandler? {
        for eventHandler in availableEventHanlderClasses {
            if eventHandler.canHandle(tableView:tableView, viewModel:viewModel, view:view) {
                return eventHandler(tableView:tableView, viewModel:viewModel, view:view)
            }
        }
        return nil
    }
}