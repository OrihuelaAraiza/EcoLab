import SwiftUI
import CoreML
import Vision
import AVFoundation

struct WaterFilterView: View {
    @State private var showIntro = true
    @State private var showMaterialInfo = false
    @State private var showChecklist = false
    @State private var showBottleCheck = false
    @State private var showBottleDetectionView = false
    @State private var showBucketCheck = false
    @State private var showBucketDetectionView = false
    @State private var showAR = false

    private let cameraViewController = CameraViewController()

    var body: some View {
        ZStack {
            // Cámara en el fondo
            CameraView(
                cameraViewController: cameraViewController,
                onBottleClassificationResult: nil,
                onBucketClassificationResult: nil
            )
            .blur(radius: 5)
            .ignoresSafeArea()

            VStack {
                if showIntro {
                    IntroView(onAdvance: {
                        showIntro = false
                        showMaterialInfo = true
                    })
                    .transition(.opacity)
                } else if showMaterialInfo {
                    MaterialInfoView(onAdvance: {
                        showMaterialInfo = false
                        showChecklist = true
                    })
                    .transition(.opacity)
                } else if showChecklist {
                    ChecklistViewWrapper(onAllItemsChecked: {
                        showChecklist = false
                        showBottleCheck = true
                    })
                    .transition(.opacity)
                } else if showBottleCheck {
                    BottleCheckView(onAdvance: {
                        showBottleCheck = false
                        showBottleDetectionView = true
                    })
                    .transition(.opacity)
                } else if showBottleDetectionView {
                    BottleDetectionView(
                        onAdvance: {
                            showBottleDetectionView = false
                            showBucketCheck = true
                        },
                        onBack: {
                            showBottleDetectionView = false
                            showBottleCheck = true
                        },
                        cameraViewController: cameraViewController
                    )
                    .onAppear {
                        cameraViewController.detectingBucket = false
                    }
                    .transition(.opacity)
                } else if showBucketCheck {
                    BucketCheckView(onAdvance: {
                        showBucketCheck = false
                        showBucketDetectionView = true
                    })
                    .transition(.opacity)
                } else if showBucketDetectionView {
                    BucketDetectionView(
                        onAdvance: {
                            showBucketDetectionView = false
                            showAR = true
                        },
                        onBack: {
                            showBucketDetectionView = false
                            showBucketCheck = true
                        },
                        cameraViewController: cameraViewController
                    )
                    .onAppear {
                        cameraViewController.detectingBucket = true
                    }
                    .onDisappear {
                        cameraViewController.detectingBucket = false
                    }
                    .transition(.opacity)
                } else if showAR {
                    ARViewContainer()
                        .ignoresSafeArea()
                }
            }
        }
    }
}
