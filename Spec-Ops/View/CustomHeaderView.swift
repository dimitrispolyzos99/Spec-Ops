//
//  CustomHeaderView.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 25/5/26.
//

import Foundation

protocol CustomHeaderViewDelegate: AnyObject {
    func didTapLogout()
}

class ProfileViewController: CustomHeaderViewDelegate {
    
    let headerView = CustomHeaderView()
    
    init(){
        headerView.delegate = self
    }
    
    func didTapLogout() {
        handleUserLogout()
    }
    
    func handleUserLogout() {
        print("🔒 Ο ViewController ανέλαβε: Διαγραφή δεδομένων και επιστροφή στην οθόνη Login!")
    }
}

class CustomHeaderView{
    weak var delegate: CustomHeaderViewDelegate?
    
    func showProfile() {
        print("👤 Ο View ανέλαβε: Κατάληξη Χρήστη!")
        delegate?.didTapLogout()
    }
}
