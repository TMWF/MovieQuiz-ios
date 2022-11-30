//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Leo Bonhart on 30.11.2022.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (UIAlertAction) -> Void
}
