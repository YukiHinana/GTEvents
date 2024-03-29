package com.example.gt_events.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashSet;
import java.util.Set;

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
    @JsonIgnore
    private boolean isOrganizer;

    private String avatarKey;

    @OneToMany(mappedBy = "author")
    @JsonIgnore
    private Set<Event> createdEvents = new LinkedHashSet<>();

    @ManyToMany
    @JoinTable(joinColumns = {@JoinColumn(name = "account_id")},
            inverseJoinColumns = {@JoinColumn(name = "event_id")})
    @JsonIgnore
    private Set<Event> savedEvents = new LinkedHashSet<>();

    public Account() {
    }

    public Account(String username, String password, boolean isOrganizer, String avatarKey) {
        this.username = username;
        this.password = password;
        this.isOrganizer = isOrganizer;
        this.avatarKey = avatarKey;
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

    public boolean getIsOrganizer() {
        return isOrganizer;
    }

    public void setIsOrganizer(boolean isOrganizer) {
        this.isOrganizer = isOrganizer;
    }

    public Set<Event> getCreatedEvents() {
        return createdEvents;
    }

    public void setCreatedEvents(Set<Event> createdEvents) {
        this.createdEvents = createdEvents;
    }

    public Set<Event> getSavedEvents() {
        return savedEvents;
    }

    public void setSavedEvents(Set<Event> savedEvents) {
        this.savedEvents = savedEvents;
    }

    public String getAvatarKey() {
        return avatarKey;
    }

    public void setAvatarKey(String avatarKey) {
        this.avatarKey = avatarKey;
    }
}