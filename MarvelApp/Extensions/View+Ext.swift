//
//  View+Ext.swift
//  ModernMVVM
//
//  Created by Vadim Bulavin on 3/20/20.
//  
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
