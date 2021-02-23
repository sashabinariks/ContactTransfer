package com.testapp.ui.list;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.testapp.BuildConfig;
import com.testapp.R;
import com.testapp.adapters.AdapterOnlineDevices;
import com.testapp.android.viewModel.AppViewModelFactory;
import com.testapp.base.BaseFragment;
import com.testapp.databinding.FragmentDeviceListBinding;
import com.testapp.dialogs.InviteBottomSheetDialog;
import com.testapp.models.DeviceInfo;
import com.testapp.models.InviteData;
import com.testapp.ui.contacts.ContactsFragment;
import com.testapp.utils.DeviceUtils;
import com.testapp.utils.Event;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.inject.Inject;

public class DeviceListFragment extends BaseFragment {

    public static final String FRAGMENT_TAG =
            BuildConfig.APPLICATION_ID + ".DeviceListFragment";

    @Inject AppViewModelFactory appViewModelFactory;
    private DeviceListViewModel mViewModel;
    private FragmentDeviceListBinding binding;

    private String myDeviceId;
    private String myDeviceName;

    private RecyclerView rvOnlineDevices;
    private AdapterOnlineDevices adapterOnlineDevices;
    private List<DeviceInfo> listDeviceInfo = new ArrayList<>();

    public static DeviceListFragment newInstance() {
        return new DeviceListFragment();
    }

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        binding = FragmentDeviceListBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    protected void onViewReady(View inflatedView, Bundle args) {

        myDeviceId = DeviceUtils.getAndroidId(parentActivity);
        myDeviceName = DeviceUtils.getDeviceName();

        showDeviceInfo();
        setupDevicesRecycler();
    }

    private void setupDevicesRecycler() {
        rvOnlineDevices = binding.rvDeviceList;
        rvOnlineDevices.setLayoutManager(new LinearLayoutManager(getContext()));
        adapterOnlineDevices = new AdapterOnlineDevices(getContext(), listDeviceInfo);
        adapterOnlineDevices.setClickListener(deviceId -> {
            toast("Sending invite...");
            mViewModel.sendInvite(new InviteData(deviceId, myDeviceId, myDeviceName, null));
        });
        rvOnlineDevices.setAdapter(adapterOnlineDevices);
    }

    @Override
    protected void setupListeners() {
        binding.btnConnect.setOnClickListener(v -> mViewModel.setUpStompConnection(myDeviceId, myDeviceName));
    }

    @Override
    protected void initViewModels() {
        mViewModel = new ViewModelProvider(this, appViewModelFactory).get(DeviceListViewModel.class);
        mViewModel.getStompStatusLiveData().observe(getViewLifecycleOwner(), this::toast);
        mViewModel.getDevicesLiveData().observe(getViewLifecycleOwner(), this::updateUsers);
        mViewModel.getInviteLiveData().observe(getViewLifecycleOwner(), this::processInvite);
    }

    private void processInvite(Event<InviteData> inviteEvent) {
        if (inviteEvent.hasBeenHandled()) {
            return;
        }
        InviteData invite = inviteEvent.getContentIfNotHandled();
        if (invite != null && invite.getAccepted() != null) {
            if (invite.getAccepted()) {
                toast(String.format(getResources().getString(R.string.invite_feedback), invite.getDisplayName(), "accepted"));
                openContactsScreen(invite, false);
            } else {
                toast(String.format(getResources().getString(R.string.invite_feedback), invite.getDisplayName(), "declined"));
            }
        } else {
            InviteBottomSheetDialog inviteDialog = InviteBottomSheetDialog.newInstance(invite, new DeviceInfo(myDeviceId, myDeviceName), feedbackInvite -> {
                mViewModel.sendInvite(feedbackInvite);
                if (feedbackInvite.getAccepted()) {
                    openContactsScreen(invite, true);
                }
            });
            inviteDialog.show(getFragmentManager(), null);
        }
    }

    private void openContactsScreen(InviteData invite, boolean isTarget) {
        parentActivity.replaceFragment(R.id.frame_fragment_container, ContactsFragment.newInstance(new DeviceInfo(invite.getDeviceId(), invite.getDisplayName()), isTarget), ContactsFragment.FRAGMENT_TAG, null);
    }

    private void showDeviceInfo() {
        binding.tvDeviceInfo.setText(String.format(getResources().getString(R.string.device_info), myDeviceId, myDeviceName));
    }

    private void updateUsers(List<DeviceInfo> listDevices) {
        Iterator<DeviceInfo> deviceIterator = listDevices.iterator();
        while (deviceIterator.hasNext()) {
            DeviceInfo info = deviceIterator.next();
            if (info.getDeviceId().equals(myDeviceId)) {
                deviceIterator.remove();
            }
        }

        listDeviceInfo.clear();
        listDeviceInfo.addAll(listDevices);
        adapterOnlineDevices.notifyDataSetChanged();

    }
}