//
//  ViewController.swift
//  DragNDrop-CoreML
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 22/09/17.
//  Copyright © 2017 Leonardo Ferreira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreMLHelper.setModelImages(with: CGSize(width: 149.5, height: 149.5))
        view.addInteraction(UIDropInteraction(delegate: self))
    }

}

// MARK: - UIDrop Interaction

extension ViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        for dragItem in session.items {
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { object, error in
                
                guard error == nil else {
                    return print("Failed to load our item dragged")
                    
                }
                guard let draggedImage = object as? UIImage else {
                    return
                }
                
                print(self.viewModel.classify(image: draggedImage))
                
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: draggedImage)
                    self.view.addSubview(imageView)
                    imageView.frame = CGRect(x: 0, y: 0, width: draggedImage.size.width, height: draggedImage.size.height)
                    
                    let centerPoint = session.location(in: self.view)
                    imageView.center = centerPoint
                }
            })
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
}
