INCLUDEPATH += $$PWD/include

win32* {
    DEFINES += SDL_WIN
    DEFINES += SDL_MAIN_HANDLED
}

win32-g++* {
    LIBS += -L$$PWD/bin/windows/mingw/ -lSDL2
}

win32-msvc* {
    contains (QMAKE_TARGET.arch, x86_64) {
        LIBS += -L$$PWD/bin/windows/msvc/x64/ -lSDL2
    }

    else {
        LIBS += -L$$PWD/bin/windows/msvc/x86/ -lSDL2
    }
}

macx* {
    LIBS += -L$$PWD/bin/mac-osx/ -lSDL2

    LIBS += -framework AudioToolbox
    LIBS += -framework AudioUnit
    LIBS += -framework Cocoa
    LIBS += -framework CoreAudio
    LIBS += -framework IOKit
    LIBS += -framework OpenGL
    LIBS += -framework CoreFoundation
    LIBS += -framework Carbon
    LIBS += -framework ForceFeedback
    LIBS += -framework CoreVideo

    QMAKE_LFLAGS += -F /System/Library/Frameworks/AudioToolbox.framework/
    QMAKE_LFLAGS += -F /System/Library/Frameworks/AudioUnit.framework/
    QMAKE_LFLAGS += -F /System/Library/Frameworks/Cocoa.framework/
    QMAKE_LFLAGS += -F /System/Library/Frameworks/CoreAudio.framework/
    QMAKE_LFLAGS += -F /System/Library/Frameworks/IOKit.framework/
    QMAKE_LFLAGS += -F /System/Library/Frameworks/OpenGL.framework/
    QMAKE_LFLAGS += -F /System/Library/Frameworks/CoreFoundation.framework/
    QMAKE_LFLAGS += -F /System/Library/Frameworks/Carbon.framework/
    QMAKE_LFLAGS += -F /System/Library/Frameworks/ForceFeedback.framework/
    QMAKE_LFLAGS += -F /System/Library/Frameworks/CoreVideo.framework/
}

linux:!android {
    LIBS += -lSDL2
}

android {
    QMAKE_CFLAGS += -DGL_GLEXT_PROTOTYPES
    QMAKE_LFLAGS += -ldl -lGLESv1_CM -lGLESv2 -llog -landroid
    
    equals (ANDROID_TARGET_ARCH, x86_64) { 
        LIBS += $$PWD/bin/android/x86_64/libSDL2.so
        ANDROID_EXTRA_LIBS += $$PWD/bin/android/x86_64/libSDL2.so
    }

    equals (ANDROID_TARGET_ARCH, mips64) { 
        LIBS += $$PWD/bin/android/mips64/libSDL2.so
        ANDROID_EXTRA_LIBS += $$PWD/bin/android/mips64/libSDL2.so
    }

    equals (ANDROID_TARGET_ARCH, arm64-v8a) { 
        LIBS += $$PWD/bin/android/arm64-v8a/libSDL2.so
        ANDROID_EXTRA_LIBS += $$PWD/bin/android/arm64-v8a/libSDL2.so
    }

    equals (ANDROID_TARGET_ARCH, armeabi-v7a) { 
        LIBS += $$PWD/bin/android/armeabi-v7a/libSDL2.so
        ANDROID_EXTRA_LIBS += $$PWD/bin/android/armeabi-v7a/libSDL2.so
    }
}
