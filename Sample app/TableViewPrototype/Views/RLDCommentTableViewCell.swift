import UIKit

class RLDCommentTableViewCell:RLDGenericTableViewCell {
    @IBOutlet weak var comment:UITextView!
    
    override var model:RLDGenericTableViewCellModel? {
        didSet {
            if let model = model as? RLDCommentTableViewCellModel {
                comment.text = model.comment
            }
        }
    }
}