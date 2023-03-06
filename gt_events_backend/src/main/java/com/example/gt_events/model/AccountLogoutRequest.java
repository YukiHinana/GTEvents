package com.example.gt_events.model;

public class AccountLogoutRequest {
    private String token;

    public AccountLogoutRequest() {
    }

    public AccountLogoutRequest(String token) {
        this.token = token;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
