package com.testapp.android;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.testapp.android.viewModel.ViewModelModule;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

@Module(includes = ViewModelModule.class)
public class AppModule {

    @Provides
    @Singleton
    Gson providesGson() {
        return new GsonBuilder().create();
    }
}
