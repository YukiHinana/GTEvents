package com.example.gt_events.exception;

import org.springframework.http.HttpStatus;

public class RequestException extends RuntimeException {
    private HttpStatus httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;

    public RequestException(String message) {
        super(message);
    }

    public RequestException(HttpStatus httpStatus, String message) {
        super(message);
        this.httpStatus = httpStatus;
    }

    public HttpStatus getHttpStatus() {
        return httpStatus;
    }

    public void setHttpStatus(HttpStatus httpStatus) {
        this.httpStatus = httpStatus;
    }
}
