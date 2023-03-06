package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class AccountRequest {
    @NotBlank
    private String username;

    @NotBlank
    private String password;

    public AccountRequest() {
    }

    public AccountRequest(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
