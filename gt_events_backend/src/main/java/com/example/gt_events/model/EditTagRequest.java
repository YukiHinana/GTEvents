package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class EditTagRequest {
    @NotBlank
    private String tagName;

    @NotBlank
    private String groupName;

    public EditTagRequest() {
    }

    public EditTagRequest(String tagName, String groupName) {
        this.tagName = tagName;
        this.groupName = groupName;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }
}
