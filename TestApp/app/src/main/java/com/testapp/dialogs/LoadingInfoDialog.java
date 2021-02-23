package com.testapp.dialogs;


import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Window;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.testapp.R;

public class LoadingInfoDialog extends Dialog {

    private Button btnConfirm;
    private TextView tvLoadMessage;

    public LoadingInfoDialog(@NonNull Context context) {
        super(context);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_downloading_info);
        btnConfirm = findViewById(R.id.btn_dialog_confirm);
        btnConfirm.setOnClickListener(v -> dismiss());

        tvLoadMessage = findViewById(R.id.tv_load_message);
    }

    public void updateContent(String text) {
        tvLoadMessage.setText(text);
    }
}
