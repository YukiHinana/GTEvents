package com.example.gt_events.annotation;

import org.springframework.web.bind.annotation.RequestHeader;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.RUNTIME)
public @interface RequireAuth {
    boolean requireOrganizer() default false;
}
