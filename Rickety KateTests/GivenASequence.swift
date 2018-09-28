//
//  GivenASequence.swift
//  Rickety KateTests
//
//  Created by Geoff Burns on 29/7/18.
//  Copyright © 2018 Nereids Gold. All rights reserved.
//

import UIKit
import XCTest
import Rickety_Kate
import Cards

class GivenASequence: XCTestCase {
 
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOperations() {
        // This is an example of a functional test case.
        
        let s = [1,2,3,4,5]
        let r = s.rotate(2)
        
        XCTAssert(r.elementsEqual([3,4,5,1,2]), "rotate failed")
      
 
        let t = s.tail
        
        XCTAssert(t.elementsEqual([2,3,4,5]), "tail failed")
        
        let h = s.head
        
        XCTAssert(h==1, "head failed")
        
        let f = s.from(1, forLength: 2)
        
        XCTAssert(f.elementsEqual([2,3]), "from failed")
        
        let a = s.all { $0 < 8 }
        
        XCTAssert(a, "all failed")
        
        let a2 = s.all { $0 < 3 }
        
        XCTAssert(!a2, "all failed")
        
        let m = s.some { $0 < 3 }
        
        XCTAssert(m, "some failed")
        
        let m2 = s.some { $0 > 8 }
        
        XCTAssert(!m2, "some failed")
        
        let n = s.none { $0 < 3 }
        
        XCTAssert(!n, "None failed")
        
        let n2 = s.none { $0 > 8 }
        
        XCTAssert(n2, "None failed")
        let o = s.notAll { $0 < 8 }
        
        XCTAssert(!o, "all failed")
        
        let o2 = s.notAll { $0 < 3 }
        
        XCTAssert(o2, "all failed")
        
    }
    
}

