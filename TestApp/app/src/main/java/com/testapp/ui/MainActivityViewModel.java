package com.testapp.ui;

import com.google.gson.Gson;
import com.testapp.base.BaseViewModel;
import com.testapp.repository.ApplicationRepository;

import javax.inject.Inject;

import io.reactivex.disposables.Disposable;
import ua.naiksoftware.stomp.StompClient;

public class MainActivityViewModel  extends BaseViewModel {

    private ApplicationRepository applicationRepository;

    private StompClient mStompClient;
    private Gson gson;

    @Inject
    public MainActivityViewModel(ApplicationRepository applicationRepository, Gson gson) {
        this.applicationRepository = applicationRepository;
        this.gson = gson;
        mStompClient = applicationRepository.getStompClient();

    }

    public void unregisterDevice(String deviceId) {
//        new Gson().toJson(new DeviceInfo(deviceId, null))
        mStompClient = applicationRepository.getStompClient();
        Disposable unregisterDevice = mStompClient.send("/app/unregister", deviceId)
                .compose(applySchedulers())
                .subscribe(() -> {errorLiveData.postValue("unregister");},
                        throwable -> errorLiveData.postValue("throwable"));

        disposable.add(unregisterDevice);
    }
}
