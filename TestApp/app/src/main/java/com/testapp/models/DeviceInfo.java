package com.testapp.models;

import com.google.gson.annotations.SerializedName;

public class DeviceInfo {

    private String deviceId;
    @SerializedName("displayName")
    private String deviceName;

    public DeviceInfo(String deviceId, String deviceName) {
        this.deviceId = deviceId;
        this.deviceName = deviceName;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }
}
