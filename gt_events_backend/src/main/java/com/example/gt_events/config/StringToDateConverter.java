package com.example.gt_events.config;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class StringToDateConverter implements Converter<String, Date> {
    @Override
    public Date convert(String data) {
        return new Date(Integer.parseInt(data) * 1000L);
    }
}
