import Foundation
import ArgumentParser
import AppKit
import ImageEmboss

public enum Errors: Error {
    case notFound
    case invalidImage
    case cgImage
    case processError
    case unsupportedOS
}

@available(macOS 14.0, *)
struct ImageEmbossCLI: ParsableCommand {

    @Argument(help:"The path to an image file to extract image subjects from  ")
    var inputFile: String
    
    func run() throws {
        
        let fm = FileManager.default
        
        if (!fm.fileExists(atPath: inputFile)){
            throw(Errors.notFound)
        }
        
        guard let im = NSImage(byReferencingFile:inputFile) else {
            throw(Errors.invalidImage)
        }
        
        guard let cgImage = im.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw(Errors.cgImage)
        }
        
        let ic = ImageEmboss()
        let rsp = ic.ProcessImage(image: cgImage, combined: true)
        
        switch rsp {
        case .failure(let error):
            throw(error)
        case .success(let data):

            print(data)
        }
        
    }
}

if #available(macOS 14.0, *) {
    ImageEmbossCLI.main()
} else {
    throw(Errors.unsupportedOS)
}
