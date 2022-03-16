//
//  Router.swift
//  Starter
//
//  Created by kira on 11/02/2022.
//

import Foundation
import UIKit

enum StoryboardNames: String {
    case Main = "Main"
    case Authentication = "Authentication"
    case LaunchScreen = "LaunchScreen"
}

extension UIStoryboard {
    static func mainStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: StoryboardNames.Main.rawValue, bundle: nil)
    }
}

extension UIViewController {
    func navigateToMovieDetailViewController(id: Int, contentType: DetailContentType) {
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as?  MovieDetailViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        vc.contentType = contentType
        vc.contentId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSearchViewController() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToActorDetailsViewController(id: Int) {
        let vc = ActorDetailsViewController()
        vc.modalPresentationStyle = .automatic
        vc.actorID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToMoreContentViewController(contentType: MoreContentType) {
        let vc = MoreContentViewController()
        vc.modalPresentationStyle = .automatic
        vc.contentType = contentType
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
