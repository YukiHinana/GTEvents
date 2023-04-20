package com.example.gt_events.repo;

import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.Tag;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Set;

public interface EventRepository extends JpaRepository<Event, Long> {
     Page<Event> findAll(Pageable pageable);

     Page<Event> findByEventDateBetween(Date startDate, Date endDate, Pageable pageable);

     Page<Event> findByEventCreationDateBetween(Date startDate, Date endDate, Pageable pageable);

     Page<Event> findByTitleContainingOrAuthor_UsernameContaining(String keywordTitle, String keywordUsername, Pageable pageable);

//     List<Event> findAllByTags(Set<Tag> tags);
     List<Event> findAllByTagsIn(List<Tag> tags);
}
