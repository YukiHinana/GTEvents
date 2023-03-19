package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class EditTagRequest {
    @NotBlank
    private String tagName;

    public EditTagRequest() {
    }

    public EditTagRequest(String tagName) {
        this.tagName = tagName;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }
}
