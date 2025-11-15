package com.kat.os.query.repository;

import com.kat.os.query.entity.WorkOffer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import jakarta.transaction.Transactional;
import java.util.List;

@Repository
public interface WorkOfferRepository extends JpaRepository<WorkOffer,String> {


  @Query("select o from WorkOffer  o where o.title like %:keyWord%")
  List<WorkOffer> findOfferKeyWord(@Param("keyWord") String keyWord);
}
