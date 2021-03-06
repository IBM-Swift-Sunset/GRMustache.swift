// The MIT License
//
// Copyright (c) 2015 Gwendal Roué
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import XCTest
import Mustache

class ContextValueForMustacheExpressionTests: XCTestCase {

// GENERATED: allTests required for Swift 3.0
    static var allTests : [(String, (ContextValueForMustacheExpressionTests) -> () throws -> Void)] {
        return [
            ("testImplicitIteratorExpression", testImplicitIteratorExpression),
            ("testIdentifierExpression", testIdentifierExpression),
            ("testScopedExpression", testScopedExpression),
            ("testFilteredExpression", testFilteredExpression),
            ("testParseError", testParseError),
            ("testRenderError", testRenderError),
        ]
    }
// END OF GENERATED CODE

    func testImplicitIteratorExpression() {
        let context = Context(Box("success"))
        let box = try! context.mustacheBox(forExpression: ".")
        guard let string = box.value as? String else {
            XCTFail("box.value is not String")
            return
        }
        XCTAssertEqual(string, "success")
    }
    
    func testIdentifierExpression() {
        let context = Context(Box(["name": "success"]))
        let box = try! context.mustacheBox(forExpression: "name")
        guard let string = box.value as? String else {
            XCTFail("box.value is not String")
            return
        }
        XCTAssertEqual(string, "success")
    }
    
    func testScopedExpression() {
        let context = Context(Box(["a": ["name": "success"]]))
        let box = try! context.mustacheBox(forExpression: "a.name")
        guard let string = box.value as? String else {
            XCTFail("box.value is not String")
            return
        }
        XCTAssertEqual(string, "success")
    }
    
    func testFilteredExpression() {
        let filter = Filter({ (string: String?) -> MustacheBox in
            return Box(string!.uppercased())
        })
        let context = Context(Box(["name": Box("success"), "f": Box(filter)]))
        let box = try! context.mustacheBox(forExpression: "f(name)")
        guard let string = box.value as? String else {
            XCTFail("box.value is not String")
            return
        }
        XCTAssertEqual(string, "SUCCESS")
    }

    func testParseError() {
        let context = Context()
        do {
            let _ = try context.mustacheBox(forExpression: "a.")
            XCTFail("Expected MustacheError")
        } catch let error as MustacheError {
            XCTAssertEqual(error.kind, MustacheError.Kind.ParseError) // Invalid expression
        } catch {
            XCTFail("Expected MustacheError")
        }
    }
    
    func testRenderError() {
        let context = Context()
        do {
            let _ = try context.mustacheBox(forExpression: "f(x)")
            XCTFail("Expected MustacheError")
        } catch let error as MustacheError {
            XCTAssertEqual(error.kind, MustacheError.Kind.RenderError) // Missing filter
        } catch {
            XCTFail("Expected MustacheError")
        }
    }
}
