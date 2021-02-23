package com.testapp.android.viewModel;

import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelProvider;

import com.testapp.ui.MainActivityViewModel;
import com.testapp.ui.contacts.ContactsViewModel;
import com.testapp.ui.list.DeviceListViewModel;

import dagger.Binds;
import dagger.Module;
import dagger.multibindings.IntoMap;

@Module
public abstract class ViewModelModule {

    @Binds
    @IntoMap
    @ViewModelKey(DeviceListViewModel.class)
    abstract ViewModel bindDeviceListViewModel(DeviceListViewModel deviceListViewModel);

    @Binds
    @IntoMap
    @ViewModelKey(ContactsViewModel.class)
    abstract ViewModel bindContactsViewModel(ContactsViewModel contactsViewModel);

    @Binds
    @IntoMap
    @ViewModelKey(MainActivityViewModel.class)
    abstract ViewModel bindMainActivityViewModel(MainActivityViewModel mainActivityViewModel);

    @Binds
    abstract ViewModelProvider.Factory bindViewModelFactory(AppViewModelFactory factory);

}
