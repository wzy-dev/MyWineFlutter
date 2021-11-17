#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CameraPermissions.h"
#import "CameraPreview.h"
#import "CamerawesomePlugin.h"
#import "CameraFlash.h"
#import "CameraQualities.h"
#import "CameraSensor.h"
#import "CaptureModes.h"
#import "ImageStreamController.h"
#import "MotionController.h"
#import "CameraPictureController.h"
#import "VideoController.h"

FOUNDATION_EXPORT double camerawesomeVersionNumber;
FOUNDATION_EXPORT const unsigned char camerawesomeVersionString[];

