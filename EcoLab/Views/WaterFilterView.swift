import SwiftUI
import CoreML
import Vision
import AVFoundation

struct WaterFilterView: View {
    @State private var currentStep: WaterFilterStep = .intro
    private let cameraViewController = CameraViewController()
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.presentationMode) var presentationMode // To control dismiss

    enum WaterFilterStep: Int {
        case intro = 0
        case materialInfo
        case bottleCheck
        case bottleDetection
        case bucketCheck
        case bucketDetection
        case buildingFilter
        case finish
        
        var progressStep: Int {
            switch self {
            case .intro, .materialInfo: return 0
            case .bottleCheck, .bottleDetection, .bucketCheck, .bucketDetection: return 1
            case .buildingFilter: return 2
            case .finish: return 3
            }
        }
    }

    var body: some View {
        ZStack {
            CameraView(
                cameraViewController: cameraViewController,
                onBottleClassificationResult: nil,
                onBucketClassificationResult: nil
            )
            .blur(radius: 5)
            .ignoresSafeArea()

            VStack {
                // Conditionally show the ProgressBar except in the `buildingFilter` step
                if currentStep != .buildingFilter {
                    ProgressBar(currentStep: currentStep.progressStep)
                        .padding(.top, 20)
                }
                
                Spacer() // Add a spacer to push content below if necessary
                
                switch currentStep {
                case .intro:
                    IntroView(onAdvance: {
                        withAnimation {
                            currentStep = .materialInfo
                        }
                    }, onBack: {
                        presentationMode.wrappedValue.dismiss() // Return to ProyectsMenuView
                    })
                    .transition(.opacity)

                case .materialInfo:
                    MaterialInfoView(onAdvance: {
                        withAnimation {
                            currentStep = .bottleCheck
                        }
                    }, onBack: {
                        withAnimation {
                            currentStep = .intro
                        }
                    })
                    .transition(.opacity)

                case .bottleCheck:
                    BottleCheckView(onAdvance: {
                        withAnimation {
                            currentStep = .bottleDetection
                        }
                    }, onBack: {
                        withAnimation {
                            currentStep = .materialInfo
                        }
                    })
                    .transition(.opacity)

                case .bottleDetection:
                    if appSettings.isDeveloperMode {
                        DeveloperPassView(onAdvance: {
                            withAnimation {
                                currentStep = .bucketCheck
                            }
                        }, onBack:{
                            withAnimation{
                                currentStep = .bottleCheck
                            }
                        })
                        .transition(.opacity)
                    } else {
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
                    }, onBack: {
                        withAnimation {
                            currentStep = .bottleDetection
                        }
                    })
                    .transition(.opacity)

                case .bucketDetection:
                    if appSettings.isDeveloperMode {
                        DeveloperPassView(onAdvance: {
                            withAnimation {
                                currentStep = .buildingFilter
                            }
                        }, onBack:{
                            withAnimation{
                                currentStep = .bucketCheck
                            }
                        })
                        .transition(.opacity)
                    } else {
                        BucketDetectionView(
                            onAdvance: {
                                withAnimation {
                                    currentStep = .buildingFilter
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
                    
                case .buildingFilter:
                    BuildingFilter01(
                        onAdvance: {
                            withAnimation {
                                currentStep = .finish
                            }
                        },
                        onBack: {
                            withAnimation {
                                currentStep = .bucketCheck
                            }
                        }
                    )
                    .transition(.opacity)
                    .ignoresSafeArea() // Make it full screen

                case .finish:
                    // Replace EmptyView with your final view and handle `onBack` accordingly
                    EmptyView()
                }
                
                Spacer() // Add a spacer for spacing in other steps
            }
        }
    }
}
