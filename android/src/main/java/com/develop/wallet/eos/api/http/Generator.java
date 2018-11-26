package com.develop.wallet.eos.api.http;

import com.develop.wallet.eos.api.exception.ApiError;
import com.develop.wallet.eos.api.exception.ApiException;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;

import java.io.IOException;
import java.lang.annotation.Annotation;

public class Generator {

    private static OkHttpClient.Builder httpClient = new OkHttpClient.Builder();

    private static Retrofit.Builder builder = new Retrofit.Builder()
            .addConverterFactory(JacksonConverterFactory.create());

    private static Retrofit retrofit;

    public static <S> S createService(Class<S> serviceClass, String baseUrl, boolean logDebug) {
        if (logDebug) {
            // Log信息拦截器
            HttpLoggingInterceptor loggingInterceptor = new HttpLoggingInterceptor();
            loggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
            //设置 Debug Log 模式
            httpClient.addInterceptor(loggingInterceptor);
        }

        builder.baseUrl(baseUrl);
        builder.client(httpClient.build());
        builder.addConverterFactory(JacksonConverterFactory.create());
        retrofit = builder.build();
        return retrofit.create(serviceClass);
    }

    public static <T> T executeSync(Call<T> call) {
        try {
            System.out.print("请求 -- call request：" + call.request().toString());
            Response<T> response = call.execute();
            System.out.print("请求 -- response code：" + response.code());
            if (response.isSuccessful()) {
                return response.body();
            } else {
                ApiError apiError = getApiError(response);
                throw new ApiException(apiError);
            }
        } catch (IOException e) {
            System.out.print("执行错误：" + e.toString());
            throw new ApiException(e);
        }
    }

    private static ApiError getApiError(Response<?> response) throws IOException, ApiException {
        return (ApiError) retrofit.responseBodyConverter(ApiError.class, new Annotation[0]).convert(response.errorBody());
    }
}
