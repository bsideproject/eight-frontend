//
//  BlockTableViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/19.
//

import Foundation
import Combine

class BlockTableViewModel {

    var bag = Set<AnyCancellable>()
    var blockList = ["김정완", "박상욱"]
    
    func numberOfRowsInSection() -> Int {
        return blockList.count
    }
    
    
    
    
}
