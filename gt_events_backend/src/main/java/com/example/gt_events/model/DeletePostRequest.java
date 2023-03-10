package com.example.gt_events.model;

import jakarta.validation.constraints.NotNull;

public class DeletePostRequest {
    @NotNull
    private Long postId;

    public DeletePostRequest() {
    }

    public DeletePostRequest(Long postId) {
        this.postId = postId;
    }

    public Long getPostId() {
        return postId;
    }

    public void setPostId(Long postId) {
        this.postId = postId;
    }
}