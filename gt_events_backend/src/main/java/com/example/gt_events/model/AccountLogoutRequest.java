package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class AccountLogoutRequest {
    @NotBlank
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
