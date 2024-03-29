package com.example.gt_events.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
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
    private Date eventCreationDate;

    private String description;

    // TODO: create a field for uploading pictures
    @JsonIgnore
    @ElementCollection
    private List<String> imagesKeys;

    // RSVP
    private int participantNum;

    private int capacity;

    private int fee;

    @ManyToMany(fetch = FetchType.EAGER, cascade = CascadeType.PERSIST)
    @JoinTable(joinColumns = {@JoinColumn(name = "event_id")},
            inverseJoinColumns = {@JoinColumn(name = "tag_id")})
    private Set<Tag> tags = new LinkedHashSet<>();

    @ManyToOne
    @JoinColumn
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Account author;

    @Override
    public int hashCode() {
        return (int)((long) this.getId());
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Event) {
            Event e = (Event) obj;
            return Objects.equals(e.getId(), this.getId());
        }
        return false;
    }

    public Event() {}

    public Event(String title, String location, String description, Date eventDate,
                 int capacity, int fee, Set<Tag> tags, Account author) {
        this.title = title;
        this.location = location;
        this.description = description;
        this.eventDate = eventDate;
        this.eventCreationDate = new Date();
        this.participantNum = 0;
        this.capacity = capacity;
        this.fee = fee;
        this.tags = tags;
        this.author = author;
        this.imagesKeys = new ArrayList<>();
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

    public Date getEventCreationDate() {
        return eventCreationDate;
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

    public Set<Tag> getTags() {
        return tags;
    }

    public void setTags(Set<Tag> tags) {
        this.tags = tags;
    }

    public List<String> getImagesKeys() {
        return imagesKeys;
    }

    public void setImagesKeys(List<String> imagesKeys) {
        this.imagesKeys = imagesKeys;
    }
}
