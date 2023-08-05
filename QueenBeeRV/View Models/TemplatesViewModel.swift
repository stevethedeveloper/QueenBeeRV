//
//  TemplatesViewModel.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 8/3/23.
//

import Foundation
import UIKit.UIApplication
import CoreData

final public class TemplatesViewModel {
    var onErrorHandling: ((String) -> Void)?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var templates: Observable<[Template]> = Observable([])

    func loadTemplatesFromFile() {
        DispatchQueue.global().async {
            if let templatesFileURL = Bundle.main.url(forResource: "checklist_templates", withExtension: "json") {
                if let templatesContents = try? String(contentsOf: templatesFileURL) {
                    self.parseTemplates(json: templatesContents)
                }
            }
        }
    }
    
    func parseTemplates(json: String) {
        let decoder = JSONDecoder()
        
        do {
            let jsonString = json.data(using: .utf8)
            if let jsonString = jsonString {
                let templatesDecoded = try decoder.decode(Templates.self, from: jsonString)
                self.templates.value = templatesDecoded.templates
            }
        } catch {
            self.onErrorHandling?("Could not load templates.  Please check your connection and try again.")
        }
        
    }
    
//    func createList(from template: Template) {
//        let newList = TodoList(context: context)
//        newList.title = title
//        
//        do {
//            try context.save()
//            getAllLists()
//        } catch {
//            self.onErrorHandling?("Could not save checklist.  Please check your connection and try again.")
//        }
//    }
}
