import UIKit
import RLDTableViewSwift

class RLDTableViewHeaderView:UITableViewHeaderFooterView, RLDHandledViewProtocol {
    @IBOutlet weak var text:UILabel!
    
    var eventHandler:RLDTableViewEventHandler? = nil
    
    var model:RLDTableViewHeaderViewModel? {
        didSet {
            text.text = model!.title
        }
    }
}