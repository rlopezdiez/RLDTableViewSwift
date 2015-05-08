import RLDTableViewSwift
import UIKit

class RLDTableViewModelProvider {
    
    static private let DataPlistFileName = "viewModelData"
    static private let DictionaryTitleKey = "title"
    static private let DictionaryCellsKey = "cells"
    static private let DictionaryClassKey = "class"
    static private let TableViewCellTitleForDeleteConfirmationButton = "Delete"
    static private let TableViewHeaderViewReuseIdentifier = "RLDTableViewHeaderView"
    
    var headerFooterReuseIdentifiersToNibNames = [RLDTableViewModelProvider.TableViewHeaderViewReuseIdentifier:RLDTableViewModelProvider.TableViewHeaderViewReuseIdentifier]
    lazy var tableViewModel:RLDTableViewModel = {
        let modelArray = self.modelArray()
        let tableViewModel = RLDTableViewModel()
        for sectionDictionary in modelArray {
            self.tableViewModel(tableViewModel, addSectionWithSectionDictionary:sectionDictionary)
        }
        return tableViewModel
        }()
    
    
    private func modelArray() -> [[String:AnyObject]] {
        return NSArray(contentsOfFile:NSBundle.mainBundle().pathForResource(RLDTableViewModelProvider.DataPlistFileName, ofType:"plist")!)! as! [[String:AnyObject]]
    }
    
    private func tableViewModel(tableViewModel:RLDTableViewModel, addSectionWithSectionDictionary sectionDictionary:[String:AnyObject]) {
        let sectionModel = tableViewModel.addNewSectionModel()
        
        if let headerTitle = sectionDictionary[RLDTableViewModelProvider.DictionaryTitleKey] as? String {
            let headerModel = RLDTableViewHeaderViewModel()
            headerModel.title = headerTitle
            sectionModel.header = headerModel
        }
        
        for cellDictionary in sectionDictionary[RLDTableViewModelProvider.DictionaryCellsKey] as! [[String:AnyObject]] {
            self.tableViewModel(tableViewModel, addCellWithCellDictionary:cellDictionary)
        }
    }
    
    private func tableViewModel(tableViewModel:RLDTableViewModel, addCellWithCellDictionary cellDictionary:[String:AnyObject]) {
        let cellModel = RLDGenericTableViewCellModel.cellModelForClass(cellDictionary[RLDTableViewModelProvider.DictionaryClassKey] as! String)
        
        for (key, value) in cellDictionary {
            cellModel.setValue(value, forKey:key)
        }
        
        cellModel.titleForDeleteConfirmationButton = RLDTableViewModelProvider.TableViewCellTitleForDeleteConfirmationButton
        
        tableViewModel.add(cellModel:cellModel)
    }
    
}

extension RLDGenericTableViewCellModel {
    
    class func cellModelForClass(cellModelClass:String) -> RLDGenericTableViewCellModel {
        switch cellModelClass {
        case "RLDBigPictureTableViewCellModel":
            return RLDBigPictureTableViewCellModel()
        case "RLDCommentTableViewCellModel":
            return RLDCommentTableViewCellModel()
        case "RLDSimpleTableViewCellModel":
            return RLDSimpleTableViewCellModel()
        default:
            fatalError("Unable to find class for \(cellModelClass)")
        }
    }
    
    func setValue(value:AnyObject, forKey key:String) {
        switch key {
        case "category":
            category = value as! String
        case "categoryURL":
            categoryURL = value as! String
        case "comment":
            (self as! RLDCommentTableViewCellModel).comment = value as! String
        case "date":
            date = value as! String
        case "editable":
            editable = (value as! Bool)
        case "editingStyle":
            editingStyle = (value as! Int == 1
                ? UITableViewCellEditingStyle.Delete
                : UITableViewCellEditingStyle.None)
        case "imageName":
            imageName = value as! String
        case "imageURL":
            imageURL = value as! String
        case "movable":
            movable = (value as! Bool)
        case "title":
            title = value as! String
        case "class":
            break
        default:
            fatalError("Unable to set the value for \(key)")
        }
    }
}