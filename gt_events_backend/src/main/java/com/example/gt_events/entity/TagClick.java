package com.example.gt_events.entity;

import jakarta.persistence.*;

import java.util.Date;

@Entity
public class TagClick {
    @Id
    @GeneratedValue
    private Long id;

    @OneToOne
    private Tag tag;

    @Temporal(TemporalType.TIMESTAMP)
    private Date clickDate;

    public TagClick() {
    }

    public TagClick(Tag tag, Date clickDate) {
        this.tag = tag;
        this.clickDate = clickDate;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }

    public Date getClickDate() {
        return clickDate;
    }

    public void setClickDate(Date clickDate) {
        this.clickDate = clickDate;
    }
}
