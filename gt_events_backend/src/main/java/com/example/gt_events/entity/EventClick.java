package com.example.gt_events.entity;

import jakarta.persistence.*;

@Entity
public class EventClick {
    @Id
    @GeneratedValue
    private Long id;

    @OneToOne
    private Event eventId;

    private long numClick;

    public EventClick() {
    }

    public EventClick(Event eventId, long numClick) {
        this.eventId = eventId;
        this.numClick = numClick;
    }

    public Event getEventId() {
        return eventId;
    }

    public void setEventId(Event eventId) {
        this.eventId = eventId;
    }

    public long getNumClick() {
        return numClick;
    }

    public void setNumClick(long numClick) {
        this.numClick = numClick;
    }
}
