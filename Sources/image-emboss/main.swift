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
}

@available(macOS 14.0, *)
struct ImageEmbossCLI: ParsableCommand {
    
    @Option(help:"The path to an image file to extract image subjects from")
    var inputFile: String
    
    @Option(help:"Combined...")
    var combined: Bool
    
    func run() throws {
        
        let fm = FileManager.default
        
        if (!fm.fileExists(atPath: inputFile)){
            throw(Errors.notFound)
        }
        
        let source_url = URL(fileURLWithPath: inputFile)
        let source_root = source_url.deletingLastPathComponent()
        let source_ext = source_url.pathExtension
        
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
            
            print("WHAT \(data.count)")
            
            var i = 1
            
            for im in data {
                
                let fname = source_url.deletingPathExtension().lastPathComponent
                let im_fname =  fname + "-" + String(format:"%03d", i) + "." + source_ext
                
                let im_url = URL(fileURLWithPath: source_root.absoluteString)
                let im_path = im_url.appending(path: im_fname)
                
                print("SPORK \(im_path)")

                let im_rsp = im.pngWrite(to: im_path)
                print("WOO \(im_rsp)")
                
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
            print(error)
            return false
        }
    }
}

if #available(macOS 14.0, *) {
    ImageEmbossCLI.main()
} else {
    throw(Errors.unsupportedOS)
}
