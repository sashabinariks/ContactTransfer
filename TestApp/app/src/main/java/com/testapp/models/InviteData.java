package com.testapp.models;

public class InviteData {

    private String destinationDeviceId;
    private String deviceId;
    private String displayName;
    private Boolean accepted;

    public InviteData(String destinationDeviceId, String deviceId, String displayName, Boolean isAccepted) {
        this.destinationDeviceId = destinationDeviceId;
        this.deviceId = deviceId;
        this.displayName = displayName;
        this.accepted = isAccepted;
    }

    public String getDestinationDeviceId() {
        return destinationDeviceId;
    }

    public void setDestinationDeviceId(String destinationDeviceId) {
        this.destinationDeviceId = destinationDeviceId;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public Boolean getAccepted() {
        return accepted;
    }

    public void setAccepted(Boolean accepted) {
        this.accepted = accepted;
    }
}
