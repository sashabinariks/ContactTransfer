package com.testapp.base;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.testapp.android.viewModel.Injectable;
import com.testapp.ui.MainActivity;

public abstract class BaseFragment extends Fragment implements Injectable {

    protected MainActivity parentActivity;

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        parentActivity = ((MainActivity)context);
    }

    protected void toast(String message) {
        Toast.makeText(getContext(), message, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initViewModels();
        setupListeners();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        onViewReady(view, savedInstanceState);
    }


    protected abstract void onViewReady(View inflatedView, Bundle args);
    protected abstract void setupListeners();
    protected abstract void initViewModels();
}
