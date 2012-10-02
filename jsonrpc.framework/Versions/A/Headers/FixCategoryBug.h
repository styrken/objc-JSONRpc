//
//  FixCategoryBug.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 02/10/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#ifndef objc_JSONRpc_FixCategoryBug_h
#define objc_JSONRpc_FixCategoryBug_h

/*
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only contain
 categories and no classes.
 See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.
 
 Shamelessly borrowed from Three20
 */
#define FIX_CATEGORY_BUG(name) @interface FIX_CATEGORY_BUG##name @end \
@implementation FIX_CATEGORY_BUG##name @end

#endif

