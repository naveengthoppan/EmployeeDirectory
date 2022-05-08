//
//  ImageService.swift
//  EmployeeDirectory
//
//  Created by Naveen George Thoppan on 03/05/2022.
//

import UIKit

final class ImageService {
    private struct CachedImage {
        let url: URL
        let data: Data
    }
    
    private struct CachedRequest: Cancellable {
        func cancel() {
            
        }
    }
    
    private var cache: [CachedImage] = []
    
    private let maximumCacheSize: Int
    
    private var imageCacheDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache")
    }
    
    init(maximumCacheSize: Int) {
        self.maximumCacheSize = maximumCacheSize
        
        createImageCacheDirectory()
    }
    
    func image(for url: URL, completion: @escaping (UIImage?) -> Void) -> Cancellable {
        
        if let image = cachedImage(for: url) {
            completion(image)
            return CachedRequest()
        }
        
        print(url)
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            
            var image: UIImage?
                
                if let data = data {
                    image = UIImage(data: data)
                    
                    self?.cacheImage(data, url: url)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
        }
        
        dataTask.resume()
        
        return dataTask
    }
    
    private func cachedImage(for url: URL) -> UIImage? {
        if let data = cache.first(where: { $0.url == url })?.data  {
            print("Using Cache in Memory")
            return UIImage(data: data)
        } else if let data = try? Data(contentsOf: locationOnDisk(for: url)) {
            print("Using Cache on Disk")
            cacheImage(data, url: url, writeToDisk: false)
            return UIImage(data: data)
        }
        return nil
    }
    
    private func cacheImage(_ data: Data, url: URL, writeToDisk: Bool = true) {
        
        var cacheSize = cache.reduce(0) { result, cachedImage -> Int in
            result + cachedImage.data.count
        }
        
        while cacheSize > maximumCacheSize {
            
            let oldestCachedImage = cache.removeFirst()
            
            cacheSize -= oldestCachedImage.data.count
        }
        let cachedImage = CachedImage(url: url, data: data)
        
        cache.append(cachedImage)
        
        DispatchQueue.global(qos: .utility).async {
            self.writeImageToDisk(data, for: url)
        }
        
    }
    
    private func createImageCacheDirectory() {
        do {
            try FileManager.default.createDirectory(at: imageCacheDirectory, withIntermediateDirectories: true)
            
        } catch {
            print("unable to create image cache directory")
        }
    }
    
    private func locationOnDisk(for url: URL) -> URL {
        
        let fileName = Data(url.absoluteString.utf8).base64EncodedString()
        return imageCacheDirectory.appendingPathComponent(fileName)
    }
    
    private func writeImageToDisk(_ data: Data, for url: URL) {
        do {
            try data.write(to: locationOnDisk(for: url))
        } catch {
            print("Unable to Write Image to Disk \(error)")
        }
    }
}
