package com.example.gt_events.repo;

import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.Tag;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;

public interface EventRepository extends JpaRepository<Event, Long> {
     Page<Event> findAll(Pageable pageable);

     Page<Event> findByEventDateBetween(Date startDate, Date endDate, Pageable pageable);

     Page<Event> findByEventCreationDateBetween(Date startDate, Date endDate, Pageable pageable);
}
