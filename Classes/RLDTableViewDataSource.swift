import UIKit

public class RLDTableViewDataSource:NSObject, UITableViewDataSource {
    
    // MARK: Initialization
    private(set) var tableViewModel:RLDTableViewModel?
    required public init(tableViewModel:RLDTableViewModel) {
        self.tableViewModel = tableViewModel
    }
    
    // MARK: Cell generation
    public func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cellModel = self.cellModel(indexPath:indexPath)
        return tableView.dequeueReusableCellWithIdentifier(cellModel.reuseIdentifier, forIndexPath:indexPath) as! UITableViewCell
    }
    
    // MARK: Sections
    public func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        return count(tableViewModel!.sectionModels)
    }
    
    public func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        let sectionModel = tableViewModel!.sectionModels[section]
        return count(sectionModel.cellModels)
    }
    
    public func tableView(tableView:UITableView, titleForHeaderInSection section:Int) -> String? {
        return title(forSection:section, sectionAccessoryViewModel:{ (sectionModel) -> RLDTableViewSectionAccessoryViewModel? in
            return sectionModel.header
        })
    }
    
    public func tableView(tableView:UITableView, titleForFooterInSection section:Int) -> String? {
        return title(forSection:section, sectionAccessoryViewModel:{ (sectionModel) -> RLDTableViewSectionAccessoryViewModel? in
            return sectionModel.footer
        })
    }
    
    private func title(forSection section:Int, sectionAccessoryViewModel:((sectionModel:RLDTableViewSectionModel)->RLDTableViewSectionAccessoryViewModel?)) -> String? {
        let sectionModel = tableViewModel!.sectionModels[section]
        if let sectionAccessoryViewModel = sectionAccessoryViewModel(sectionModel:sectionModel) {
            return sectionAccessoryViewModel.title
        }
        return nil
    }
    
    // MARK: Sections index titles
    public func sectionIndexTitlesForTableView(tableView:UITableView) -> [AnyObject]! {
        return tableViewModel!.sectionIndexTitles
    }
    
    public func tableView(tableView:UITableView, sectionForSectionIndexTitle title:String, atIndex index:Int) -> Int {
        for (index, sectionModel) in enumerate(tableViewModel!.sectionModels) {
            if let indexTitle = sectionModel.indexTitle {
                if indexTitle == title {
                    return index
                }
            }
        }
        return 0
    }
    
    // MARK: Data source edition
    public func tableView(tableView:UITableView, canEditRowAtIndexPath indexPath:NSIndexPath) -> Bool {
        let cellModel = self.cellModel(indexPath:indexPath)
        if let editable = cellModel.editable {
            return editable
        }
        return false
    }
    
    public func tableView(tableView:UITableView, canMoveRowAtIndexPath indexPath:NSIndexPath) -> Bool {
        let cellModel = self.cellModel(indexPath:indexPath)
        if let movable = cellModel.movable {
            return movable
        }
        return false
    }
    
    public func tableView(tableView:UITableView, commitEditingStyle editingStyle:UITableViewCellEditingStyle, forRowAtIndexPath indexPath:NSIndexPath) {
        switch editingStyle {
        case .Insert:
            self.tableView(tableView, commitInsertionForRowAtIndexPath:indexPath)
        case .Delete:
            self.tableView(tableView, commitDeletionForRowAtIndexPath:indexPath)
        case .None:
            break
        }
    }
    
    public func tableView(tableView:UITableView, moveRowAtIndexPath sourceIndexPath:NSIndexPath, toIndexPath destinationIndexPath:NSIndexPath) {
        let sourceSectionModel = tableViewModel!.sectionModels[sourceIndexPath.section]
        let destinationSectionModel = tableViewModel!.sectionModels[destinationIndexPath.section]
        let cellModel = sourceSectionModel.cellModels[sourceIndexPath.row]
        
        sourceSectionModel.remove(cellModel:cellModel)
        destinationSectionModel.insert(cellModel:cellModel, atIndex:destinationIndexPath.row)
    }
    
    private func tableView(tableView:UITableView, commitInsertionForRowAtIndexPath indexPath:NSIndexPath) {
        let sectionModel = tableViewModel!.sectionModels[indexPath.section]
        if let defaultCellModelClassForInsertions = sectionModel.defaultCellModelClassForInsertions {
            let cellModelType = NSClassFromString(defaultCellModelClassForInsertions) as! RLDTableViewCellModel.Type
            let cellModel = cellModelType()
            
            sectionModel.insert(cellModel:cellModel, atIndex:indexPath.row)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
        }
    }
    
    private func tableView(tableView:UITableView, commitDeletionForRowAtIndexPath indexPath:NSIndexPath) {
        let sectionModel = tableViewModel!.sectionModels[indexPath.section]
        let cellModel = sectionModel.cellModels[indexPath.row]
        
        sectionModel.remove(cellModel:cellModel)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
    }
    
    // MARK: Model accessors
    private func cellModel(#indexPath:NSIndexPath) -> RLDTableViewCellModel {
        let sectionModel = tableViewModel!.sectionModels[indexPath.section]
        return sectionModel.cellModels[indexPath.row]
    }
    
}