package com.example.gt_events.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Entity
public class Account {
    @Id
    @GeneratedValue
    private long id;

    @Column(nullable = false)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private boolean isOrganizer;

    public Account() {}

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
}
