InstagramPhotoPicker
====================

![Version](https://img.shields.io/cocoapods/v/TWPhotoPicker.svg)
![License](https://img.shields.io/cocoapods/l/TWPhotoPicker.svg)
![Platform](https://img.shields.io/cocoapods/p/TWPhotoPicker.svg)

Present Image Picker like Instagram

## Installation

With [CocoaPods](http://cocoapods.org/), add this line to your Podfile.

    pod 'TWPhotoPicker', '~> 1.0.0'

## Screenshots
![Example](./Screenshots/Screenshot01.png "Example")


## Usage

```objective-c
    TWPhotoPickerController *photoPicker = [[TWPhotoPickerController alloc] init];
    photoPicker.cropBlock = ^(UIImage *image) {
        //do something
    };
    [self presentViewController:photoPicker animated:YES completion:NULL];
```

## Requirements

- iOS 7 or higher
- Automatic Reference Counting (ARC)

## Author

- [wenzhaot](https://github.com/wenzhaot) ([@Wenzhaot](https://twitter.com/Wenzhaot))

## License

TWPhotoPicker is released under the MIT license. See the LICENSE file for more info.
