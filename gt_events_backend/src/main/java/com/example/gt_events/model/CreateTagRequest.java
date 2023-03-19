package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class CreateTagRequest {
    @NotBlank
    private String tagName;

    public CreateTagRequest() {
    }

    public CreateTagRequest(String tagName) {
        this.tagName = tagName;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }
}
