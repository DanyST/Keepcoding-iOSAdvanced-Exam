//
//  LoginViewState.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import Foundation

enum LoginViewState {
    case loading(_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case navigateToNext
}
