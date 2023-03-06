package com.example.gt_events.exception;


import com.example.gt_events.ResponseWrapper;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class RequestExceptionController {
    @ExceptionHandler(value = RequestException.class)
    public ResponseEntity<ResponseWrapper<String>> requestException(RequestException exception) {
        return new ResponseEntity<>(new ResponseWrapper<>(exception.getMessage()), exception.getHttpStatus());
    }
}
