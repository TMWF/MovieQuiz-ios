//
//  Movie.swift
//  MovieQuiz
//
//  Created by Leo Bonhart on 04.12.2022.
//

import Foundation

struct Movie: Codable {
  let id: String
  let rank: String
  let title: String
  let fullTitle: String
  let year: String
  let image: String
  let crew: String
  let imDbRating: String
  let imDbRatingCount: String
}

struct Actor: Codable {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}

//struct Result: Codable {
//    let items: [Movie]
//}



