package com.example.gt_events.config;

import com.fasterxml.jackson.core.JacksonException;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;

import java.io.IOException;
import java.util.Date;

public class DateDeserializer extends StdDeserializer<Date> {
    public DateDeserializer() {
        this(Date.class);
    }

    public DateDeserializer(Class<Date> t) {
        super(t);
    }

    @Override
    public Date deserialize(JsonParser p, DeserializationContext ctxt) throws IOException, JacksonException {
        long timestamp = p.getNumberValue().longValue() * 1000;
        return new Date(timestamp);
    }
}
