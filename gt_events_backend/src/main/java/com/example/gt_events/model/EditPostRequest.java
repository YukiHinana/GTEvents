package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class EditPostRequest {
    @NotBlank
    private Long postId;

    @NotBlank
    private String title;

    @NotBlank
    private String body;

    public EditPostRequest() {
    }

    public EditPostRequest(Long postId, String title, String body) {
        this.postId = postId;
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

    public Long getPostId() {
        return postId;
    }

    public void setPostId(Long postId) {
        this.postId = postId;
    }
}
