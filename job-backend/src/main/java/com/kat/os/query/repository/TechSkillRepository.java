package com.kat.os.query.repository;

import com.kat.os.query.entity.TechSkill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TechSkillRepository  extends JpaRepository<TechSkill,Long> {
}
