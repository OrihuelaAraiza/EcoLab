import SwiftUI
import CoreML
import Vision
import AVFoundation

struct WaterFilterView: View {
    @State private var currentStep: WaterFilterStep = .intro
    private let cameraViewController = CameraViewController()
    @EnvironmentObject var appSettings: AppSettings
    
    enum WaterFilterStep {
        case intro
        case materialInfo
        case checklist
        case bottleCheck
        case bottleDetection
        case bucketCheck
        case bucketDetection
        case ar
    }

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
                switch currentStep {
                case .intro:
                    IntroView(onAdvance: {
                        withAnimation {
                            currentStep = .materialInfo
                        }
                    })
                    .transition(.opacity)

                case .materialInfo:
                    MaterialInfoView(onAdvance: {
                        withAnimation {
                            currentStep = .checklist
                        }
                    })
                    .transition(.opacity)

                case .checklist:
                    ChecklistViewWrapper(onAllItemsChecked: {
                        withAnimation {
                            currentStep = .bottleCheck
                        }
                    })
                    .transition(.opacity)

                case .bottleCheck:
                    BottleCheckView(onAdvance: {
                        withAnimation {
                            currentStep = .bottleDetection
                        }
                    })
                    .transition(.opacity)

                case .bottleDetection:
                    if appSettings.isDeveloperMode {
                        DeveloperPassView(onAdvance: {
                            withAnimation {
                                currentStep = .bucketCheck
                            }
                        })
                        .transition(.opacity)
                    }
                    else{
                        BottleDetectionView(
                            onAdvance: {
                                withAnimation {
                                    currentStep = .bucketCheck
                                }
                            },
                            onBack: {
                                withAnimation {
                                    currentStep = .bottleCheck
                                }
                            },
                            cameraViewController: cameraViewController
                        )
                        .onAppear {
                            cameraViewController.detectingBucket = false
                        }
                        .transition(.opacity)
                    }
                    
                case .bucketCheck:
                    BucketCheckView(onAdvance: {
                        withAnimation {
                            currentStep = .bucketDetection
                        }
                    })
                    .transition(.opacity)

                case .bucketDetection:
                    if appSettings.isDeveloperMode {
                        DeveloperPassView(onAdvance: {
                            withAnimation {
                                currentStep = .bucketCheck
                            }
                        })
                        .transition(.opacity)
                    }
                    else{
                        BucketDetectionView(
                            onAdvance: {
                                withAnimation {
                                    currentStep = .ar
                                }
                            },
                            onBack: {
                                withAnimation {
                                    currentStep = .bucketCheck
                                }
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
                    }

                case .ar:
                    ARViewContainer()
                        .ignoresSafeArea()
                }
            }
        }
    }



}
