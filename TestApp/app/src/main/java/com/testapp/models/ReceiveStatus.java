package com.testapp.models;

public class ReceiveStatus {

    private String destinationDeviceId;
    private int numberMessage;
    private boolean status;

    public ReceiveStatus() {
    }

    public ReceiveStatus(String destinationDeviceId, int numberMessage, boolean status) {
        this.destinationDeviceId = destinationDeviceId;
        this.numberMessage = numberMessage;
        this.status = status;
    }

    public String getDestinationDeviceId() {
        return destinationDeviceId;
    }

    public void setDestinationDeviceId(String destinationDeviceId) {
        this.destinationDeviceId = destinationDeviceId;
    }

    public int getNumberMessage() {
        return numberMessage;
    }

    public void setNumberMessage(int numberMessage) {
        this.numberMessage = numberMessage;
    }

    public boolean isReceived() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
