import UIKit
import XCTest

class RLDTableViewModelTests:XCTestCase {
    // MARK: Section index titles test cases
    func testSectionIndexTitlesAreTakenFromSectionsWhenNotSet() {
        // GIVEN:
        //   A table view data model
        //     with a section with a certain index title
        let indexTitle = "~"
        let tableViewModel = tableViewModelWithSectionWithIndexTitle(indexTitle)
        
        // WHEN:
        //   The data model is asked for its section index titles
        let sectionIndexTitles = tableViewModel.sectionIndexTitles!
        
        // THEN:
        //   The section index title of its section is returned
        XCTAssertEqual(count(sectionIndexTitles), 1)
        XCTAssert(contains(sectionIndexTitles, indexTitle))
    }
    
    func testSectionIndexTitlesReturnedWhenSet() {
        // GIVEN:
        //   A table view data model
        //     with a section with a certain index title
        let indexTitle = "~"
        let tableViewModel = tableViewModelWithSectionWithIndexTitle(indexTitle)
        
        // WHEN:
        //   The sectionIndexTitles property of the data model is set
        let sectionIndexTitles = ["A"]
        tableViewModel.sectionIndexTitles = sectionIndexTitles
        
        // THEN:
        //   The data model return the set object for its sectionIndexTitles property
        XCTAssertEqual(tableViewModel.sectionIndexTitles!, sectionIndexTitles)
    }
    
    // MARK: Helper methods
    func tableViewModelWithSectionWithIndexTitle(indexTitle:String) -> RLDTableViewModel {
        let cellModel = RLDTableViewCellModel()
        let sectionModel = RLDTableViewSectionModel()
        let tableViewModel = RLDTableViewModel()

        sectionModel.indexTitle = indexTitle
        tableViewModel.add(cellModel:cellModel, toSectionModel:sectionModel)
        
        return tableViewModel
    }
}