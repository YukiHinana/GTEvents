package com.example.gt_events.model;

import jakarta.validation.constraints.NotBlank;

import java.util.Date;
import java.util.List;

public class CreateEventRequest {
    @NotBlank
    private String title;

    @NotBlank
    private String location;

    @NotBlank
    private String description;

    private Date eventDate;

    private int capacity;

    private int fee;

    private List<Long> tagIds;

    public CreateEventRequest() {
    }

    public CreateEventRequest(String title, String location, String description, Date eventDate,
                              int capacity, int fee, List<Long> tagIds) {
        this.title = title;
        this.location = location;
        this.description = description;
        this.eventDate = eventDate;
        this.capacity = capacity;
        this.fee = fee;
        this.tagIds = tagIds;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDate() {
        return eventDate;
    }

    public void setDate(Date date) {
        this.eventDate = date;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public int getFee() {
        return fee;
    }

    public void setFee(int fee) {
        this.fee = fee;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }

    public List<Long> getTagIds() {
        return tagIds;
    }

    public void setTagIds(List<Long> tagIds) {
        this.tagIds = tagIds;
    }
}
