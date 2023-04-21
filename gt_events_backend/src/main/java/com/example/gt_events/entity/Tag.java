package com.example.gt_events.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
public class Tag {
    @Id
    @GeneratedValue
    private Long id;

    @Column(unique = true)
    private String name;

    @ManyToOne
    @JoinColumn
    @OnDelete(action = OnDeleteAction.NO_ACTION)
    @JsonIgnore
    private TagGroup groupName;

    public Tag() {
    }

    public Tag(String name, TagGroup groupName) {
        this.name = name;
        this.groupName = groupName;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public TagGroup getGroupName() {
        return groupName;
    }

    public void setGroupName(TagGroup groupName) {
        this.groupName = groupName;
    }
}
