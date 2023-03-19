package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

public class EditEventRequest {
    @NotBlank
    private Long eventId;

    @NotBlank
    private String title;

    @NotBlank
    private String body;

    public EditEventRequest() {
    }

    public EditEventRequest(Long eventId, String title, String body) {
        this.eventId = eventId;
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

    public Long getEventId() {
        return eventId;
    }

    public void setEventId(Long eventId) {
        this.eventId = eventId;
    }
}
