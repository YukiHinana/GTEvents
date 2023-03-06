package com.example.gt_events.model;

public class AccessAccountByTokenRequest {
    private String token;

    public AccessAccountByTokenRequest() {
    }

    public AccessAccountByTokenRequest(String token) {
        this.token = token;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
