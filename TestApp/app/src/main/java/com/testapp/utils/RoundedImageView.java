package com.testapp.utils;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Path;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.widget.ImageView;

public class RoundedImageView extends ImageView {

    private float radius = 18.0f;
    private Path path;
    private RectF rect;

    public RoundedImageView(Context context) {
        super(context);
        init();
    }

    public RoundedImageView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public RoundedImageView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    private void init() {
        path = new Path();
        rect = new RectF(0, 0, this.getWidth(), this.getHeight());
    }

    @Override
    protected void onDraw(Canvas canvas) {
        path.addRoundRect(rect, radius, radius, Path.Direction.CW);
        canvas.clipPath(path);
        super.onDraw(canvas);
    }
}