import RLDTableViewSwift

class RLDTableViewHeaderViewModel:RLDTableViewSectionAccessoryViewModel {
    required init() {
        super.init()
        reuseIdentifier = "RLDTableViewHeaderView"
        height = 60
        estimatedHeight = height
    }
}