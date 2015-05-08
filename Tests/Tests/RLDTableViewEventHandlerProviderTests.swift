import XCTest
import UIKit

class RLDTableViewEventHandlerProviderTests: XCTestCase {
    
    func testFactoryMethod() {
        // GIVEN:
        // A table view
        // A view model
        // A view
        //   An event hanlder
        //     which is able to handle these three assets
        //     registered with the event handler provider
        let testTableView = UITableView()
        let testViewModel = RLDTableViewReusableViewModel()
        let testView = UIView()
        
        RLDTableViewEventHandlerProvider.register(RLDTestEventHandler)
        RLDTestEventHandler.setCanHandleClosure { (tableView, viewModel, view) -> Bool in
            return tableView === testTableView
                && viewModel === testViewModel
                && view === testView
        }
        
        // WHEN:
        //   We ask the event handler provider for an event handler with the three defined assets
        //   We ask the event handler provider for an event handler with different assets
        let firstEventHandler = RLDTableViewEventHandlerProvider.eventHandler(tableView:testTableView, viewModel:testViewModel, view:testView)
        let secondEventHandler = RLDTableViewEventHandlerProvider.eventHandler(tableView:testTableView, viewModel:RLDTableViewReusableViewModel(), view:testView)
        
        // THEN:
        //   It is able to provide an event handler for the first combination
        //   It is not able to provide an event handler for the second combination
        XCTAssertNotNil(firstEventHandler)
        XCTAssertNil(secondEventHandler)
    }
}