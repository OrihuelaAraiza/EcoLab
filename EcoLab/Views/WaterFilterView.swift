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
        case ar
        case finish
        
        var progressStep: Int {
            switch self {
            case .intro, .materialInfo: return 0
            case .bottleCheck, .bottleDetection, .bucketCheck, .bucketDetection: return 1
            case .ar: return 2
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
                ProgressBar(currentStep: currentStep.progressStep)
                    .padding(.top, 20)
                
                switch currentStep {
                case .intro:
                    IntroView(onAdvance: {
                        withAnimation {
                            currentStep = .materialInfo
                        }
                    }, onBack: {
                        // Dismiss the WaterFilterView to return to ProyectsMenuView
                        presentationMode.wrappedValue.dismiss()
                    })
                    .transition(.opacity)

                case .materialInfo:
                    MaterialInfoView(onAdvance: {
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
                    })
                    .transition(.opacity)

                case .bucketDetection:
                    if appSettings.isDeveloperMode {
                        DeveloperPassView(onAdvance: {
                            withAnimation {
                                currentStep = .ar
                            }
                        })
                        .transition(.opacity)
                    } else {
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
                    EmptyView()
                case .finish:
                    EmptyView()
                }
            }
        }
    }
}
