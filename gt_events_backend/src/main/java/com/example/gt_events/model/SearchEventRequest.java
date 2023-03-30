package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class SearchEventRequest {
    @NotBlank
    private String keyword;

    public SearchEventRequest() {
    }

    public SearchEventRequest(String keyword) {
        this.keyword = keyword;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }
}
