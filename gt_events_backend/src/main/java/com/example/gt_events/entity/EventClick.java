package com.example.gt_events.entity;

import jakarta.persistence.*;

import java.util.Date;

@Entity
public class EventClick {
    @Id
    @GeneratedValue
    private Long id;

    @OneToOne
    private Event event;

//    private long numClick;
    @Temporal(TemporalType.TIMESTAMP)
    private Date clickDate;

    public EventClick() {
    }

    public EventClick(Event event, Date clickDate) {
        this.event = event;
        this.clickDate = clickDate;
    }

    public Event getEvent() {
        return event;
    }

    public void setEvent(Event eventId) {
        this.event = eventId;
    }

    public Date getClickDate() {
        return clickDate;
    }

    public void setClickDate(Date clickDate) {
        this.clickDate = clickDate;
    }
}
