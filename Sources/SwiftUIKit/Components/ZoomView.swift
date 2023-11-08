//
//  SwiftUIView.swift
//  
//
//  Created by Kevin Mullins on 11/8/23.
//

import SwiftUI
import SwiftletUtilities

/// A zoomable, scrollable container for the given content.
public struct ZoomView<Content: View>: View {
    
    // MARK: - Properties
    /// The minimum zoom level.
    public var minimumZoom = 0.1
    
    /// The maximum zoom level.
    public var maximumZoom = 2.0
    
    /// The plus or miinus zoom step.
    public var zoomStep = 0.10
    
    /// If `true`, show the zoom controls over the content.
    public var showZoomControls = true
    
    /// The size of the zoom control buttons
    public var buttonSize:CGFloat = 24
    
    /// The contents to scroll and zoom.
    @ViewBuilder public var content: Content
    
    // MARK: - States
    /// The amount that the zoom level is being adjusted.
    @State private var totalZoom = 1.0
    
    /// The current zoom level.
    @State private var currentZoom = 0.0
    
    // MARK: - Constructors
    /// Creates a new instance of the control
    /// - Parameters:
    ///   - minimumZoom: The minimum zoom level.
    ///   - maximumZoom: The maximum zoom level.
    ///   - zoomStep: The plus or miinus zoom step.
    ///   - showZoomControls: If `true`, show the zoom controls over the content.
    ///   - buttonSize: The size of the zoom control buttons
    ///   - content: The contents to scroll and zoom.
    public init(minimumZoom: Double = 0.1, maximumZoom: Double = 2.0, zoomStep: Double = 0.10, showZoomControls: Bool = true, buttonSize: CGFloat = 24, @ViewBuilder content: @escaping () -> Content) {
        self.minimumZoom = minimumZoom
        self.maximumZoom = maximumZoom
        self.zoomStep = zoomStep
        self.showZoomControls = showZoomControls
        self.buttonSize = buttonSize
        self.content = content()
    }
    
    // MARK: - Computed Properties
    /// The body of the control.
    public var body: some View {
        ZStack {
            ScrollView([.horizontal, .vertical]) {
                content
                    .scaleEffect(currentZoom + totalZoom)
                #if !os(tvOS)
                    .gesture(
                        MagnifyGesture()
                            .onChanged { value in
                                let lastZoom = currentZoom
                                var zoomLevel = value.magnification - 1
                                let newZoom = totalZoom + zoomLevel
                                if newZoom > maximumZoom {
                                    totalZoom = maximumZoom
                                    zoomLevel = 0
                                }
                                if newZoom < minimumZoom {
                                    currentZoom = lastZoom
                                } else {
                                    currentZoom = zoomLevel
                                }
                            }
                            .onEnded { value in
                                totalZoom += currentZoom
                                currentZoom = 0
                            }
                    )
                #endif
            }
            .defaultScrollAnchor(.center)
            
            if showZoomControls {
                VStack {
                    HStack(spacing: 5) {
                        Spacer()
                        
                        IconButton(icon: "minus.magnifyingglass", text: "", borderWidth: 2, size: buttonSize) {
                            currentZoom = 0
                            if totalZoom > minimumZoom {
                                totalZoom -= zoomStep
                            }
                        }
                        
                        IconButton(icon: "magnifyingglass", text: "", borderWidth: 2, size: buttonSize) {
                            totalZoom = 1.0
                        }
                        
                        IconButton(icon: "plus.magnifyingglass", text: "", borderWidth: 2, size: buttonSize) {
                            currentZoom = 0
                            if totalZoom < maximumZoom {
                                totalZoom += zoomStep
                            }
                        }
                    }
                    .padding(.trailing)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ZoomView() {
        Text("Hello World!")
       .font(.largeTitle)
    }
}
