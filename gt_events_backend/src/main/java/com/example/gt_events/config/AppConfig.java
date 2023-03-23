package com.example.gt_events.config;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.Module;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Date;
import java.util.List;

@Component
public class AppConfig implements WebMvcConfigurer {
    @Autowired
    AuthenticationInterceptor authenticationInterceptor;

    @Autowired
    AccountArgumentResolver accountArgumentResolver;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authenticationInterceptor);
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(accountArgumentResolver);
    }

    @Bean
    @Primary
    public ObjectMapper objectMapper() {
        SimpleModule serdeModule = new SimpleModule();
        serdeModule.addSerializer(new DateSerializer());
        serdeModule.addDeserializer(Date.class, new DateDeserializer());
        return new ObjectMapper()
                .setSerializationInclusion(JsonInclude.Include.NON_NULL)
                .registerModule(serdeModule);
    }
}
