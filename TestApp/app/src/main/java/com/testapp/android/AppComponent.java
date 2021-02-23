package com.testapp.android;

import com.testapp.AppApplication;

import javax.inject.Singleton;

import dagger.BindsInstance;
import dagger.Component;
import dagger.android.support.AndroidSupportInjectionModule;

@Singleton
@Component(modules = {AndroidSupportInjectionModule.class, AppModule.class, BuildersModule.class})
public interface AppComponent {

    @Component.Builder
    interface Builder {
        @BindsInstance
        Builder application(AppApplication application);

        AppComponent build();
    }

    // Application
    void inject(AppApplication appApplication);

}
