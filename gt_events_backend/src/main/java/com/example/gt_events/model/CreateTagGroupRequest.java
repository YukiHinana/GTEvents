package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class CreateTagGroupRequest {
    @NotBlank
    private String groupName;

    public CreateTagGroupRequest(String groupName) {
        this.groupName = groupName;
    }

    public CreateTagGroupRequest() {
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }
}
