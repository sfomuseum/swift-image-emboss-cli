import Foundation
import ArgumentParser
import AppKit
import ImageEmboss

public enum Errors: Error {
    case notFound
    case invalidPath
    case invalidImage
    case cgImage
    case processError
    case unsupportedOS
    case pngWrite
}

@available(macOS 14.0, *)
struct ImageEmbossCLI: ParsableCommand {
    
    @Option(help:"The path to a source image file to extract image subjects from.")
    var inputFile: String
    
    @Option(help:"Return all subjects extracted from the source image as a single image. ")
    var combined: Bool = true
    
    func run() throws {
        
        let fm = FileManager.default
        
        if (!fm.fileExists(atPath: inputFile)){
            throw(Errors.notFound)
        }
        
        let source_url = URL(fileURLWithPath: inputFile)
        let source_root = source_url.deletingLastPathComponent()
        
        guard let im = NSImage(byReferencingFile:inputFile) else {
            throw(Errors.invalidImage)
        }
        
        guard let cgImage = im.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw(Errors.cgImage)
        }
                
        let ic = ImageEmboss()
        let rsp = ic.ProcessImage(image: cgImage, combined: combined)
        
        switch rsp {
        case .failure(let error):
            throw(error)
        case .success(let data):
                        
            var i = 1
            
            for cg_im in data {
 
                let ns_im = NSImage(cgImage: cgImage, size: CGSize(width: cg_im.width, height: cg_im.height))
                
                let fname = source_url.deletingPathExtension().lastPathComponent
                let im_fname =  fname + "-emboss-" + String(format:"%03d", i) + ".png"
                
                let im_url = URL(fileURLWithPath: source_root.absoluteString)
                let im_path = im_url.appending(path: im_fname)
                
                if !ns_im.pngWrite(to: im_path) {
                    throw(Errors.pngWrite)
                }

                i += 1
            }
        }
        
    }
    
}

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            return false
        }
    }
}

if #available(macOS 14.0, *) {
    ImageEmbossCLI.main()
} else {
    throw(Errors.unsupportedOS)
}
