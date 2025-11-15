package com.kat.os;

import com.kat.os.commonDTO.TechnologyDTO;
import com.kat.os.commonDTO.WorkOfferTDO;
import com.kat.os.mappers.OfferMapper;
import com.kat.os.query.entity.Degree;
import com.kat.os.query.entity.InfoGeneral;
import com.kat.os.query.entity.TechSkill;
import com.kat.os.query.entity.WorkOffer;
import com.kat.os.query.repository.DegreeRepository;
import com.kat.os.query.repository.TechSkillRepository;
import com.kat.os.query.repository.WorkOfferRepository;
import com.kat.os.query.service.DegreeService;
import com.kat.os.query.service.TechService;
import com.kat.os.query.service.WorkOfferService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.AutoConfigureOrder;
import org.springframework.boot.autoconfigure.SpringBootApplication;


import java.util.*;
import java.util.stream.Collectors;


@SpringBootApplication
@AutoConfigureOrder
public class OfferServiceApplication  implements CommandLineRunner {
    @Autowired
	private DegreeService degreeService;
	@Autowired
	private TechService techSkillService;
	@Autowired
	private WorkOfferRepository repositoryOffer;
	public static void main(String[] args) {
		SpringApplication.run(OfferServiceApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		Arrays.asList("Java 8+ ", "PHP5", "CSS", "Angular 8+","Api Rest",
						"Microservises","Docker Swarm",
						"Apache Kafka","Kafka stream","Docker","Kubernates","Design Patterns","Principe SOLID",
						"MySql","Jpa Hibernate","Spring MVC","Spring Boot","Python Math","Jsp","Javascript","C#","React",
						"express", "GraphQL","Docker Swarm","Spring Batch").
				forEach(tech->this.techSkillService.addOneTechnology(tech));
		Arrays.asList("Bachelor","Master","Certification","Data scientist").
				forEach(deg->this.degreeService.addOneDegree(deg));

	}
}
