package com.testapp.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.testapp.R;
import com.testapp.models.ContactData;

import java.util.List;

public class AdapterContacts extends RecyclerView.Adapter<AdapterContacts.ViewHolder> {

    private List<ContactData> mData;
    private LayoutInflater mInflater;
    private ItemClickListener mClickListener;

    public AdapterContacts(Context context, List<ContactData> data) {
        this.mInflater = LayoutInflater.from(context);
        this.mData = data;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.row_recycler_contact, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        ContactData contact = mData.get(position);
        holder.tvContactName.setText(contact.getName());
        holder.tvContactPhone.setText(contact.getPhoneNumber());
        holder.tvContactEmail.setText(contact.getEmail());
        if (contact.getImageDecoded() != null) {
            holder.ivContactImage.setImageBitmap(contact.getImageDecoded());
        } else {
            holder.ivContactImage.setImageBitmap(null);
        }
        if (mClickListener != null) {
            holder.itemView.setOnClickListener(v -> mClickListener.onItemClick(contact));
        }
    }

    @Override
    public int getItemCount() {
        return mData.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {

        TextView tvContactName, tvContactPhone, tvContactEmail;
        ImageView ivContactImage;

        ViewHolder(View itemView) {
            super(itemView);
            tvContactName = itemView.findViewById(R.id.tv_contact_name);
            tvContactPhone = itemView.findViewById(R.id.tv_contact_phone);
            tvContactEmail = itemView.findViewById(R.id.tv_contact_email);
            ivContactImage = itemView.findViewById(R.id.iv_contact_image);
        }
    }

    ContactData getItem(int id) {
        return mData.get(id);
    }

    public void setClickListener(ItemClickListener itemClickListener) {
        this.mClickListener = itemClickListener;
    }

    public interface ItemClickListener {
        void onItemClick(ContactData contact);
    }
}
