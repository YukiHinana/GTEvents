package com.example.gt_events.exception;

import org.springframework.http.HttpStatus;

public class InvalidRequestException extends RequestException {
    public InvalidRequestException(String msg) {
        super(HttpStatus.BAD_REQUEST, msg);
    }
}
