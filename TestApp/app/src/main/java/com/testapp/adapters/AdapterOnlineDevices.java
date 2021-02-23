package com.testapp.adapters;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.testapp.utils.DeviceUtils;
import com.testapp.R;
import com.testapp.models.DeviceInfo;

import java.util.List;

public class AdapterOnlineDevices extends RecyclerView.Adapter<AdapterOnlineDevices.ViewHolder> {

    private List<DeviceInfo> mData;
    private LayoutInflater mInflater;
    private ItemClickListener mClickListener;

    public AdapterOnlineDevices(Context context, List<DeviceInfo> data) {
        this.mInflater = LayoutInflater.from(context);
        this.mData = data;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.row_recycler_online_user, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        DeviceInfo deviceInfo = mData.get(position);
        holder.tvDeviceName.setText(deviceInfo.getDeviceName());
        if (mClickListener != null) {
            holder.itemView.setOnClickListener(v -> mClickListener.onItemClick(deviceInfo.getDeviceId()));
        }
    }

    @Override
    public int getItemCount() {
        return mData.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {

        TextView tvDeviceName;

        ViewHolder(View itemView) {
            super(itemView);
            tvDeviceName = itemView.findViewById(R.id.tv_device_name);
        }
    }

    DeviceInfo getItem(int id) {
        return mData.get(id);
    }

    public void setClickListener(ItemClickListener itemClickListener) {
        this.mClickListener = itemClickListener;
    }

    public interface ItemClickListener {
        void onItemClick(String deviceId);
    }
}
