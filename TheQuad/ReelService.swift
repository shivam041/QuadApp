import AVFoundation
import UIKit

class ReelService {
    static let shared = ReelService()
    
    // 1080x1920 (Vertical Video Standard)
    let renderSize = CGSize(width: 1080, height: 1920)
    
    func generateReel(from entries: [LifeEntry], completion: @escaping (URL?) -> Void) {
        Task {
            let resultURL = await processReel(entries: entries)
            completion(resultURL)
        }
    }
    
    // Modern Async Function to avoid Deprecation Warnings
    private func processReel(entries: [LifeEntry]) async -> URL? {
        let composition = AVMutableComposition()
        
        guard let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return nil
        }
        
        var currentTime = CMTime.zero
        var layerInstructions: [AVMutableVideoCompositionLayerInstruction] = []
        
        // Limit to 50 clips for performance
        let processableEntries = Array(entries.prefix(50))
        
        for entry in processableEntries {
            guard let filename = entry.mediaFilename else { continue }
            
            // Only processing videos in this V1
            if entry.isVideo {
                let url = MediaManager.shared.getVideoURL(filename: filename)
                let asset = AVAsset(url: url)
                
                do {
                    // Modern Async Loading
                    let duration = try await asset.load(.duration)
                    let tracks = try await asset.load(.tracks)
                    
                    let sliceDuration = min(duration.seconds, 2.5)
                    let timeRange = CMTimeRange(start: .zero, duration: CMTime(seconds: sliceDuration, preferredTimescale: 600))
                    
                    if let assetTrack = tracks.first(where: { $0.mediaType == .video }) {
                        try videoTrack.insertTimeRange(timeRange, of: assetTrack, at: currentTime)
                        
                        // Modern Transform Calculation
                        let instruction = try await createInstruction(track: videoTrack, assetTrack: assetTrack, at: currentTime)
                        layerInstructions.append(instruction)
                        
                        currentTime = CMTimeAdd(currentTime, timeRange.duration)
                    }
                } catch {
                    print("Skipping bad asset: \(error)")
                }
            }
        }
        
        return await exportComposition(composition, instructions: layerInstructions)
    }
    
    private func createInstruction(track: AVCompositionTrack, assetTrack: AVAssetTrack, at time: CMTime) async throws -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        
        // Modern Async Property Access
        let assetSize = try await assetTrack.load(.naturalSize)
        let transform = try await assetTrack.load(.preferredTransform)
        
        // Correct for orientation
        var finalSize = assetSize
        if transform.b != 0 && transform.c != 0 {
            finalSize = CGSize(width: assetSize.height, height: assetSize.width)
        }
        
        // Scale to Fill Logic
        let scale = max(renderSize.width / finalSize.width, renderSize.height / finalSize.height)
        let newWidth = finalSize.width * scale
        let newHeight = finalSize.height * scale
        let x = (renderSize.width - newWidth) / 2
        let y = (renderSize.height - newHeight) / 2
        
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let moveTransform = CGAffineTransform(translationX: x, y: y)
        let finalTransform = transform.concatenating(scaleTransform).concatenating(moveTransform)
        
        instruction.setTransform(finalTransform, at: time)
        return instruction
    }
    
    private func exportComposition(_ composition: AVComposition, instructions: [AVMutableVideoCompositionLayerInstruction]) async -> URL? {
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = renderSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: composition.duration)
        instruction.layerInstructions = instructions
        videoComposition.instructions = [instruction]
        
        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPreset1920x1080) else {
            return nil
        }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("TheQuad_Reel_\(UUID().uuidString).mp4")
        
        exporter.outputURL = outputURL
        exporter.outputFileType = .mp4
        exporter.videoComposition = videoComposition
        
        // Modern Export
        await exporter.export()
        
        if exporter.status == .completed {
            return outputURL
        } else {
            print("Export failed: \(String(describing: exporter.error))")
            return nil
        }
    }
}
