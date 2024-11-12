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
            // Mostrar CameraView solo si no estamos en el paso buildingFilter
            if currentStep != .buildingFilter {
                CameraView(
                    cameraViewController: cameraViewController,
                    onBottleClassificationResult: nil,
                    onBucketClassificationResult: nil
                )
                .blur(radius: 5)
                .ignoresSafeArea()
            }

            // Mostrar BuildingFilter solo en el paso buildingFilter
            if currentStep == .buildingFilter {
                BuildingFilter(onBack: {
                    withAnimation{
                        currentStep = .bottleCheck
                    }
                }, onAdvance: {
                    withAnimation{
                        currentStep = .finish
                    }
                })
                .ignoresSafeArea()
                .background(Color.clear)
                .transition(.opacity)
            }

            // Mostrar el VStack solo si no estamos en el paso buildingFilter
            if currentStep != .buildingFilter {
                VStack {
                    ProgressBar(currentStep: currentStep.progressStep)
                        .padding(.top, 20)
                    
                    Spacer()
                    
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

                    case .finish:
                        FinishView(onAdvance:
                                    {
                            withAnimation{
                                presentationMode.wrappedValue.dismiss()
                            }
                        }, onBack: {
                            withAnimation{
                                currentStep = .buildingFilter
                            }
                        })
                    default:
                        EmptyView()
                    }
                    
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
    }
}
