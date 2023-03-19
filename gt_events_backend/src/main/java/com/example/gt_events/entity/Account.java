package com.example.gt_events.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.LinkedHashSet;

@Entity
public class Account {
    @Id
    @GeneratedValue
    private long id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    @JsonIgnore
    private String password;

    @Column(nullable = false)
    private boolean isOrganizer;

    @OneToMany(mappedBy = "author")
    private LinkedHashSet<Event> createdEvents = new LinkedHashSet<>();

    @ManyToMany(fetch = FetchType.EAGER, cascade = CascadeType.PERSIST)
    @JoinTable(joinColumns = {@JoinColumn(name = "account_id")},
            inverseJoinColumns = {@JoinColumn(name = "event_id")})
    private LinkedHashSet<Event> savedEvents = new LinkedHashSet<>();

    public Account() {
    }

    public Account(String username, String password) {
        this.username = username;
        this.password = password;
        this.isOrganizer = true;
    }

    public Account(String username, String password, boolean isOrganizer) {
        this.username = username;
        this.password = password;
        this.isOrganizer = isOrganizer;
    }

    public long getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isOrganizer() {
        return isOrganizer;
    }

    public void setOrganizer(boolean organizer) {
        isOrganizer = organizer;
    }

    public LinkedHashSet<Event> getCreatedEvents() {
        return createdEvents;
    }

    public void setCreatedEvents(LinkedHashSet<Event> createdEvents) {
        this.createdEvents = createdEvents;
    }

    public LinkedHashSet<Event> getSavedEvents() {
        return savedEvents;
    }

    public void setSavedEvents(LinkedHashSet<Event> savedEvents) {
        this.savedEvents = savedEvents;
    }
}