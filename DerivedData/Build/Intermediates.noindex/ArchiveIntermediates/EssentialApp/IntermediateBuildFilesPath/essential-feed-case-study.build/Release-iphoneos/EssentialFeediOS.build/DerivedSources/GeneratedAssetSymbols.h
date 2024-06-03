#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "pin" asset catalog image resource.
static NSString * const ACImageNamePin AC_SWIFT_PRIVATE = @"pin";

#undef AC_SWIFT_PRIVATE