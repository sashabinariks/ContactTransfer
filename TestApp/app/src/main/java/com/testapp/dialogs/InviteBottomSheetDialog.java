package com.testapp.dialogs;

import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;
import com.testapp.R;
import com.testapp.models.DeviceInfo;
import com.testapp.models.InviteData;

public class InviteBottomSheetDialog extends BottomSheetDialogFragment {

    private BottomSheetBehavior.BottomSheetCallback mBottomSheetBehaviorCallback = new BottomSheetBehavior.BottomSheetCallback() {

        @Override
        public void onStateChanged(@NonNull View bottomSheet, int newState) {
            if (newState == BottomSheetBehavior.STATE_HIDDEN) {
                sendDecline();
                dismiss();
            }
        }

        @Override
        public void onSlide(@NonNull View bottomSheet, float slideOffset) {
        }
    };

    private InviteData invite;
    private InviteListener inviteListener;
    private DeviceInfo myDeviceInfo;

    public static InviteBottomSheetDialog newInstance(InviteData invite, DeviceInfo deviceInfo, InviteListener listener) {
        InviteBottomSheetDialog dialog = new InviteBottomSheetDialog();
        dialog.invite = invite;
        dialog.inviteListener = listener;
        dialog.myDeviceInfo = deviceInfo;
        return dialog;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        return super.onCreateDialog(savedInstanceState);
    }

    @Override
    public void onViewCreated(View contentView, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(contentView, savedInstanceState);
    }

    @Override
    public void onCancel(@NonNull DialogInterface dialog) {
        super.onCancel(dialog);
        sendDecline();
    }

    @Override
    public void setupDialog(Dialog dialog, int style) {
        super.setupDialog(dialog, style);
        View contentView = View.inflate(getContext(), R.layout.bottom_sheet_invite, null);
        dialog.setContentView(contentView);
        BottomSheetBehavior mBottomSheetBehavior = BottomSheetBehavior.from(((View) contentView.getParent()));
        if (mBottomSheetBehavior != null) {
            mBottomSheetBehavior.setBottomSheetCallback(mBottomSheetBehaviorCallback);
        }

        setupContentView(contentView);
    }


    private void setupContentView(View contentView) {
        TextView tvContent = contentView.findViewById(R.id.tv_invite_bottom_sheet_content);
        tvContent.setText(String.format(getResources().getString(R.string.invite), invite.getDisplayName()));

        Button btnAccept = contentView.findViewById(R.id.btn_accept);
        Button btnDecline = contentView.findViewById(R.id.btn_decline);
        btnAccept.setOnClickListener(v -> {
            sendAccept();
            dismiss();
        });
        btnDecline.setOnClickListener(v -> {
            sendDecline();
            dismiss();
        });
    }

    private void sendAccept() {
        inviteListener.onReceiveInviteResult(new InviteData(invite.getDeviceId(), myDeviceInfo.getDeviceId(), myDeviceInfo.getDeviceName(), true));
    }

    private void sendDecline() {
        inviteListener.onReceiveInviteResult(new InviteData(invite.getDeviceId(), myDeviceInfo.getDeviceId(), myDeviceInfo.getDeviceName(), false));
    }

    public interface InviteListener {
         void onReceiveInviteResult(InviteData resultInvite);
    }

}
