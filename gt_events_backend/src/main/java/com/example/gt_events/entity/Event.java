package com.example.gt_events.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.*;

@Entity
public class Event {
    @Id
    @GeneratedValue
    private Long id;

    private String title;

    private String location;

    @Temporal(TemporalType.TIMESTAMP)
    private Date eventDate;

    @Temporal(TemporalType.TIMESTAMP)
    private Date eventCreateDate;

    private String description;

    // TODO: create a field for uploading pictures

    // RSVP
    private int participantNum;

    private int capacity;

    private int fee;

    @ManyToMany(fetch = FetchType.EAGER, cascade = CascadeType.PERSIST)
    @JoinTable(joinColumns = {@JoinColumn(name = "event_id")},
            inverseJoinColumns = {@JoinColumn(name = "tag_id")})
    private List<Tag> tags = new ArrayList<>();

    @ManyToOne
    @JoinColumn
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Account author;

    public Event() {}

//    public Event(String title, String location, String description, Account author) {
//        this.title = title;
//        this.location = location;
//        this.description = description;
//        this.author = author;
//    }

    public Event(String title, String location, String description, Date eventDate,
                 int capacity, int fee, List<Tag> tags, Account author) {
        this.title = title;
        this.location = location;
        this.description = description;
        this.eventDate = eventDate;
        this.participantNum = 0;
        this.capacity = capacity;
        this.fee = fee;
        this.tags = tags;
        this.author = author;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Account getAuthor() {
        return author;
    }

    public void setAuthor(Account author) {
        this.author = author;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getParticipantNum() {
        return participantNum;
    }

    public void setParticipantNum(int participantNum) {
        this.participantNum = participantNum;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Date getEventCreateDate() {
        return eventCreateDate;
    }

    public void setEventCreateDate(Date eventCreateDate) {
        this.eventCreateDate = eventCreateDate;
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

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }
}
