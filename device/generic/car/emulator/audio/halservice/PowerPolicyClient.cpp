/*
 * Copyright (C) 2021 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

 #define LOG_TAG "AudioPowerPolicyClient"

#include "PowerPolicyClient.h"
#include "AudioControl.h"

#include <android-base/logging.h>

namespace aidl {
namespace android {
namespace hardware {
namespace automotive {
namespace audiocontrol {

namespace aafap = ::aidl::android::frameworks::automotive::powerpolicy;

using aafap::CarPowerPolicy;
using aafap::CarPowerPolicyFilter;
using aafap::PowerComponent;
using ::android::frameworks::automotive::powerpolicy::hasComponent;
using ::ndk::ScopedAStatus;

namespace {

constexpr PowerComponent kAudioComponent = PowerComponent::AUDIO;

}  // namespace

PowerPolicyClient::PowerPolicyClient(const std::shared_ptr<AudioControl>& audioControl)
    : mAudioControl(audioControl) {}

void PowerPolicyClient::onInitFailed() {
    LOG(ERROR) << "Initializing power policy client failed";
}

std::vector<PowerComponent> PowerPolicyClient::getComponentsOfInterest() {
    std::vector<PowerComponent> components{kAudioComponent};
    return components;
}

ScopedAStatus PowerPolicyClient::onPolicyChanged(const CarPowerPolicy& powerPolicy) {
    if (hasComponent(powerPolicy.enabledComponents, kAudioComponent)) {
        mAudioControl->setAudioEnabled(true);
    } else if (hasComponent(powerPolicy.disabledComponents, kAudioComponent)) {
        mAudioControl->setAudioEnabled(false);
    }

    return ScopedAStatus::ok();
}

}  // namespace audiocontrol
}  // namespace automotive
}  // namespace hardware
}  // namespace android
}  // namespace aidl
