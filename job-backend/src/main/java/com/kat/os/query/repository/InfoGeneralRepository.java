package com.kat.os.query.repository;

import com.kat.os.query.entity.InfoGeneral;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InfoGeneralRepository  extends JpaRepository<InfoGeneral,Long> {
}
