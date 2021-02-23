package com.testapp.ui.contacts;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.text.TextUtils;
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
import com.testapp.adapters.AdapterContacts;
import com.testapp.android.viewModel.AppViewModelFactory;
import com.testapp.base.BaseFragment;
import com.testapp.databinding.FragmentContactsBinding;
import com.testapp.dialogs.LoadingInfoDialog;
import com.testapp.models.ContactData;
import com.testapp.models.DeviceInfo;
import com.testapp.models.ReceiveStatus;
import com.testapp.utils.BitmapUtils;
import com.testapp.utils.DeviceUtils;
import com.testapp.utils.GC;
import com.testapp.utils.PermissionUtil;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

public class ContactsFragment extends BaseFragment {

    public static final String FRAGMENT_TAG =
            BuildConfig.APPLICATION_ID + ".ContactsFragment";

    private ContactsViewModel mViewModel;
    @Inject AppViewModelFactory appViewModelFactory;

    private FragmentContactsBinding binding;

    private RecyclerView rvPhoneContacts;
    private AdapterContacts adapterContacts;
    private List<ContactData> listContacts = new ArrayList<>();
    private List<ContactData> listContactsToSend = new ArrayList<>();

    private DeviceInfo connectedDeviceInfo;
    private boolean isTarget;

    private LoadingInfoDialog loadingDialog;

    public static ContactsFragment newInstance(DeviceInfo connectedDeviceInfo, boolean isTarget) {
        ContactsFragment fragment = new ContactsFragment();
        fragment.connectedDeviceInfo = connectedDeviceInfo;
        fragment.isTarget = isTarget;
        return fragment;
    }

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        binding = FragmentContactsBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    protected void onViewReady(View inflatedView, Bundle args) {
        if (isTarget) {
            binding.tvConnectionInfo.setText(String.format(getResources().getString(R.string.connection_details), "receiving (TARGET)", "from", connectedDeviceInfo.getDeviceName()));
        } else {
            binding.tvConnectionInfo.setText(String.format(getResources().getString(R.string.connection_details), "sending (SOURCE)", "to", connectedDeviceInfo.getDeviceName()));
        }

        setupContactsRecycler();
    }

    @Override
    protected void setupListeners() {
        binding.btnSendAll.setOnClickListener(v -> sendAllContacts());
    }

    @Override
    protected void initViewModels() {
        mViewModel = new ViewModelProvider(this, appViewModelFactory).get(ContactsViewModel.class);
        if (isTarget) {
            mViewModel.subscribeContactMessages(DeviceUtils.getAndroidId(parentActivity)).observe(getViewLifecycleOwner(), this::updateContacts);
        } else {
            mViewModel.subscribeMessageStatus(DeviceUtils.getAndroidId(parentActivity)).observe(getViewLifecycleOwner(), receiveStatus -> {
                showProgressDialog(listContactsToSend.get(receiveStatus.getNumberMessage() - 1));
                if (receiveStatus.isReceived() && !(receiveStatus.getNumberMessage() == listContactsToSend.size()) && listContactsToSend.size() > 1) {
                    ContactData nextContact = listContactsToSend.get(receiveStatus.getNumberMessage());
                    sendSingleContact(nextContact, nextContact.getCurrentNumber(), nextContact.getSize());
                }
            });
        }
    }

    private void setupContactsRecycler() {
        rvPhoneContacts = binding.rvPhoneContacts;
        rvPhoneContacts.setLayoutManager(new LinearLayoutManager(getContext()));
        adapterContacts = new AdapterContacts(getContext(), listContacts);
        if (!isTarget) {
            adapterContacts.setClickListener(contact -> {
                listContactsToSend.clear();
                listContactsToSend.add(contact);
                sendSingleContact(contact, 1,1);
            });
        }
        rvPhoneContacts.setAdapter(adapterContacts);

        if (!isTarget) {
            if (PermissionUtil.shouldAskForPermission(parentActivity, Manifest.permission.READ_CONTACTS)) {
                PermissionUtil.requestPermissions(this, new String[]{Manifest.permission.READ_CONTACTS}, GC.READ_CONTACTS);
            } else {
                binding.btnSendAll.setVisibility(View.VISIBLE);
                displayContacts(DeviceUtils.fetchDeviceContacts(parentActivity));
            }
        }
    }

    private void sendSingleContact(ContactData contact, int currentNumber, int size) {
        contact.setRecipient(connectedDeviceInfo.getDeviceId());
        if (contact.getImageDecoded() != null) {
            contact.setImage(BitmapUtils.getEncoded64ImageStringFromBitmap(contact.getImageDecoded()));
        }
        contact.setCurrentNumber(currentNumber);
        contact.setSize(size);
        mViewModel.sendContacts(contact);
    }

    private void sendAllContacts() {
        int size = listContacts.size();
        int currentNumber = 0;
        for (ContactData contact : listContacts) {
            currentNumber++;
            contact.setCurrentNumber(currentNumber);
            contact.setSize(size);
        }
        listContactsToSend.clear();
        listContactsToSend.addAll(listContacts);
        sendSingleContact(listContactsToSend.get(0), 1, size);
    }

    private void updateContacts(ContactData contact) {
        showProgressDialog(contact);
        mViewModel.sendMessageStatus(new ReceiveStatus(connectedDeviceInfo.getDeviceId(), contact.getCurrentNumber(), true));

        if (!TextUtils.isEmpty(contact.getImage())) {
            contact.setImageDecoded(BitmapUtils.getDecodedBitmapFrom64String(contact.getImage()));
        }
        listContacts.add(contact);
        adapterContacts.notifyItemInserted(listContacts.size() - 1);
        rvPhoneContacts.smoothScrollToPosition(listContacts.size() - 1);
    }

    private void displayContacts(List<ContactData> contacts) {
        if (contacts != null) {
            listContacts.clear();
            listContacts.addAll(contacts);
            adapterContacts.notifyDataSetChanged();
        }
    }

    private void showProgressDialog(ContactData contact) {
        if (loadingDialog == null) {
            loadingDialog = new LoadingInfoDialog(parentActivity);
        }
        if (!loadingDialog.isShowing()) {
            loadingDialog.show();
        }
        String status = isTarget ? "Received " : "Uploaded ";
        loadingDialog.updateContent(status + contact.getCurrentNumber() + " of " + contact.getSize());
    }



    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case GC.READ_CONTACTS: {
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    toast("Permission granted");
                    binding.btnSendAll.setVisibility(View.VISIBLE);
                    displayContacts(DeviceUtils.fetchDeviceContacts(parentActivity));
                } else {
                    toast("Permission denied to read your contacts");
                }
            }
        }
    }
}