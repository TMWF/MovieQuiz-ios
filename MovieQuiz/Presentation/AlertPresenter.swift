//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Leo Bonhart on 30.11.2022.
//

import UIKit

struct AlertPresenter {
    private weak var controller: UIViewController?
    
    init(controller: UIViewController? = nil) {
        self.controller = controller
    }
    
    func showAlert(_ alertModel: AlertModel) {
        guard let controller else { return }
        
        let alert = UIAlertController(title: alertModel.title,
                                 message: alertModel.message,
                                 preferredStyle: .alert)

        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completion)

        alert.addAction(action)

        controller.present(alert, animated: true, completion: nil)
    }
}
