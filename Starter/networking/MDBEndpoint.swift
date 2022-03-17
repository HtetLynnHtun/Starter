//
//  MDBEndpoint.swift
//  Starter
//
//  Created by kira on 16/03/2022.
//

import Foundation
import Alamofire

enum MDBEndpoint: URLConvertible {
    func asURL() throws -> URL {
        return url
    }
    
    case upcomingMovies
    case popularMovies
    case movieGenres
    case popularSeries
    case search(String, Int)
    case topRatedMovies(Int)
    case popularPeople(Int)
    case personDetails(Int)
    case combinedCredits(Int)
    case movieDetails(Int)
    case movieCredits(Int)
    case similarMovies(Int)
    case movieTrailers(Int)
    case seriesDetails(Int)
    case seriesTrailers(Int)
    case seriesCredits(Int)
    case similarSeries(Int)
    
    var url: URL {
        let urlComponents = NSURLComponents(string: baseURL.appending(apiPath))
        if (urlComponents?.queryItems == nil) {
            urlComponents?.queryItems = []
        }
        urlComponents?.queryItems!.append(URLQueryItem(name: "api_key", value: AppConstants.apiKey))
        return urlComponents!.url!
    }
    
    private var baseURL: String {
        return AppConstants.baseURL
    }
    
    private var apiPath: String {
        switch self{
        case .upcomingMovies:
            return "/movie/upcoming"
        case .popularMovies:
            return "/movie/popular"
        case .movieGenres:
            return "/genre/movie/list"
        case .popularSeries:
            return "/tv/popular"
        case .search(let query, let page):
            return "/search/multi?query=\(query)&page=\(page)"
        case .topRatedMovies(let page):
            return "/movie/top_rated?page=\(page)"
        case .popularPeople(let page):
            return "/person/popular?page=\(page)"
        case .personDetails(let id):
            return "/person/\(id)"
        case .combinedCredits(let id):
            return "/person/\(id)/combined_credits"
        case .movieDetails(let id):
            return "/movie/\(id)"
        case .movieCredits(let id):
            return "/movie/\(id)/credits"
        case .similarMovies(let id):
            return "/movie/\(id)/similar"
        case .movieTrailers(let id):
            return "/movie/\(id)/videos"
        case .seriesDetails(let id):
            return "/tv/\(id)"
        case .seriesTrailers(let id):
            return "/tv/\(id)/videos"
        case .seriesCredits(let id):
            return "/tv/\(id)/credits"
        case .similarSeries(let id):
            return "/tv/\(id)/similar"
        }
    }
}
