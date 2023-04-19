package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class CreateTagRequest {
    @NotBlank
    private String tagName;

    @NotBlank
    private String groupName;

    public CreateTagRequest() {
    }

    public CreateTagRequest(String tagName, String groupName) {
        this.tagName = tagName;
        this.groupName = groupName;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }
}
