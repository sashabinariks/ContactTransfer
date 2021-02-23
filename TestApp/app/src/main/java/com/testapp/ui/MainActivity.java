package com.testapp.ui;

import android.os.Bundle;
import android.widget.Toast;

import androidx.lifecycle.ViewModelProvider;

import com.testapp.R;
import com.testapp.android.viewModel.AppViewModelFactory;
import com.testapp.base.BaseActivity;
import com.testapp.ui.list.DeviceListFragment;

import javax.inject.Inject;

public class MainActivity extends BaseActivity {

    private MainActivityViewModel mViewModel;
    @Inject AppViewModelFactory appViewModelFactory;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        addFragment(R.id.frame_fragment_container, DeviceListFragment.newInstance(), DeviceListFragment.FRAGMENT_TAG);

        initViewModel();
    }

    private void initViewModel() {
        mViewModel = new ViewModelProvider(this, appViewModelFactory).get(MainActivityViewModel.class);
        mViewModel.getErrorLiveData().observe(this, s -> Toast.makeText(MainActivity.this, s, Toast.LENGTH_SHORT).show());
    }

//    @Override
//    protected void onPause() {
//        super.onPause();
//        mViewModel.unregisterDevice(DeviceUtils.getAndroidId(this));
//    }

}