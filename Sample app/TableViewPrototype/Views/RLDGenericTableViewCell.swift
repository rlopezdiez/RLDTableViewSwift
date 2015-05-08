import UIKit
import RLDTableViewSwift

class RLDGenericTableViewCell:UITableViewCell, RLDHandledViewProtocol {
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var date:UILabel?
    @IBOutlet weak var category:UIButton?
    @IBOutlet weak var picture:UIImageView!
    @IBOutlet weak var viewToHighlight:UIView!
    
    var eventHandler:RLDTableViewEventHandler? = nil
    
    var model:RLDGenericTableViewCellModel? {
        didSet {
            if let model = model {
                title.text = model.title
                picture.image = UIImage(named:model.imageName)
                if let date = date {
                    date.text = model.date
                }
                if let category = category {
                    category.setTitle(model.category, forState:UIControlState.Normal)
                }
            }
        }
    }
    
    @IBAction func categoryButtonTapped() {
        if let eventHandler = eventHandler as? RLDGenericTableViewCellEventHandler {
            eventHandler.didTapCategoryButton()
        }
    }
}