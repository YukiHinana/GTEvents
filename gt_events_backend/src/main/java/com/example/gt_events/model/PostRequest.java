package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class PostRequest {
    @NotBlank
    private String title;

    @NotBlank
    private String body;

    public PostRequest() {
    }

    public PostRequest(String title, String body) {
        this.title = title;
        this.body = body;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }
}
