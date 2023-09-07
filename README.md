# swift-image-classify-cli

Command line tool for extracting subject images from images using Apple's Vision framework.

## Important

This tool requires Mac OS 14.0 or higher.

## Documentation

Documentation is incomplete.

## Example

All of the images in these examples are included in the [fixtures](fixtures) directory.

```
$> swift build
```

Given the image [fixtures/walrus.jpg](https://collection.sfomuseum.org/objects/1511908311/):

[![](fixtures/walrus.jpg)](https://collection.sfomuseum.org/objects/1511908311/)

When we run the `image-emboss` tool like this:

```
$> ./.build/debug/image-emboss --input-file fixtures/walrus.jpg
```

A new file named `fixtures/walrus-emboss-001.png` will be created:

![](fixtures/walrus-emboss-001.png)

## See also

* https://collection.sfomuseum.org/objects/1511908311/
* https://github.com/sfomuseum/swift-image-emboss
* https://developer.apple.com/documentation/vision
* https://developer.apple.com/videos/play/wwdc2023/10176/
