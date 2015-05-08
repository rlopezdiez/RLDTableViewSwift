import UIKit
import RLDTableViewSwift

class RLDGenericTableViewCellEventHandler:RLDTableViewCellEventHandler {
    // MARK: Suitability checking
    override class func canHandle(#tableView:UITableView, viewModel:RLDTableViewReusableViewModel, view:UIView) -> Bool {
        if let viewModel = viewModel as? RLDGenericTableViewCellModel,
            let view = view as? RLDGenericTableViewCell {
                return true
        }
        
        return false
    }
    
    // MARK: Cell customization
    override func willDisplayView() {
        if let view = view as? RLDGenericTableViewCell {
            view.model = (viewModel as! RLDGenericTableViewCellModel)
        }
    }
    
    // MARK: View highlighting
    override func shouldHighlightView() -> Bool {
        return true
    }
    
    override func didHighlightView() {
        if let view = view as? RLDGenericTableViewCell {
            view.viewToHighlight.backgroundColor = UIColor(red:0.8, green:0.92, blue:1, alpha:1)
        }
        view.alpha = 0.75
    }
    
    override func didUnhighlightView() {
        if let view = view as? RLDGenericTableViewCell {
            view.viewToHighlight.backgroundColor = UIColor.whiteColor()
        }
        view.alpha = 1
    }
    
    // MARK: Cell interactions
    override func didSelectView() {
        if let viewModel = viewModel as? RLDGenericTableViewCellModel {
            open(viewModel.imageURL, title: viewModel.title)
        }
    }
    
    func didTapCategoryButton() {
        if let viewModel = viewModel as? RLDGenericTableViewCellModel {
            open(viewModel.categoryURL, title: viewModel.category)
        }
    }
    
    private func open(url:String, title:String) {
        /*
        This way of navigating to another view controller is good enough for a sample app,
        but in a real life situation you should consider moving navigation code elsewhere.
        You can use flow controllers, routers or some kind of view model propagation.
        You might want to use my navigation library, which is a good complement to this one:
        https://github.com/rlopezdiez/RLDNavigationSwift
        */
        if let navigationController = navigationController() {
            let storyboard = UIStoryboard(name:"Main", bundle:nil)
            let detailViewController = storyboard.instantiateViewControllerWithIdentifier("RLDWebViewController") as! RLDWebViewController
            detailViewController.title = title
            detailViewController.url = url
            navigationController.pushViewController(detailViewController, animated:true)
        }
    }
    
    private func navigationController() -> UINavigationController? {
        for var nextView:UIView? = view.superview; nextView != nil; nextView = nextView!.superview {
            if let nextResponder = nextView?.nextResponder() as? UINavigationController {
                return nextResponder
            }
        }
        return nil
    }
}