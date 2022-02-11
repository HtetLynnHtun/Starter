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
    func navigateToMovieDetailViewController() {
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as?  MovieDetailViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
}
