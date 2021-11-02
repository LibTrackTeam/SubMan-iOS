//
//  LoginViewModelTests.swift
//  SubManTests
//
//  Created by Joseph Acquah on 31/10/2021.
//

import XCTest
@testable import SubMan

class LoginViewModelTest: XCTestCase {
    var sut: LoginViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LoginViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    

}
