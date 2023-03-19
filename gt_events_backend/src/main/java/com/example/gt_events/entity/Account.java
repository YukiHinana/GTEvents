package com.example.gt_events.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.List;

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

    @OneToMany(fetch = FetchType.LAZY,
            cascade = CascadeType.ALL)
    @JoinColumn(name = "account_id")
    private List<Event> savedEvents;

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

    public void setIsOrganizer(boolean isOrganizer) {
        isOrganizer = isOrganizer;
    }
}