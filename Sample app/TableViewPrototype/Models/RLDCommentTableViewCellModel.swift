class RLDCommentTableViewCellModel:RLDGenericTableViewCellModel {
    
    var comment:String = ""
    
    required init() {
        super.init()
        reuseIdentifier = "RLDCommentTableViewCell"
    }
}