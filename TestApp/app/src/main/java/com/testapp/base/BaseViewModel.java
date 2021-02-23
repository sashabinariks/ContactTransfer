package com.testapp.base;

import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import io.reactivex.CompletableTransformer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.schedulers.Schedulers;

public class BaseViewModel extends ViewModel {

    protected boolean isViewModelCleared = false;
    protected CompositeDisposable disposable = new CompositeDisposable();

    protected MutableLiveData<String> errorLiveData = new MutableLiveData<>();

    public MutableLiveData<String> getErrorLiveData() {
        return errorLiveData;
    }

    public CompletableTransformer applySchedulers() {
        return upstream -> upstream
                .unsubscribeOn(Schedulers.newThread())
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread());
    }

    protected <T> T deserializeJson(Gson gson, String sourceJson, TypeToken<T> typeToken) {
        T result;
        try {
            result = gson.fromJson(sourceJson, typeToken.getType());
            return result;
        } catch (Exception e) {
            errorLiveData.postValue("deserialization error: " + typeToken.getRawType().getCanonicalName());
        }
        return null;
    }

    @Override
    protected void onCleared() {
        if (disposable != null) {
            disposable.dispose();
        }
        isViewModelCleared = true;
    }
}
