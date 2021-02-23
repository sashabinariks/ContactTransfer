package com.testapp.utils;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.provider.ContactsContract;
import android.provider.Settings;
import android.telephony.TelephonyManager;

import com.testapp.models.ContactData;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class DeviceUtils {

    public static String getDeviceName() {
        String manufacturer = Build.MANUFACTURER;
        String model = Build.MODEL;
        if (model.startsWith(manufacturer)) {
            return capitalize(model);
        } else {
            return capitalize(manufacturer) + " " + model;
        }
    }

    private static String capitalize(String s) {
        if (s == null || s.length() == 0) {
            return "";
        }
        char first = s.charAt(0);
        if (Character.isUpperCase(first)) {
            return s;
        } else {
            return Character.toUpperCase(first) + s.substring(1);
        }
    }

    public static String getAndroidId(Context context) {
        return Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
    }

    public static List<ContactData> fetchDeviceContacts(Context context) {
        List<ContactData> list = new ArrayList<>();
        ContentResolver contentResolver = context.getContentResolver();
        Cursor cursor = contentResolver.query(ContactsContract.Contacts.CONTENT_URI, null, null, null, null);
        if (cursor.getCount() > 0) {
            while (cursor.moveToNext()) {
                String id = cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts._ID));
                if (cursor.getInt(cursor.getColumnIndex(ContactsContract.Contacts.HAS_PHONE_NUMBER)) > 0) {
                    Cursor cursorInfo = contentResolver.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,
                            ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = ?", new String[]{id}, null);
                    InputStream inputStream = ContactsContract.Contacts.openContactPhotoInputStream(context.getContentResolver(),
                            ContentUris.withAppendedId(ContactsContract.Contacts.CONTENT_URI, Long.parseLong(id)));

                    Bitmap photo = null;
                    if (inputStream != null) {
                        photo = BitmapFactory.decodeStream(inputStream);
                    }

                    String email = "";
                    Cursor emailCursor = contentResolver.query(ContactsContract.CommonDataKinds.Email.CONTENT_URI, null,
                            ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = ?", new String[]{id}, null);
                    if (emailCursor != null && emailCursor.moveToFirst()) {
                        email = emailCursor.getString(emailCursor.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));
                        emailCursor.close();
                    }

                    while (cursorInfo.moveToNext()) {
                        ContactData info = new ContactData();
                        info.setName(cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME)));
                        info.setPhoneNumber(cursorInfo.getString(cursorInfo.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)));
                        info.setEmail(email);
                        info.setImageDecoded(photo);
                        list.add(info);
                    }

                    cursorInfo.close();
                }
            }
            cursor.close();
        }
        return list;
    }
}
