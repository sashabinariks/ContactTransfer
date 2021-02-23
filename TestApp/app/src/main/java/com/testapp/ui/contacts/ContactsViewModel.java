package com.testapp.ui.contacts;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.testapp.base.BaseViewModel;
import com.testapp.models.ContactData;
import com.testapp.models.ReceiveStatus;
import com.testapp.repository.ApplicationRepository;

import javax.inject.Inject;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;
import ua.naiksoftware.stomp.StompClient;

public class ContactsViewModel extends BaseViewModel {

    private MutableLiveData<ContactData> contactDataLiveData = new MutableLiveData<>();
    private MutableLiveData<ReceiveStatus> messageStatusLiveData = new MutableLiveData<>();

    private ApplicationRepository applicationRepository;
    private StompClient mStompClient;
    private Gson gson;

    @Inject
    public ContactsViewModel(ApplicationRepository applicationRepository, Gson gson) {
        this.applicationRepository = applicationRepository;
        this.gson = gson;
        mStompClient = applicationRepository.getStompClient();
    }

    public MutableLiveData<ContactData> subscribeContactMessages(String deviceId) {
        Disposable disposableSubscribeContactMessages = mStompClient.topic("/user/" + deviceId + "/messages")
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(stompMessage -> {
                            ContactData contact = deserializeJson(gson, stompMessage.getPayload(), new TypeToken<ContactData>() {
                            });
                            if (contact != null) {
                                contactDataLiveData.postValue(contact);
                            }
                        },
                        throwable -> errorLiveData.postValue("throwable"));

        disposable.add(disposableSubscribeContactMessages);
        return contactDataLiveData;
    }

    public void sendContacts(ContactData contact) {

        ContactData contactToSend = null;
        try {
            contactToSend = (ContactData)contact.clone();
            contactToSend.setImageDecoded(null);
        } catch (CloneNotSupportedException e) {
            errorLiveData.postValue(e.getMessage());
        }

        Disposable sendContact = mStompClient.send("/app/chat",  gson.toJson(contactToSend))
                .compose(applySchedulers())
                .subscribe(() -> {},
                        throwable -> errorLiveData.postValue("throwable"));

        disposable.add(sendContact);
    }

    public LiveData<ReceiveStatus> subscribeMessageStatus(String deviceId) {
        Disposable disposableSubscribeMessageStatus = mStompClient.topic("/user/" + deviceId + "/status")
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(stompMessage -> {
                            ReceiveStatus status = deserializeJson(gson, stompMessage.getPayload(), new TypeToken<ReceiveStatus>() {
                            });
                            if (status != null) {
                                messageStatusLiveData.postValue(status);
                            }
                        },
                        throwable -> errorLiveData.postValue("throwable"));

        disposable.add(disposableSubscribeMessageStatus);
        return messageStatusLiveData;
    }

    public void sendMessageStatus(ReceiveStatus status) {
        Disposable sendMessageStatus = mStompClient.send("/app/status",  gson.toJson(status))
                .compose(applySchedulers())
                .subscribe(() -> {},
                        throwable -> errorLiveData.postValue("throwable"));

        disposable.add(sendMessageStatus);
    }
}