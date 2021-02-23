package com.testapp.models;

import android.graphics.Bitmap;

public class ContactData implements Cloneable {

    private String recipient;
    private String name;
    private String surname;
    private String phoneNumber;
    private String email;
    private String image;

    private int currentNumber;
    private int size;

    // Client-side
    private Bitmap imageDecoded;

    public ContactData() {
    }

    public ContactData(String recipient, String name, String surname, String phoneNumber, String email, String image, int currentNumber, int size) {
        this.recipient = recipient;
        this.name = name;
        this.surname = surname;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.image = image;
        this.currentNumber = currentNumber;
        this.size = size;
    }

    public String getRecipient() {
        return recipient;
    }

    public void setRecipient(String recipient) {
        this.recipient = recipient;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Bitmap getImageDecoded() {
        return imageDecoded;
    }

    public void setImageDecoded(Bitmap imageDecoded) {
        this.imageDecoded = imageDecoded;
    }

    public int getCurrentNumber() {
        return currentNumber;
    }

    public void setCurrentNumber(int currentNumber) {
        this.currentNumber = currentNumber;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
