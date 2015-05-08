import UIKit
import XCTest

class RLDTableViewDelegateTests: XCTestCase {
    
    // SUT
    var tableViewDelegate:RLDTableViewDelegate?
    
    // Collaborators
    var tableDataSource:RLDTableViewDataSource?
    let tableView = UITableView(frame:CGRect(x:0, y:0, width: 1, height:1))
    let cell = UITableViewCell()
    let view = UITableViewHeaderFooterView()
    let indexPath = NSIndexPath(forRow:0, inSection:0)
    
    override func setUp() {
        super.setUp()
        
        // GIVEN:
        //   A table view delegate
        //   An event handler
        //     capable to handle any model, table view and view
        //   A table view, a header/footer view, a cell and an index path
        let cellModel = RLDTableViewCellModel()
        let tableViewModel = RLDTableViewModel()
        tableViewModel.add(cellModel:cellModel)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:cellModel.reuseIdentifier)
        RLDTestEventHandler.register()
        
        tableViewDelegate = RLDTableViewDelegate(tableViewModel:tableViewModel)
        tableView.delegate = tableViewDelegate
        
        tableDataSource = RLDTableViewDataSource(tableViewModel:tableViewModel)
        tableView.dataSource = tableDataSource
    }
    
    override func tearDown() {
        RLDTestEventHandler.reset()
        
        super.tearDown()
    }
    
    // MARK : Display customization test cases
    func testWillDisplayCell() {
        // WHEN:
        //   We inform the delegate that the table view will display the cell for a row at the index path
        tableViewDelegate!.tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
        
        // THEN:
        //   The willDisplayView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("willDisplayView")
    }
    
    func testWillDisplayHeaderView() {
        // WHEN:
        //   We inform the delegate that the table view will display the header view of a section
        tableViewDelegate!.tableView(tableView, willDisplayHeaderView:view, forSection:indexPath.section)
        
        // THEN:
        //   The willDisplayView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("willDisplayView")
    }
    
    func testWillDisplayFooterView() {
        // WHEN:
        //   We inform the delegate that the table view will display the footer view of a section
        tableViewDelegate!.tableView(tableView, willDisplayFooterView:view, forSection:indexPath.section)
        
        // THEN:
        //   The willDisplayView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("willDisplayView")
    }
    
    func testDidEndDisplayingCell() {
        // WHEN:
        //   We inform the delegate that the table view did end displaying the cell for a row at the index path
        tableViewDelegate!.tableView(tableView, didEndDisplayingCell:cell, forRowAtIndexPath:indexPath)
        
        // THEN:
        //   The didEndDisplayingView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("didEndDisplayingView")
    }
    
    func testDidEndDisplayingHeaderView() {
        // WHEN:
        //   We inform the delegate that the table view did end displaying the header view of a section
        tableViewDelegate!.tableView(tableView, didEndDisplayingHeaderView:view, forSection:indexPath.section)
        
        // THEN:
        //   The didEndDisplayingView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("didEndDisplayingView")
    }
    
    func testDidEndDisplayingFooterView() {
        // WHEN:
        //   We inform the delegate that the table view did end displaying the footer view of a section
        tableViewDelegate!.tableView(tableView, didEndDisplayingFooterView:view, forSection:indexPath.section)
        
        // THEN:
        //   The didEndDisplayingView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("didEndDisplayingView")
    }
    
    // MARK : Section header and footer reusing test cases
    func testHeaderReusing() {
        // GIVEN:
        //   A table view data model
        //     with an automatically created section model
        //       with a cell model assigned to it
        //     set as the model of the table view delegate
        //   A header data model
        //     with a certain reuse identifier
        //       registered with the table view with a certain view class
        //     assigned as the header of the section model
        let dataModel = RLDTableViewModel()
        dataModel.add(cellModel:RLDTableViewCellModel())
        tableViewDelegate = RLDTableViewDelegate(tableViewModel:dataModel)
        tableView.delegate = tableViewDelegate
        
        let headerModel = RLDTableViewSectionAccessoryViewModel()
        headerModel.reuseIdentifier = "HeaderReuseIdentifier"
        tableView.registerClass(RLDTestAccessoryView.self, forHeaderFooterViewReuseIdentifier:headerModel.reuseIdentifier)
        dataModel.sectionModels.last!.header = headerModel
        
        // WHEN:
        //   We ask the delegate for a view for the header of the section
        let sectionHeader = tableViewDelegate!.tableView(tableView, viewForHeaderInSection:indexPath.section) as? RLDTestAccessoryView
        
        // THEN:
        //   The returned view class must be the same as the registered class
        //   Its reuse identifier must match the one for the header model
        XCTAssertNotNil(sectionHeader)
        XCTAssertTrue(sectionHeader!.dynamicType === RLDTestAccessoryView.self)
        XCTAssertEqual(sectionHeader!.reuseIdentifier!, headerModel.reuseIdentifier)
    }
    
    func testFooterReusing() {
        // GIVEN:
        //   A table view data model
        //     with an automatically created section model
        //       with a cell model assigned to it
        //     set as the model of the table view delegate
        //   A footer data model
        //     with a certain reuse identifier
        //       registered with the table view with a certain view class
        //     assigned as the footer of the section model
        let dataModel = RLDTableViewModel()
        dataModel.add(cellModel:RLDTableViewCellModel())
        tableViewDelegate = RLDTableViewDelegate(tableViewModel:dataModel)
        tableView.delegate = tableViewDelegate
        
        let footerModel = RLDTableViewSectionAccessoryViewModel()
        footerModel.reuseIdentifier = "FooterReuseIdentifier"
        tableView.registerClass(RLDTestAccessoryView.self, forHeaderFooterViewReuseIdentifier:footerModel.reuseIdentifier)
        dataModel.sectionModels.last!.footer = footerModel
        
        // WHEN:
        //   We ask the delegate for a view for the footer of the section
        let sectionFooter = tableViewDelegate!.tableView(tableView, viewForFooterInSection:indexPath.section) as? RLDTestAccessoryView
        
        // THEN:
        //   The returned view class must be the same as the registered class
        //   Its reuse identifier must match the one for the footer model
        XCTAssertNotNil(sectionFooter)
        XCTAssertTrue(sectionFooter!.dynamicType === RLDTestAccessoryView.self)
        XCTAssertEqual(sectionFooter!.reuseIdentifier!, footerModel.reuseIdentifier)
    }
    
    // MARK : Variable height support test cases
    func testVariableHeightForRow() {
        // GIVEN:
        //   A table view data model
        //     set as the model of the table view delegate
        //   A cell model
        //     with a certain estimated height
        //     with a certain height
        //     assigned to the table model
        let cellModel = cellModelInTableViewDataModel()
        cellModel.estimatedHeight = 1
        cellModel.height = 2
        
        // WHEN:
        //   We ask the delegate for
        //     the estimated height of a given cell for a row at the index path
        //     the height of a given cell for a row at the index path
        let estimatedHeight = tableViewDelegate!.tableView(tableView, estimatedHeightForRowAtIndexPath:indexPath)
        let height = tableViewDelegate!.tableView(tableView, heightForRowAtIndexPath:indexPath)
        
        // THEN:
        //   The returned estimated height must be equal to the height of the cell model
        //   The returned height must be equal to the height of the cell model
        XCTAssertEqual(estimatedHeight, cellModel.estimatedHeight!)
        XCTAssertEqual(height, cellModel.height!)
    }
    
    func testVariableHeightForHeader() {
        // GIVEN:
        //   A table view data model
        //     with a cell model assigned to it
        //     set as the model of the table view delegate
        //   An automatically created section model
        //   A header data model
        //     with a certain estimated height
        //     with a certain height
        //     assigned to the section model
        let dataModel = RLDTableViewModel()
        dataModel.add(cellModel:RLDTableViewCellModel())
        tableViewDelegate = RLDTableViewDelegate(tableViewModel:dataModel)
        tableView.delegate = tableViewDelegate
        
        let sectionModel = dataModel.sectionModels.last!
    
        let headerModel = RLDTableViewSectionAccessoryViewModel()
        headerModel.estimatedHeight = 1
        headerModel.height = 2
        sectionModel.header = headerModel
        
        // WHEN:
        //   We ask the delegate for
        //     the estimated height of a given cell for a row at the index path
        //     the height of a given cell for a row at the index path
        let estimatedHeight = tableViewDelegate!.tableView(tableView, estimatedHeightForHeaderInSection:indexPath.section)
        let height = tableViewDelegate!.tableView(tableView, heightForHeaderInSection:indexPath.section)
        
        // THEN:
        //   The returned estimated height must be equal to the height of the cell model
        //   The returned height must be equal to the height of the cell model
        XCTAssertEqual(estimatedHeight, headerModel.estimatedHeight!)
        XCTAssertEqual(height, headerModel.height!)
    }
    
    func testVariableHeightForFooter() {
        // GIVEN:
        //   A table view data model
        //     with a cell model assigned to it
        //     set as the model of the table view delegate
        //   An automatically created section model
        //   A footer data model
        //     with a certain estimated height
        //     with a certain height
        //     assigned to the section model
        let dataModel = RLDTableViewModel()
        dataModel.add(cellModel:RLDTableViewCellModel())
        tableViewDelegate = RLDTableViewDelegate(tableViewModel:dataModel)
        tableView.delegate = tableViewDelegate
        
        let sectionModel = dataModel.sectionModels.last!
        
        let footerModel = RLDTableViewSectionAccessoryViewModel()
        footerModel.estimatedHeight = 1
        footerModel.height = 2
        sectionModel.footer = footerModel
        
        // WHEN:
        //   We ask the delegate for
        //     the estimated height of a given cell for a row at the index path
        //     the height of a given cell for a row at the index path
        let estimatedHeight = tableViewDelegate!.tableView(tableView, estimatedHeightForFooterInSection:indexPath.section)
        let height = tableViewDelegate!.tableView(tableView, heightForFooterInSection:indexPath.section)
        
        // THEN:
        //   The returned estimated height must be equal to the height of the cell model
        //   The returned height must be equal to the height of the cell model
        XCTAssertEqual(estimatedHeight, footerModel.estimatedHeight!)
        XCTAssertEqual(height, footerModel.height!)
    }
    
    // MARK : Accessories (disclosures)
    func testAccessoryButtonTapped() {
        // WHEN:
        //   We inform the delegate that the accessory button for a row with a certain index path has been tapped
        tableViewDelegate!.tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
        
        // THEN:
        //   The accessoryButtonTapped method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("accessoryButtonTapped")
    }
    
    // MARK : Selection
    func testShouldHighlightRow() {
        // WHEN:
        //   We ask the delegate wether a row at a certain index path should be highlighted
        tableViewDelegate!.tableView(tableView, shouldHighlightRowAtIndexPath:indexPath)
        
        // THEN:
        //   The shouldHighlightView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("shouldHighlightView")
    }
    
    func testDidHighlightRow() {
        // WHEN:
        //   We inform the delegate that the table view did highlight a row at the index path
        tableViewDelegate!.tableView(tableView, didHighlightRowAtIndexPath:indexPath)
        
        // THEN:
        //   The didHighlightView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("didHighlightView")
    }
    
    func testDidUnhighlightRow() {
        // WHEN:
        //   We inform the delegate that the table view did unhighlight a row at the index path
        tableViewDelegate!.tableView(tableView, didUnhighlightRowAtIndexPath:indexPath)
        
        // THEN:
        //   The didUnhighlightView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("didUnhighlightView")
    }
    
    func testWillSelectRowAtIndexPath() {
        // WHEN:
        //   We inform the delegate that the table view will select a row at the index path
        tableViewDelegate!.tableView(tableView, willSelectRowAtIndexPath:indexPath)
        
        // THEN:
        //   The willSelectView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("willSelectView")
    }
    
    func testWillDeselectRowAtIndexPath() {
        // WHEN:
        //   We inform the delegate that the table view will deselect a row at the index path
        tableViewDelegate!.tableView(tableView, willDeselectRowAtIndexPath:indexPath)
        
        // THEN:
        //   The willDeselectView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("willDeselectView")
    }
    
    func testDidSelectRowAtIndexPath() {
        // WHEN:
        //   We inform the delegate that the table view selected a row at the index path
        tableViewDelegate!.tableView(tableView, didSelectRowAtIndexPath:indexPath)
        
        // THEN:
        //   The didSelectView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("didSelectView")
    }
    
    func testDidDeselectRowAtIndexPath() {
        // WHEN:
        //   We inform the delegate that the table view deselected a row at the index path
        tableViewDelegate!.tableView(tableView, didDeselectRowAtIndexPath:indexPath)
        
        // THEN:
        //   The didDeselectView method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("didDeselectView")
    }
    
    // MARK : Editing
    func testEditingStyleForRow() {
        // GIVEN:
        //   A table view data model
        //     set as the model of the table view delegate
        //   A cell data model
        //     with a certain editing style
        //     added to the table model
        let cellModel = cellModelInTableViewDataModel()
        cellModel.editingStyle = UITableViewCellEditingStyle.Delete
        
        // WHEN:
        //   We ask the delegate for the editing style of a row at a certain index path
        let editingStyle = tableViewDelegate!.tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
        
        // THEN:
        //   The returned value must be equal to the editing style in the cell model
        XCTAssertEqual(editingStyle, cellModel.editingStyle!)
    }
    
    func testEditActions() {
        // WHEN:
        //   We ask the delegate for the edit actions of a row at a certain index path
        let editActions = tableViewDelegate!.tableView(tableView, editActionsForRowAtIndexPath:indexPath)
        
        // THEN:
        //   The returned edit actions array must be equal to the one returned by the event handler
        RLDTestEventHandler.isCallRegistered("editActions")
    }
    
    func testTitleForDeleteConfirmationButton() {
        // GIVEN:
        //   A table view data model
        //     set as the model of the table view delegate
        //   A cell data model
        //     with a certain editing style
        //     added to the table model
        let cellModel = cellModelInTableViewDataModel()
        cellModel.titleForDeleteConfirmationButton = "TestTitleForDeleteConfirmationButton"
        
        // WHEN:
        //   We ask the delegate for the editing style of a row at a certain index path
        let titleForDeleteConfirmationButton = tableViewDelegate!.tableView(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath)
        
        // THEN:
        //   The returned title must be equal to the one in the cell model
        XCTAssertEqual(titleForDeleteConfirmationButton, cellModel.titleForDeleteConfirmationButton!)
    }
    
    func testShouldIndentWhileEditing() {
        // GIVEN:
        //   A table view data model
        //     set as the model of the table view delegate
        //   A cell data model
        //     that states that the cell should indent while editing
        //     added to the table model
        let cellModel = cellModelInTableViewDataModel()
        cellModel.shouldIndentWhileEditing = true
        
        // WHEN:
        //   We ask the delegate wether a row at a certain index path should indent while editing
        let shouldIndentWhileEditing = tableViewDelegate!.tableView(tableView, shouldIndentWhileEditingRowAtIndexPath:indexPath)
        
        // THEN:
        //   The returned value must be equal to the one set in the cell model
        XCTAssertEqual(shouldIndentWhileEditing, cellModel.shouldIndentWhileEditing!)
    }
    
    func testWillBeginEditing() {
        // WHEN:
        //   We inform the delegate that the table view will beging editing a row at the index path
        tableViewDelegate!.tableView(tableView, willBeginEditingRowAtIndexPath:indexPath)
        
        // THEN:
        //   The willBeginEditing method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("willBeginEditing")
    }
    
    func testDidEndEditing() {
        // WHEN:
        //   We inform the delegate that the table view ended editing a row at the index path
        tableViewDelegate!.tableView(tableView, didEndEditingRowAtIndexPath:indexPath)
        
        // THEN:
        //   The didEndEditing method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("didEndEditing")
    }
    
    // MARK : Indentation
    func testIndentationLevel() {
        // GIVEN:
        //   A table view data model
        //     set as the model of the table view delegate
        //   A cell data model
        //     with a certain indentation level
        //     added to the table model
        let dataModel = RLDTableViewModel()
        tableViewDelegate = RLDTableViewDelegate(tableViewModel:dataModel)
        tableView.delegate = tableViewDelegate
        
        let cellModel = RLDTableViewCellModel()
        cellModel.indentationLevel = 2
        dataModel.add(cellModel:cellModel)
        
        // WHEN:
        //   We ask the delegate for the indentation level of a row at a certain index path
        let indentationLevel = tableViewDelegate!.tableView(tableView, indentationLevelForRowAtIndexPath:indexPath)
        
        // THEN:
        //   The returned value must be equal to the one set in the cell model
        XCTAssertEqual(indentationLevel, cellModel.indentationLevel!)
    }
    
    // MARK : Copy and Paste
    func testShouldShowMenu() {
        // GIVEN:
        //   A table view data model
        //     set as the model of the table view delegate
        //   A cell data model
        //     that states that the cell should show the copy and paste menu
        //     added to the table model
        let cellModel = cellModelInTableViewDataModel()
        cellModel.shouldShowMenu = true
        
        // WHEN:
        //   We ask the delegate wether a row at a certain index path should show the copy and paste menu
        let shouldShowMenu = tableViewDelegate!.tableView(tableView, shouldShowMenuForRowAtIndexPath:indexPath)
        
        // THEN:
        //   The returned value must be equal to the one set in the cell model
        XCTAssertEqual(shouldShowMenu, cellModel.shouldShowMenu!)
    }
    
    func testCanPerformAction() {
        // WHEN:
        //   We ask the delegate wether a row at a certain index path can perform an action
        tableViewDelegate!.tableView(tableView, canPerformAction:nil, forRowAtIndexPath:indexPath, withSender:self)
        
        // THEN:
        //   The canPerformAction:withSender: method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("canPerformAction:withSender:")
    }
    
    func testPerformAction() {
        // WHEN:
        //   We ask the delegate to perform an action for a row at a certain index path
        tableViewDelegate!.tableView(tableView, performAction:nil, forRowAtIndexPath:indexPath, withSender:self)
        
        // THEN:
        //   The performAction:withSender: method of the event handler will be called
        RLDTestEventHandler.isCallRegistered("performAction:withSender:")
    }
    
    // MARK : Helper methods
    func cellModelInTableViewDataModel() -> RLDTableViewCellModel {
        let dataModel = RLDTableViewModel()
        tableViewDelegate! = RLDTableViewDelegate(tableViewModel:dataModel)
        
        let cellModel = RLDTableViewCellModel()
        dataModel.add(cellModel:cellModel)
        return cellModel
    }
}