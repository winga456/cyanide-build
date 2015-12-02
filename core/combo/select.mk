#
# Copyright (C) 2006 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Select a combo based on the compiler being used.
#
# Inputs:
#	combo_target -- prefix for final variables (HOST_ or TARGET_)
#	combo_2nd_arch_prefix -- it's defined if this is loaded for the 2nd arch.
#

# Build a target string like "linux-arm" or "darwin-x86".
combo_os_arch := $($(combo_target)OS)-$($(combo_target)$(combo_2nd_arch_prefix)ARCH)

combo_var_prefix := $(combo_2nd_arch_prefix)$(combo_target)

# Set reasonable defaults for the various variables

$(combo_var_prefix)CC := $(CC)
$(combo_var_prefix)CXX := $(CXX)
$(combo_var_prefix)AR := $(AR)
$(combo_var_prefix)STRIP := $(STRIP)

ifeq ($(USE_O3_OPTIMIZATIONS),true)
$(combo_var_prefix)GLOBAL_CFLAGS := -O3 -DNDEBUG -ffunction-sections -fdata-sections -funswitch-loops -fomit-frame-pointer -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-maybe-uninitialized -fno-exceptions -fno-exceptions -Wno-multichar
$(combo_var_prefix)RELEASE_CFLAGS := -O3 -DNDEBUG -ffunction-sections -fdata-sections -funswitch-loops -fomit-frame-pointer -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-maybe-uninitialized
$(combo_var_prefix)GLOBAL_CPPFLAGS := -O3 -DNDEBUG -ffunction-sections -fdata-sections -funswitch-loops -fomit-frame-pointer -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-maybe-uninitialized
$(combo_var_prefix)GLOBAL_LDFLAGS := -Wl,-O1 -Wl,--as-needed -Wl,--relax -Wl,--sort-common -Wl,--gc-sections
else
ifeq ($(OFAST_OPTS),true)
$(combo_var_prefix)GLOBAL_CFLAGS := -Ofast -DNDEBUG -pipe -fivopts -ffunction-sections -fdata-sections -funswitch-loops -fomit-frame-pointer -ftracer -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-maybe-uninitialized -fno-exceptions -Wno-multichar $(call cc-option,$(-fira-loop-pressure,-fforce-addr,-funsafe-loop-optimizations,-funroll-loops,-ftree-loop-distribution,-fsection-anchors,-ftree-loop-im,-ftree-loop-ivcanon,-ffunction-sections,-fgcse-las,-fgcse-sm,-fweb,-ffp-contract=fast,-fgraphite,-floop-flatten,-floop-parallelize-all,-ftree-loop-linear,-floop-interchange,-floop-strip-mine,-floop-block))
$(combo_var_prefix)RELEASE_CFLAGS := -Ofast -DNDEBUG -pipe -fivopts -ffunction-sections -fdata-sections -funswitch-loops -fomit-frame-pointer -ftracer -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-maybe-uninitialized -fno-strict-aliasing $(call cc-option,$(-fira-loop-pressure,-fforce-addr,-funsafe-loop-optimizations,-funroll-loops,-ftree-loop-distribution,-fsection-anchors,-ftree-loop-im,-ftree-loop-ivcanon,-ffunction-sections,-fgcse-las,-fgcse-sm,-fweb,-ffp-contract=fast,-fgraphite,-floop-flatten,-floop-parallelize-all,-ftree-loop-linear,-floop-interchange,-floop-strip-mine,-floop-block))
$(combo_var_prefix)GLOBAL_CPPFLAGS := -Ofast -DNDEBUG -pipe -fivopts -ffunction-sections -fdata-sections -funswitch-loops -fomit-frame-pointer -ftracer -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-maybe-uninitialized $(call cpp-option,$(-fira-loop-pressure,-fforce-addr,-funsafe-loop-optimizations,-funroll-loops,-ftree-loop-distribution,-fsection-anchors,-ftree-loop-im,-ftree-loop-ivcanon,-ffunction-sections,-fgcse-las,-fgcse-sm,-fweb,-ffp-contract=fast,-fgraphite,-floop-flatten,-floop-parallelize-all,-ftree-loop-linear,-floop-interchange,-floop-strip-mine,-floop-block))
$(combo_var_prefix)GLOBAL_LDFLAGS := -Wl,-O1 -Wl,--as-needed -Wl,--relax -Wl,--sort-common -Wl,--gc-sections
else
$(combo_var_prefix)GLOBAL_CFLAGS := -fno-exceptions -Wno-multichar
$(combo_var_prefix)RELEASE_CFLAGS := -O2 -g
$(combo_var_prefix)GLOBAL_CPPFLAGS :=
$(combo_var_prefix)GLOBAL_LDFLAGS :=
endif
endif

$(combo_var_prefix)GLOBAL_ARFLAGS := crsPD
$(combo_var_prefix)GLOBAL_LD_DIRS :=

$(combo_var_prefix)EXECUTABLE_SUFFIX :=
$(combo_var_prefix)SHLIB_SUFFIX := .so
$(combo_var_prefix)JNILIB_SUFFIX := $($(combo_var_prefix)SHLIB_SUFFIX)
$(combo_var_prefix)STATIC_LIB_SUFFIX := .a

# Now include the combo for this specific target.
include $(BUILD_COMBOS)/$(combo_target)$(combo_os_arch).mk
