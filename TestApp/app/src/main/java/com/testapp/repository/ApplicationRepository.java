package com.testapp.repository;

import javax.inject.Inject;
import javax.inject.Singleton;

import ua.naiksoftware.stomp.StompClient;

@Singleton
public class ApplicationRepository {

    private StompClient mStompClient;

    @Inject
    public ApplicationRepository() { }

    public StompClient getStompClient() {
        return mStompClient;
    }

    public void setStompClient(StompClient stompClient) {
        this.mStompClient = stompClient;
    }
}
