//
//  RLDNavigation
//
//  Copyright (c) 2015 Rafael Lopez Diez. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

// MARK: RLDTableViewReusableViewModel class

public class RLDTableViewReusableViewModel {
    // MARK: Initialization
    required public init() {
        reuseIdentifier = NSStringFromClass(self.dynamicType)
    }
    
    // MARK: Parent linking
    weak private(set) var sectionModel:RLDTableViewSectionModel?
    public func set(sectionModel newSectionModel:RLDTableViewSectionModel) {
        sectionModel = newSectionModel
    }
    
    // MARK: Reuse identifier
    public var reuseIdentifier:String
    
    // MARK: Variable height support
    public var height:CGFloat?
    public var estimatedHeight:CGFloat?
}

// MARK: RLDTableViewCellModel class

public class RLDTableViewCellModel:RLDTableViewReusableViewModel {
    // MARK: Indentation
    public var indentationLevel:NSInteger?
    
    // MARK: Editing
    public var editable:Bool?
    public var movable:Bool?
    public var shouldIndentWhileEditing:Bool?
    public var editingStyle:UITableViewCellEditingStyle?
    public var titleForDeleteConfirmationButton:String?
    
    // MARK: Copy and Paste
    public var shouldShowMenu:Bool?
}

// MARK: RLDTableViewSectionAccessoryViewModel class

public class RLDTableViewSectionAccessoryViewModel:RLDTableViewReusableViewModel {
    // MARK: Title
    public var title:String?
}

// MARK: RLDTableViewSectionModel class

public class RLDTableViewSectionModel:Equatable {
    // MARK: Parent linking
    weak private(set) var tableModel:RLDTableViewModel?
    public func set(tableModel newTableModel:RLDTableViewModel) {
        tableModel = newTableModel
    }
    
    // Listing cell models
    private(set) var cellModels:[RLDTableViewCellModel] = []
    
    // MARK: Insertions
    public var defaultCellModelClassForInsertions:String?
    
    public func add(cellModel:RLDTableViewCellModel) {
        cellModel.set(sectionModel:self)
        cellModels.append(cellModel)
    }
    
    public func insert(cellModel:RLDTableViewCellModel, atIndex index:Int) {
        cellModel.set(sectionModel:self)
        cellModels.insert(cellModel, atIndex:index)
    }
    
    // MARK: Deletions
    public func remove(cellModel:RLDTableViewCellModel) {
        cellModel.set(sectionModel:self)
        cellModels = cellModels.filter( {!($0 === cellModel)} )
    }
    
    // MARK: Index title
    public var indexTitle:String?
    
    // MARK: Section header and footer
    public var header:RLDTableViewSectionAccessoryViewModel? {
        didSet {
            header?.set(sectionModel:self)
        }
    }
    
    public var footer:RLDTableViewSectionAccessoryViewModel? {
        didSet {
            footer?.set(sectionModel:self)
        }
    }
}

// MARK: RLDTableViewSectionModel equality operator

public func == (lhs:RLDTableViewSectionModel, rhs:RLDTableViewSectionModel) -> Bool {
    return lhs === rhs
}

// MARK: RLDTableViewModel class

public class RLDTableViewModel {
    
    public init() {
        // XCode Version 6.3 (6D570) forces me to add this initializer
    }
    
    // MARK: Listing section models
    private(set) var sectionModels:[RLDTableViewSectionModel] = []
    
    // MARK: Adding section models
    public func addNewSectionModel() -> RLDTableViewSectionModel {
        let newSectionModel = RLDTableViewSectionModel()
        add(newSectionModel)
        return newSectionModel
    }
    
    private func add(sectionModel:RLDTableViewSectionModel) {
        sectionModel.set(tableModel:self)
        sectionModels.append(sectionModel)
    }
    
    // MARK: Adding cell models
    public func add(cellModel:RLDTableViewCellModel) {
        if sectionModels.count == 0 {
            addNewSectionModel()
        }
        add(cellModel, toSectionModel:sectionModels.last!)
    }
    
    public func add(cellModel:RLDTableViewCellModel, toSectionModel sectionModel:RLDTableViewSectionModel) {
        if !sectionModels.contains(sectionModel) {
            add(sectionModel)
        }
        sectionModel.add(cellModel)
    }
    
    // MARK: Section index titles
    private var _sectionIndexTitles:[String]?
    public var sectionIndexTitles:[String]? {
        set {
            _sectionIndexTitles = newValue
        }
        get {
            if (_sectionIndexTitles == nil) {
                var indexTitles:[String] = []
                
                for sectionModel in sectionModels {
                    if let indexTitle = sectionModel.indexTitle {
                        indexTitles.append(indexTitle)
                    }
                }
                
                if indexTitles.count > 0 {
                    _sectionIndexTitles = indexTitles
                }
            }
            return _sectionIndexTitles
        }
    }
}