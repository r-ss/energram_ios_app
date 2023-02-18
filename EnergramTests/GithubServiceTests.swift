//
//  NetworkTests.swift
//  YourFirstCommitTests
//
//  Created by Alex Antipov on 08.02.2023.
//

import XCTest
@testable import YourFirstCommit


final class GithubServiceMock: Mockable, GithubServiceable {
    func searchRepositories(name: String) async -> Result<SearchReposResults, RequestError> {
        return .success(loadJSON(filename: "search_response", type: SearchReposResults.self))
    }
    
    func loadFirstCommit(for repo: Repo) async -> Result<[Commit], RequestError> {
        return .success(loadJSON(filename: "first_commit_response", type: [Commit].self))
    }

    func loadFirstCommitFiles(for repo: Repo) async -> Result<RepoFilesTree, RequestError> {
        return .success(loadJSON(filename: "files_response", type: RepoFilesTree.self))
    }
}



final class NetworkTests: XCTestCase {
    
    let repoMock: Repo = Repo(id: 1, name: "some", fullName: "no/matter", htmlUrl: "h-ti-ti-pi")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGithubServiceSearchMock() async {
        let serviceMock = GithubServiceMock()
        let failingResult = await serviceMock.searchRepositories(name: "no/matter")
            
        switch failingResult {
            case .success(let result):
                XCTAssertEqual(result.total_count, 354)
                XCTAssertEqual(result.items[0].fullName, "oklog/ulid")
            case .failure:
                XCTFail("The request should not fail")
        }
    }
    
    func testGithubServiceFirstCommitMock() async {
        let serviceMock = GithubServiceMock()
        let failingResult = await serviceMock.loadFirstCommit(for: self.repoMock)
            
        switch failingResult {
            case .success(let result):
                XCTAssertEqual(result[0].sha, "18239bd1a77300c8a99e73964477ba79f827466d")
                XCTAssertEqual(result[0].detail.message, "Release ULID v0.1.0")
                XCTAssertEqual(result[0].detail.author.name, "Tomás Senart")
            case .failure:
                XCTFail("The request should not fail")
        }
    }
    
    func testGithubServiceFilesMock() async {
        let serviceMock = GithubServiceMock()
        let failingResult = await serviceMock.loadFirstCommitFiles(for: self.repoMock)
            
        switch failingResult {
            case .success(let result):
                XCTAssertEqual(result.tree[0].path, ".gitignore")
                XCTAssertEqual(result.tree[0].size, 329)
                XCTAssertEqual(result.tree[1].path, ".travis.yml")
            case .failure:
                XCTFail("The request should not fail")
        }
    }
    
    
    
    
    func testFirstCommitLoading() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        
        
//        let repo: Repo = Repo(id: 1, name: "pomodoress", fullName: "r-ss/pomodoress", htmlUrl: "h-ti-ti")
//
//
//        Task(priority: .background) {
//            let result = await GithubService().loadFirstCommit(for: repo)
//            switch result {
//            case .success(let res):
//                XCTAssertEqual(res[0].detail.message, "initial")
//                XCTAssertEqual(res[0].detail.author.name, "Alex Antipov")
//            case .failure(let error):
//                print("Request failed with error: \(error.customMessage)")
//            }
//        }
        
                
    }


}
