package com.testapp.ui.list;

import androidx.lifecycle.MutableLiveData;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.testapp.base.BaseViewModel;
import com.testapp.models.DeviceInfo;
import com.testapp.models.InviteData;
import com.testapp.models.RegistrationData;
import com.testapp.repository.ApplicationRepository;
import com.testapp.utils.Event;

import java.util.List;

import javax.inject.Inject;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;
import ua.naiksoftware.stomp.Stomp;
import ua.naiksoftware.stomp.StompClient;

public class DeviceListViewModel extends BaseViewModel {

    public static final String SOCKET_URL = "ws://test-env-2.eba-3e7rpc8d.us-east-1.elasticbeanstalk.com/ws";

    private MutableLiveData<String> stompStatusLiveData = new MutableLiveData<>();
    private MutableLiveData<List<DeviceInfo>> devicesLiveData = new MutableLiveData<>();
    private MutableLiveData<Event<InviteData>> inviteLiveData = new MutableLiveData<>();

    private final ApplicationRepository applicationRepository;
    private StompClient mStompClient;
    private Gson gson;

    @Inject
    public DeviceListViewModel(ApplicationRepository applicationRepository, Gson gson) {
        this.applicationRepository = applicationRepository;
        this.gson = gson;
        mStompClient = applicationRepository.getStompClient();
    }

    /**
     * Live data
     */

    public MutableLiveData<String> getStompStatusLiveData() {
        return stompStatusLiveData;
    }

    public MutableLiveData<List<DeviceInfo>> getDevicesLiveData() {
        return devicesLiveData;
    }

    public MutableLiveData<Event<InviteData>> getInviteLiveData() {
        return inviteLiveData;
    }

    /**
     * Client staff
     */

    protected void setUpStompConnection(String deviceId, String deviceName) {
        initStompClient(deviceId);
        registerUser(deviceId, deviceName);
    }

    private void initStompClient(String deviceId) {
        disposable = new CompositeDisposable();
        mStompClient = Stomp.over(Stomp.ConnectionProvider.OKHTTP, SOCKET_URL);
        mStompClient.connect();
        applicationRepository.setStompClient(mStompClient);

        mStompClient.withClientHeartbeat(1000).withServerHeartbeat(1000);

        Disposable disposableClientLifecycle = mStompClient.lifecycle()
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(lifecycleEvent -> {
                    switch (lifecycleEvent.getType()) {
                        case OPENED:
                            stompStatusLiveData.postValue("Stomp connection opened");
                            subscribeInvites(deviceId);
                            break;

                        case ERROR:
                            stompStatusLiveData.postValue("Error");
                            break;

                        case CLOSED:
                            stompStatusLiveData.postValue("Stomp connection closed");
                            break;
                    }
                }, throwable -> stompStatusLiveData.postValue("throwable"));

        disposable.add(disposableClientLifecycle);
    }

    /**
     * Registration
     */

    private void registerUser(String deviceId, String deviceName) {
        RegistrationData credentials = new RegistrationData();
        credentials.setDeviceId(deviceId);
        credentials.setDisplayName(deviceName);

        Disposable disposableSubscribeDevices = mStompClient.topic("/topic/public")
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(stompMessage -> {
                            List<DeviceInfo> listDevices = deserializeJson(gson, stompMessage.getPayload(), new TypeToken<List<DeviceInfo>>() {
                            });
                            if (listDevices != null) {
                                devicesLiveData.postValue(listDevices);
                            }
                        },
                        throwable -> errorLiveData.postValue("throwable"));

        disposable.add(disposableSubscribeDevices);

        Disposable disposableRegistration = mStompClient.send("/app/register", gson.toJson(credentials))
                .compose(applySchedulers())
                .subscribe(() -> {
                        },
                        throwable -> errorLiveData.postValue("throwable"));

        disposable.add(disposableRegistration);
    }

    /**
     * Invites
     */

    public void subscribeInvites(String deviceId) {
        Disposable disposableSubscribeInvites = mStompClient.topic("/user/" + deviceId + "/invite")
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(stompMessage -> {
                            InviteData invite = deserializeJson(gson, stompMessage.getPayload(), new TypeToken<InviteData>() {
                            });
                            if (invite != null) {
                                inviteLiveData.postValue(new Event<>(invite));
                            }
                        },
                        throwable -> errorLiveData.postValue("throwable"));

        disposable.add(disposableSubscribeInvites);
    }

    public void sendInvite(InviteData invite) {
        Disposable disposableSendInvite = mStompClient.send("/app/invite", gson.toJson(invite))
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(() -> {
                });
        disposable.add(disposableSendInvite);
    }
}