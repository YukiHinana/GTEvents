package com.example.gt_events.repo;

import com.example.gt_events.entity.TagGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TagGroupRepository extends JpaRepository<TagGroup, Long> {
    Optional<TagGroup> findTagGroupByName(String tagGroupName);
}
