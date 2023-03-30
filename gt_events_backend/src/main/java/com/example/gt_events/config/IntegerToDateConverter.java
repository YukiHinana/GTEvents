package com.example.gt_events.config;


import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class IntegerToDateConverter implements Converter<Integer, Date> {
    @Override
    public Date convert(Integer data) {
        return new Date(data * 1000L);
    }
}
