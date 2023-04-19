package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class EditTagGroupRequest {
    @NotBlank
    private String groupName;

    public EditTagGroupRequest() {
    }

    public EditTagGroupRequest(String groupName) {
        this.groupName = groupName;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }
}
