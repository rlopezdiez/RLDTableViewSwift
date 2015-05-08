import UIKit

class RLDMasterViewController: RLDTableViewController {
    
    let modelProvider = RLDTableViewModelProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
        registerEventHandlers()
        setTableViewModel()
        attachEditButton()
    }
    
    private func registerNibs() {
        for (reuseIdentifier, nibName) in modelProvider.headerFooterReuseIdentifiersToNibNames {
            let nib = UINib(nibName:reuseIdentifier, bundle:nil)
            tableView?.registerNib(nib, forHeaderFooterViewReuseIdentifier:nibName)
        }
    }
    
    private func registerEventHandlers() {
        RLDGenericTableViewCellEventHandler.register()
        RLDTableViewHeaderViewEventHandler.register()
    }
    
    private func setTableViewModel() {
        tableViewModel = modelProvider.tableViewModel
    }
    
    private func attachEditButton() {
        navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func setEditing(editing:Bool, animated:Bool) {
        super.setEditing(editing, animated:animated)
        
        navigationController?.hidesBarsOnSwipe = !editing
        navigationController?.hidesBarsWhenVerticallyCompact = !editing
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}