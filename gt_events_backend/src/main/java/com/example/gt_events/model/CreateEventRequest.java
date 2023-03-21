package com.example.gt_events.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;

import java.sql.Timestamp;
import java.util.Date;
import java.util.LinkedHashSet;

public class CreateEventRequest {
    @NotBlank
    private String title;

    @NotBlank
    private String location;

    @NotBlank
    private String description;

    @JsonFormat(shape = JsonFormat.Shape.NUMBER, pattern = "s")
    private Timestamp eventDate;

    private int capacity;

    private int fee;

    private LinkedHashSet<Long> tagIds;

    public CreateEventRequest() {
    }

    public CreateEventRequest(String title, String location, String description, Timestamp eventDate,
                              int capacity, int fee, LinkedHashSet<Long> tagIds) {
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

    public Timestamp getEventDate() {
        return eventDate;
    }

    public void setEventDate(Timestamp eventDate) {
        this.eventDate = eventDate;
    }

    public LinkedHashSet<Long> getTagIds() {
        return tagIds;
    }

    public void setTagIds(LinkedHashSet<Long> tagIds) {
        this.tagIds = tagIds;
    }
}
