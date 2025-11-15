package com.kat.os.query.repository;
import com.kat.os.query.entity.Degree;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface  DegreeRepository extends JpaRepository<Degree,Long> {
}
