package com.testapp.android;

import android.app.Application;

import com.testapp.AppApplication;
import com.testapp.ui.MainActivity;
import com.testapp.ui.contacts.ContactsFragment;
import com.testapp.ui.list.DeviceListFragment;

import dagger.Binds;
import dagger.Module;
import dagger.android.ContributesAndroidInjector;

@Module
public abstract class BuildersModule {

    @Binds
    abstract Application bindApplication(AppApplication application);

    // Activities
    @ContributesAndroidInjector()
    abstract MainActivity bindMainActivity();

    // Fragments
    @ContributesAndroidInjector()
    abstract DeviceListFragment bindDeviceListFragment();
    @ContributesAndroidInjector()
    abstract ContactsFragment bindContactsFragment();

}