import XCTest
import UIKit

class RLDTableViewDataSourceTests:XCTestCase {
    // SUT
    let dataModel = RLDTableViewModel()
    
    // Collaborators
    lazy var dataSource:RLDTableViewDataSource = {
        return RLDTableViewDataSource(tableViewModel:self.dataModel)
        }()
    var tableView = UITableView()
    
    // MARK: Sections test cases
    func testAutomaticSectionCreation() {
        // GIVEN:
        //   A cell model
        let cellModel = RLDTableViewCellModel()
        
        // WHEN:
        //   We add the cell model to the table view model
        dataModel.add(cellModel:cellModel)
        
        // THEN:
        //   A section is automatically created in the data model
        //   The data source should return one row for the first section
        XCTAssertEqual(count(dataModel.sectionModels), 1)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:0), 1)
    }
    
    func testAutomaticSectionConfiguration() {
        // GIVEN:
        //   A cell model
        let cellModel = RLDTableViewCellModel()
        
        // WHEN:
        //   We add the cell model to the table view model
        //   We set up the last section in the model
        //     setting up its index title
        //     setting up its header
        //     setting up its footer
        dataModel.add(cellModel:cellModel)
        
        let sectionModel = dataModel.sectionModels.last!
        sectionModel.indexTitle = "~"
        let header = RLDTableViewSectionAccessoryViewModel()
        header.title = "Header"
        sectionModel.header = header
        let footer = RLDTableViewSectionAccessoryViewModel()
        footer.title = "Footer"
        sectionModel.footer = footer
        
        // THEN:
        //   The data source should return one section
        //   The data source should return one row for the first section
        //   The first section header title must be equal to the title of the header
        //   The first section footer title must be equal to the title of the footer
        XCTAssertEqual(dataSource.numberOfSectionsInTableView(tableView), 1)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:0), 1)
        XCTAssertEqual(dataSource.tableView(tableView, titleForHeaderInSection:0)!, header.title!)
        XCTAssertEqual(dataSource.tableView(tableView, titleForFooterInSection:0)!, footer.title!)
    }
    
    func testManualSectionAdding() {
        // GIVEN:
        //   A cell model
        //   A section created manually
        //     with its index title set up
        //     with its header set up
        //     with its footer set up
        let cellModel = RLDTableViewCellModel()
        
        let sectionModel = RLDTableViewSectionModel()
        sectionModel.indexTitle = "~"
        let header = RLDTableViewSectionAccessoryViewModel()
        header.title = "Header"
        sectionModel.header = header
        let footer = RLDTableViewSectionAccessoryViewModel()
        footer.title = "Footer"
        sectionModel.footer = footer
        
        // WHEN:
        //   We add the cell model to the table view model
        //     specifying it should be added to the manually created section
        dataModel.add(cellModel:cellModel, toSectionModel:sectionModel)
        
        // THEN:
        //   The data source should return one section
        //   The data source should return one row for the first section
        //   The first section header title must be equal to the title of the header
        //   The first section footer title must be equal to the title of the footer
        //   The fist section in the model must be equal to the manually created section
        XCTAssertEqual(dataSource.numberOfSectionsInTableView(tableView), 1)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:0), 1)
        XCTAssertEqual(dataSource.tableView(tableView, titleForHeaderInSection:0)!, header.title!)
        XCTAssertEqual(dataSource.tableView(tableView, titleForFooterInSection:0)!, footer.title!)
        XCTAssertEqual(dataModel.sectionModels[0], sectionModel)
    }
    
    func testManualSectionAddingAfterAutomaticSectionAdded() {
        // GIVEN:
        //   A cell model
        //   A section created manually
        let cellModel = RLDTableViewCellModel()
        
        let sectionModel = RLDTableViewSectionModel()
        
        // WHEN:
        //   We add the cell model to the table view model twice
        //   We add the cell model to the table view model three times
        //     specifying it should be added to the manually created section
        repeat(2, closure:{
            self.dataModel.add(cellModel:cellModel)
        })
        repeat(3, closure:{
            self.dataModel.add(cellModel:cellModel, toSectionModel:sectionModel)
        })
        
        // THEN:
        //   The data source should return two sections
        //   The data source should return two rows for the first section
        //   The data source should return three rows for the second section
        //   The second section in the model must be equal to the manually created section
        XCTAssertEqual(dataSource.numberOfSectionsInTableView(tableView), 2)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:0), 2)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:1), 3)
        XCTAssertEqual(dataModel.sectionModels[1], sectionModel)
    }
    
    func testMultipleManualSectionAdding() {
        // GIVEN:
        //   A cell model
        //   Two sections created manually
        let cellModel = RLDTableViewCellModel()
        
        let firstSectionModel = RLDTableViewSectionModel()
        let secondSectionModel = RLDTableViewSectionModel()
        
        // WHEN:
        //   We add the cell model to the table view model three times
        //     specifying it should be added to the first manually created section
        //   We add the cell model to the table view model three times
        //     specifying it should be added to the second manually created section
        repeat(2, closure:{
            self.dataModel.add(cellModel:cellModel, toSectionModel:firstSectionModel)
        })
        repeat(3, closure:{
            self.dataModel.add(cellModel:cellModel, toSectionModel:secondSectionModel)
        })
        
        // THEN:
        //   The data source should return two sections
        //   The data source should return two rows for the first section
        //   The data source should return three rows for the second section
        //   The first section in the model must be equal to the first manually created section
        //   The second section in the model must be equal to the second manually created section
        XCTAssertEqual(dataSource.numberOfSectionsInTableView(tableView), 2)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:0), 2)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:1), 3)
        XCTAssertEqual(dataModel.sectionModels[0], firstSectionModel)
        XCTAssertEqual(dataModel.sectionModels[1], secondSectionModel)
    }
    
    // MARK: Section index titles test cases
    func testAutomaticSectionIndexTitles() {
        // GIVEN:
        //   A cell model
        //   Two sections created manually
        //     with its indexes titles set up
        let cellModel = RLDTableViewCellModel()
        
        let firstSectionModel = RLDTableViewSectionModel()
        firstSectionModel.indexTitle = "1"
        let secondSectionModel = RLDTableViewSectionModel()
        secondSectionModel.indexTitle = "2"
        
        // WHEN:
        //   We add the cell model to the table view model
        //     specifying it should be added to the first manually created section
        //   We add the cell model to the table view
        //     specifying it should be added to the second manually created section
        dataModel.add(cellModel:cellModel, toSectionModel:firstSectionModel)
        dataModel.add(cellModel:cellModel, toSectionModel:secondSectionModel)
        
        // THEN:
        //   The data source should return and array with two section index titles
        //   The first one must be equal to the section index title of the first manually created section
        //   The second one must be equal to the section index title of the second manually created section
        let sectionIndexTitles = dataSource.sectionIndexTitlesForTableView(tableView) as! [String]
        XCTAssertEqual(count(sectionIndexTitles), 2)
        XCTAssertEqual(sectionIndexTitles[0], firstSectionModel.indexTitle!)
        XCTAssertEqual(sectionIndexTitles[1], secondSectionModel.indexTitle!)
    }
    
    func testManualSectionIndexTitles() {
        // GIVEN:
        //   A data model
        //     with its section index titles set to numbers from 1 to 4
        //   A cell model
        //   Two sections created manually
        //     with its indexes titles set up to 1 and 2
        dataModel.sectionIndexTitles = ["1", "2", "3", "4"]
        let cellModel = RLDTableViewCellModel()
        
        let firstSectionModel = RLDTableViewSectionModel()
        firstSectionModel.indexTitle = "1"
        let secondSectionModel = RLDTableViewSectionModel()
        secondSectionModel.indexTitle = "2"
        
        // WHEN:
        //   We add the cell model to the table view model
        //     specifying it should be added to the first manually created section
        //   We add the cell model to the table view
        //     specifying it should be added to the second manually created section
        dataModel.add(cellModel:cellModel, toSectionModel:firstSectionModel)
        dataModel.add(cellModel:cellModel, toSectionModel:secondSectionModel)
        
        // THEN:
        //   The data source should return and array equal to the previously set up index title array of the data model
        let sectionIndexTitles = dataSource.sectionIndexTitlesForTableView(tableView) as! [String]
        XCTAssertEqual(sectionIndexTitles, dataModel.sectionIndexTitles!)
    }
    
    func testSectionIndexTitlesToSectionsRelationship() {
        // GIVEN:
        //   An data model
        //     with its section index titles set to numbers from 1 to 4
        //   A cell model
        //   Two sections created manually
        //     with its indexes titles set up to 1 and 4
        dataModel.sectionIndexTitles = ["1", "2", "3", "4"]
        let cellModel = RLDTableViewCellModel()
        
        let firstSectionModel = RLDTableViewSectionModel()
        firstSectionModel.indexTitle = "1"
        let secondSectionModel = RLDTableViewSectionModel()
        secondSectionModel.indexTitle = "4"
        
        // WHEN:
        //   We add the cell model to the table view model
        //     specifying it should be added to the first manually created section
        //   We add the cell model to the table view
        //     specifying it should be added to the second manually created section
        dataModel.add(cellModel:cellModel, toSectionModel:firstSectionModel)
        dataModel.add(cellModel:cellModel, toSectionModel:secondSectionModel)
        
        // THEN:
        //   The data source should return the second section when asked to provide an index for the fourth element of the section index titles array
        XCTAssertEqual(dataSource.tableView(tableView,sectionForSectionIndexTitle:"4", atIndex:3), 1)
    }
    
    // MARK: Data source edition test cases
    func testCellModelEditionPreferences() {
        // GIVEN:
        //   A table view data source
        //   A data model containing two cell models
        //     the first one being non editable
        //     the first one being editable
        let firstCellModel = RLDTableViewCellModel()
        firstCellModel.editable = true
        let secondCellModel = RLDTableViewCellModel()
        secondCellModel.editable = false
        dataModel.add(cellModel:firstCellModel)
        dataModel.add(cellModel:secondCellModel)
        
        // THEN:
        //   The data source should identify the first cell in the first section as editable
        //   The data source should identify the second cell in the first section as non editable
        XCTAssertEqual(dataSource.tableView(tableView, canEditRowAtIndexPath:NSIndexPath(forRow:0, inSection:0)), true)
        XCTAssertEqual(dataSource.tableView(tableView, canEditRowAtIndexPath:NSIndexPath(forRow:1, inSection:0)), false)
    }
    
    func testCellModelReorderingPreferences() {
        // GIVEN:
        //   A table view data source
        //   A data model containing two cell models
        //     the first one being non movable
        //     the first one being movable
        let firstCellModel = RLDTableViewCellModel()
        firstCellModel.movable = true
        let secondCellModel = RLDTableViewCellModel()
        secondCellModel.movable = false
        dataModel.add(cellModel:firstCellModel)
        dataModel.add(cellModel:secondCellModel)
        
        // THEN:
        //   The data source should identify the first cell in the first section as movable
        //   The data source should identify the second cell in the first section as non movable
        XCTAssertEqual(dataSource.tableView(tableView, canMoveRowAtIndexPath:NSIndexPath(forRow:0, inSection:0)), true)
        XCTAssertEqual(dataSource.tableView(tableView, canMoveRowAtIndexPath:NSIndexPath(forRow:1, inSection:0)), false)
    }
    
    func testCellModelInsertion() {
        // GIVEN:
        //   A table view data source
        //   A data model containing two cell models
        let sectionModel = RLDTableViewSectionModel()
        
        let expectedClassForInsertedCellModel = "Tests.RLDFirstTestCellModel"
        sectionModel.defaultCellModelClassForInsertions = expectedClassForInsertedCellModel
        
        var testCellModels:[RLDTableViewCellModel] = []
        repeat(2, closure:{
        let testCellModel = RLDSecondTestCellModel()
            testCellModels.append(testCellModel)
            self.dataModel.add(cellModel:testCellModel, toSectionModel:sectionModel)
        })
        
        // WHEN:
        //   We ask the data source to insert a new cell at the second row in the first section
        dataSource.tableView(tableView,
        commitEditingStyle:UITableViewCellEditingStyle.Insert,
        forRowAtIndexPath:NSIndexPath(forRow:1, inSection:0))
        
        // THEN:
        //   The data source must return three rows for the first section
        //   The section model must contain three cell models
        //   The second cell model must have the expected class
        //   The first cell model must be the first one added
        //   The third cell model must be the second one added
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:0), 3)
        XCTAssertEqual(count(sectionModel.cellModels), 3)
        XCTAssertEqual(NSStringFromClass(sectionModel.cellModels[1].dynamicType), expectedClassForInsertedCellModel)
        XCTAssertTrue(sectionModel.cellModels[0] === testCellModels[0])
        XCTAssertTrue(sectionModel.cellModels[2] === testCellModels[1])
    }
    
    func testCellModelDeletion() {
        // GIVEN:
        //   A table view data source
        //     with a cell provider
        //   A data model
        //     with a section with a default cell model class for insertions
        //     containing three cell models
        var testCellModels:[RLDTableViewCellModel] = []
        repeat(3, closure:{
            let cellModel = RLDTableViewCellModel()
            testCellModels.append(cellModel)
            self.dataModel.add(cellModel:cellModel)
        })
        let sectionModel = dataModel.sectionModels.last!
        
        // WHEN:
        //   We ask the data source to delete the second row in the first section
        dataSource.tableView(tableView,
            commitEditingStyle:UITableViewCellEditingStyle.Delete,
            forRowAtIndexPath:NSIndexPath(forRow:1, inSection:0))
        
        // THEN:
        //   The data source should return two rows for the first section
        //   The section model must contain two cell models
        //   The first cell model must be the first one added
        //   The second cell model must be the third one added
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:0), 2)
        XCTAssertEqual(count(sectionModel.cellModels), 2)
        XCTAssertTrue(sectionModel.cellModels[0] === testCellModels[0])
        XCTAssertTrue(sectionModel.cellModels[1] === testCellModels[2])
    }
    
    func testCellModelReordering() {
        // GIVEN:
        //   A table view data source
        //     with a cell provider
        //   A data model
        //     with a first section with a cell model
        //     with a second section with a cell model
        var testCellModels:[RLDTableViewCellModel] = []
        repeat(2, closure:{
            let cellModel = RLDTableViewCellModel()
            testCellModels.append(cellModel)
            self.dataModel.add(cellModel:cellModel, toSectionModel:RLDTableViewSectionModel())
        })
        let firstSectionModel = dataModel.sectionModels[0]
        let secondSectionModel = dataModel.sectionModels[1]
        
        // WHEN:
        //   We ask the data source to move the first row of the first section to the second row of the second section
        dataSource.tableView(tableView,
            moveRowAtIndexPath:NSIndexPath(forRow:0, inSection:0),
            toIndexPath:NSIndexPath(forRow:1, inSection:1))
        
        // THEN:
        //   The data source should return zero rows for the first section
        //   The data source should return two rows for the second section
        //   The data model must contain zero cell models in its first section
        //   The data model must contain two cell models in its second section
        //   The first cell model in the second section must be the second one added
        //   The second cell model in the second section must be the first one added
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:0), 0)
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection:1), 2)
        XCTAssertEqual(count(firstSectionModel.cellModels), 0)
        XCTAssertEqual(count(secondSectionModel.cellModels), 2)
        XCTAssertTrue(secondSectionModel.cellModels[0] === testCellModels[1])
        XCTAssertTrue(secondSectionModel.cellModels[1] === testCellModels[0])
    }
    
    // MARK: Test cell generation test cases
    func testCellGeneration() {
        // GIVEN:
        //   A table view
        //   A table view data source
        //     assigned to the table view
        //   A data model
        //   A cell model
        //     added to the data model
        //   A UITableViewCell subclass
        //     registered with the table view for the cell model reuse identifier
        tableView.dataSource = dataSource
        
        let cellModel = RLDTableViewCellModel()
        dataModel.add(cellModel:cellModel)
        
        let expectedCellClass = "Tests.RLDTestTableViewCell"
        tableView.registerClass(NSClassFromString(expectedCellClass), forCellReuseIdentifier:cellModel.reuseIdentifier)
        
        // WHEN:
        //  We ask the data source for a cell in the first row of the first section of the table
        let returnedCell = dataSource.tableView(tableView, cellForRowAtIndexPath:NSIndexPath(forRow:0, inSection:0))
        
        // THEN:
        //  The returned cell class must match the registered UITableViewCell subclass
        XCTAssertEqual(NSStringFromClass(returnedCell.dynamicType), expectedCellClass)
    }

    // MARK: Helper functions
    private func repeat(times:UInt, closure:(Void->Void)) {
        for var counter:UInt = 0; counter < times; counter++ {
            closure()
        }
    }
}