//
//  ProductListUnitTest.swift
//  ShoppingAppTests
//
//  Created by Gokberk Ozcan on 13.02.2023.
//

import XCTest
@testable import ShoppingApp

final class ProductListUnitTest: XCTestCase {

    var viewModel: ProductListViewModel!
    var fetchExpectation: XCTestExpectation!

    override func setUpWithError() throws {
        viewModel = ProductListViewModel()
        viewModel.delegate = self
        fetchExpectation = expectation(description: "fetchProducts")

    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testProductsCount() throws {
        XCTAssertEqual(viewModel.getProductCount(), 0)
        
        viewModel.fetchProducts()
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(viewModel.getProductCount(), 20)
    }
    
    func testGetFirstGameList() throws {
        XCTAssertNil(viewModel.getProduct(at: 0))
        
        viewModel.fetchProducts()
        waitForExpectations(timeout: 10)
        
        let firstItem = viewModel.getProduct(at: 0)
        XCTAssertEqual(firstItem?.productName, "La Lorraine Tombul Ekmek")
        XCTAssertEqual(firstItem?.productImage, "https://github.com/android-getir/public-files/blob/main/images/5f36a28b29d3b131b9d95548_tr_1637858193743.jpeg")
        XCTAssertEqual(firstItem?.productPrice, 7.5)
        XCTAssertEqual(firstItem?.productDescription, "Doğal ham maddelerden üretilir.Koruyucu ve katkı maddesi içermez.İçindekiler: Un, su, maya, tuz")
        
    }
    
    func testPriceAtIndex() throws {
        XCTAssertNil(viewModel.getPriceAtIndex(at: 0))
        
        viewModel.fetchProducts()
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(viewModel.getPriceAtIndex(at: 0), 7.5)
    }
}

extension ProductListUnitTest: ProductListViewModelDelegate {
    func productsLoaded() {
        fetchExpectation.fulfill()
    }
    
    func productsFailed(error: Error) {}
}
