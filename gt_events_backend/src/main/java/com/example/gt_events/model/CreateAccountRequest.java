package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class CreateAccountRequest {
    @NotBlank
    private String username;

    @NotBlank
    private String password;

    private boolean isOrganizer;

    public CreateAccountRequest() {
    }

    public CreateAccountRequest(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public CreateAccountRequest(String username, String password, boolean isOrganizer) {
        this.username = username;
        this.password = password;
        this.isOrganizer = isOrganizer;
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

    public boolean isOrganizer() {
        return isOrganizer;
    }

    public void setOrganizer(boolean organizer) {
        isOrganizer = organizer;
    }
}
