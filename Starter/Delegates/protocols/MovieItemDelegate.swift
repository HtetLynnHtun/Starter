//
//  MovieItemDelegate.swift
//  Starter
//
//  Created by kira on 11/02/2022.
//

import Foundation

protocol MovieItemDelegate: class {
    func onTapMovie(id: Int, contentType: DetailContentType)
}
