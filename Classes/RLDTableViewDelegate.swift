import UIKit

public class RLDTableViewDelegate:NSObject, UITableViewDelegate {
    // Initialization
    private var tableViewModel:RLDTableViewModel
    required public init(tableViewModel:RLDTableViewModel) {
        self.tableViewModel = tableViewModel
    }
    
    // MARK: Display customization
    public func tableView(tableView:UITableView, willDisplayCell cell:UITableViewCell, forRowAtIndexPath indexPath:NSIndexPath) {
        link(eventHandler:eventHandler(tableView:tableView, indexPath:indexPath, cell:cell),
            view:cell,
            andExecute:{ (eventHandler) -> Void in
                eventHandler.willDisplayView()
        })
    }
    
    public func tableView(tableView:UITableView, willDisplayHeaderView view:UIView, forSection section:Int) {
        self.tableView(tableView, willDisplayHeaderFooterView:view, model:tableViewModel.sectionModels[section].header)
    }
    
    public func tableView(tableView:UITableView, willDisplayFooterView view:UIView, forSection section:Int) {
        self.tableView(tableView, willDisplayHeaderFooterView:view, model:tableViewModel.sectionModels[section].footer)
    }
    
    private func tableView(tableView:UITableView, willDisplayHeaderFooterView view:UIView, model:RLDTableViewSectionAccessoryViewModel?) {
        if let model = model {
            link(eventHandler:eventHandler(tableView:tableView, viewModel:model, view:view),
                view:view,
                andExecute:{ (eventHandler) -> Void in
                    eventHandler.willDisplayView()
            })
        }
    }
    
    private func link(#eventHandler:RLDTableViewEventHandler, view:UIView, andExecute closure:(eventHandler:RLDTableViewEventHandler)->Void) {
        if let view = view as? RLDHandledViewProtocol {
            view.eventHandler = eventHandler
        }
        closure(eventHandler:eventHandler)
    }
    
    public func tableView(tableView:UITableView, didEndDisplayingCell cell:UITableViewCell, forRowAtIndexPath indexPath:NSIndexPath) {
        eventHandler(tableView:tableView, indexPath:indexPath, cell:cell).didEndDisplayingView()
    }
    
    public func tableView(tableView:UITableView, didEndDisplayingHeaderView view:UIView, forSection section:Int) {
        if let headerViewModel = tableViewModel.sectionModels[section].header {
            eventHandler(tableView:tableView, viewModel:headerViewModel, view:view).didEndDisplayingView()
        }
    }
    
    public func tableView(tableView:UITableView, didEndDisplayingFooterView view:UIView, forSection section:Int) {
        if let footerViewModel = tableViewModel.sectionModels[section].footer {
            eventHandler(tableView:tableView, viewModel:footerViewModel, view:view).didEndDisplayingView()
        }
    }
    
    // MARK: Variable height support
    public func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        if let height = cellModel(indexPath:indexPath).height {
            return height
        }
        return UITableViewAutomaticDimension
    }
    
    public func tableView(tableView:UITableView, heightForHeaderInSection section:Int) -> CGFloat {
        if let height = tableViewModel.sectionModels[section].header?.height {
            return height
        }
        return UITableViewAutomaticDimension
    }
    
    public func tableView(tableView:UITableView, heightForFooterInSection section:Int) -> CGFloat {
        if let height = tableViewModel.sectionModels[section].footer?.height {
            return height
        }
        return UITableViewAutomaticDimension
    }
    
    public func tableView(tableView:UITableView, estimatedHeightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        if let estimatedHeight = cellModel(indexPath:indexPath).estimatedHeight {
            return estimatedHeight
        }
        return UITableViewAutomaticDimension
    }
    
    public func tableView(tableView:UITableView, estimatedHeightForHeaderInSection section:Int) -> CGFloat {
        if let estimatedHeight = tableViewModel.sectionModels[section].header?.estimatedHeight {
            return estimatedHeight
        }
        return UITableViewAutomaticDimension
    }
    
    public func tableView(tableView:UITableView, estimatedHeightForFooterInSection section:Int) -> CGFloat {
        if let estimatedHeight = tableViewModel.sectionModels[section].footer?.estimatedHeight {
            return estimatedHeight
        }
        return UITableViewAutomaticDimension
    }
    
    // MARK: Section header and footer
    public func tableView(tableView:UITableView, viewForHeaderInSection section:Int) -> UIView? {
        if let reuseIdentifier = tableViewModel.sectionModels[section].header?.reuseIdentifier {
            return tableView.dequeueReusableHeaderFooterViewWithIdentifier(reuseIdentifier) as? UIView
        }
        return nil
    }
    
    public func tableView(tableView:UITableView, viewForFooterInSection section:Int) -> UIView? {
        if let reuseIdentifier = tableViewModel.sectionModels[section].footer?.reuseIdentifier {
            return tableView.dequeueReusableHeaderFooterViewWithIdentifier(reuseIdentifier) as? UIView
        }
        return nil
    }
    
    // MARK: Accessories (disclosures)
    public func tableView(tableView:UITableView, accessoryButtonTappedForRowWithIndexPath indexPath:NSIndexPath) {
        eventHandler(tableView:tableView, indexPath:indexPath).accessoryButtonTapped()
    }
    
    // MARK: Selection
    public func tableView(tableView:UITableView, shouldHighlightRowAtIndexPath indexPath:NSIndexPath) -> Bool {
        return eventHandler(tableView:tableView, indexPath:indexPath).shouldHighlightView()
    }
    
    public func tableView(tableView:UITableView, didHighlightRowAtIndexPath indexPath:NSIndexPath) {
        eventHandler(tableView:tableView, indexPath:indexPath).didHighlightView()
    }
    
    public func tableView(tableView:UITableView, didUnhighlightRowAtIndexPath indexPath:NSIndexPath) {
        eventHandler(tableView:tableView, indexPath:indexPath).didUnhighlightView()
    }
    
    public func tableView(tableView:UITableView, willSelectRowAtIndexPath indexPath:NSIndexPath) -> NSIndexPath? {
        let selectedIndexPath = eventHandler(tableView:tableView, indexPath:indexPath).willSelectView()
        return (selectedIndexPath != nil ? selectedIndexPath : indexPath)
    }
    
    public func tableView(tableView:UITableView, willDeselectRowAtIndexPath indexPath:NSIndexPath) -> NSIndexPath? {
        let deselectedIndexPath = eventHandler(tableView:tableView, indexPath:indexPath).willDeselectView()
        return (deselectedIndexPath != nil ? deselectedIndexPath : indexPath)
    }
    
    public func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        eventHandler(tableView:tableView, indexPath:indexPath).didSelectView()
    }
    
    public func tableView(tableView:UITableView, didDeselectRowAtIndexPath indexPath:NSIndexPath) {
        eventHandler(tableView:tableView, indexPath:indexPath).didDeselectView()
    }
    
    // MARK: Editing
    public func tableView(tableView:UITableView, editingStyleForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCellEditingStyle {
        if let editingStyle = cellModel(indexPath:indexPath).editingStyle {
            return editingStyle
        }
        return UITableViewCellEditingStyle.None
    }
    
    public func tableView(tableView:UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath:NSIndexPath) -> String! {
        if let titleForDeleteConfirmationButton = cellModel(indexPath:indexPath).titleForDeleteConfirmationButton {
            return titleForDeleteConfirmationButton
        }
        return ""
    }
    
    public func tableView(tableView:UITableView, editActionsForRowAtIndexPath indexPath:NSIndexPath) -> [AnyObject]? {
        return eventHandler(tableView:tableView, indexPath:indexPath).editActions()
    }
    
    public func tableView(tableView:UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath:NSIndexPath) -> Bool {
        if let shouldIndentWhileEditing = cellModel(indexPath:indexPath).shouldIndentWhileEditing {
            return shouldIndentWhileEditing
        }
        return false
    }
    
    public func tableView(tableView:UITableView, willBeginEditingRowAtIndexPath indexPath:NSIndexPath) {
        eventHandler(tableView:tableView, indexPath:indexPath).willBeginEditing()
    }
    
    public func tableView(tableView:UITableView, didEndEditingRowAtIndexPath indexPath:NSIndexPath) {
        eventHandler(tableView:tableView, indexPath:indexPath).didEndEditing()
    }
    
    // MARK: Moving and reordering
    public func tableView(tableView:UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath:NSIndexPath, toProposedIndexPath proposedDestinationIndexPath:NSIndexPath) -> NSIndexPath {
        return proposedDestinationIndexPath
    }
    
    // MARK: Indentation
    public func tableView(tableView:UITableView, indentationLevelForRowAtIndexPath indexPath:NSIndexPath) -> Int {
        if let indentationLevel = cellModel(indexPath:indexPath).indentationLevel {
            return indentationLevel
        }
        return 0
    }
    
    // MARK: Copy and Paste
    public func tableView(tableView:UITableView, shouldShowMenuForRowAtIndexPath indexPath:NSIndexPath) -> Bool {
        if let shouldShowMenu = cellModel(indexPath:indexPath).shouldShowMenu {
            return shouldShowMenu
        }
        return false
    }
    
    public func tableView(tableView:UITableView, canPerformAction action:Selector, forRowAtIndexPath indexPath:NSIndexPath, withSender sender:AnyObject) -> Bool {
        return eventHandler(tableView:tableView, indexPath:indexPath).canPerform(action:action, withSender:sender)
    }
    
    public func tableView(tableView:UITableView, performAction action:Selector, forRowAtIndexPath indexPath:NSIndexPath, withSender sender:AnyObject!) {
        return eventHandler(tableView:tableView, indexPath:indexPath).performAction(action:action, withSender:sender)
    }
    
    // MARK: Event handler generation
    private func eventHandler(#tableView:UITableView, indexPath:NSIndexPath) -> RLDTableViewCellEventHandler {
        let cellModel = self.cellModel(indexPath:indexPath)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated:false)
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        return eventHandler(tableView:tableView, indexPath:indexPath, cell:cell)
    }
    
    private func eventHandler(#tableView:UITableView, indexPath:NSIndexPath, cell:UITableViewCell) -> RLDTableViewCellEventHandler {
        let cellModel = self.cellModel(indexPath:indexPath)
        return eventHandler(tableView:tableView, viewModel:cellModel, view:cell) as! RLDTableViewCellEventHandler
    }
    
    private func eventHandler(#tableView:UITableView, viewModel:RLDTableViewReusableViewModel, view:UIView) -> RLDTableViewEventHandler {
        if let eventHandler = reusableEventHandler(tableView:tableView, viewModel:viewModel, view:view) {
            eventHandler.tableView = tableView
            eventHandler.viewModel = viewModel
            eventHandler.view = view
            return eventHandler
        } else {
            let eventHandler = RLDTableViewEventHandlerProvider.eventHandler(tableView:tableView, viewModel:viewModel, view:view)
            assert(eventHandler != nil, "Unable to find suitable event hander for \ntableView: \(tableView)\nviewModel: \(viewModel)\nview: \(view)")
            return eventHandler!
        }
    }
    
    private func reusableEventHandler(#tableView:UITableView, viewModel:RLDTableViewReusableViewModel, view:UIView) -> RLDTableViewEventHandler? {
        if let handledView = view as? RLDHandledViewProtocol, let eventHandler = handledView.eventHandler {
            let eventHandlerClass = eventHandler.dynamicType
            if eventHandlerClass.canHandle(tableView:tableView, viewModel:viewModel, view:view) {
                return eventHandler
            }
        }
        return nil
    }
    
    // MARK: Model accessors
    private func cellModel(#indexPath:NSIndexPath) -> RLDTableViewCellModel {
        let sectionModel = tableViewModel.sectionModels[indexPath.section]
        return sectionModel.cellModels[indexPath.row]
    }
}