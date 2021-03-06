// Copyright (C) 2020 The Android Open Source Project
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#pragma once

#include <memory>

#include "public/audio_proxy.h"

// clang-format off
#include PATH(android/hardware/audio/FILE_VERSION/types.h)
#include PATH(android/hardware/audio/common/FILE_VERSION/types.h)
// clang-format on

namespace audio_proxy {
namespace AUDIO_PROXY_CPP_VERSION {

using ::android::hardware::hidl_bitfield;
using namespace ::android::hardware::audio::CPP_VERSION;
using namespace ::android::hardware::audio::common::CPP_VERSION;

class AudioProxyStreamOut;

// C++ friendly wrapper of audio_proxy_device.
class AudioProxyDevice final {
 public:
  explicit AudioProxyDevice(audio_proxy_device_t* device);
  ~AudioProxyDevice();

  const char* getAddress();

  Result openOutputStream(hidl_bitfield<AudioOutputFlag> flags,
                          const AudioConfig& config,
                          std::unique_ptr<AudioProxyStreamOut>* streamOut,
                          AudioConfig* configOut);

 private:
  audio_proxy_device_t* const mDevice;
};

}  // namespace AUDIO_PROXY_CPP_VERSION
}  // namespace audio_proxy
