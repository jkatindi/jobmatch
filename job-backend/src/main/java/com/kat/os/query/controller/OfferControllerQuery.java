package com.kat.os.query.controller;

import com.kat.os.command.dto.request.CreateOfferJobTDO;
import com.kat.os.commonDTO.DegreeDTO;
import com.kat.os.commonDTO.TechnologyDTO;
import com.kat.os.commonDTO.WorkOfferTDO;
import com.kat.os.mappers.OfferMapper;
import com.kat.os.query.entity.WorkOffer;
import com.kat.os.query.repository.WorkOfferRepository;
import com.kat.os.query.service.WorkOfferService;
import com.kat.os.query.tdo.*;
import org.axonframework.messaging.responsetypes.ResponseTypes;
import org.axonframework.queryhandling.QueryGateway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api")
public class OfferControllerQuery {

    private final QueryGateway gateway;
    @Autowired
    private WorkOfferRepository  offerRepository;
    @Autowired
    OfferMapper mapper;

    public OfferControllerQuery(QueryGateway gateway, WorkOfferService offerService) {
        this.gateway = gateway;
    }

    @GetMapping("/query/offers/all")
    @PreAuthorize("hasAuthority('SCOPE_USER')")
    public List<WorkOfferTDO> getAllOfferWork(){
        return  this.gateway.query(new GetAllQueryOfferDTO(),
                ResponseTypes.multipleInstancesOf(WorkOfferTDO.class)).join();
    }

    @PostMapping("/query/addOffer")
    @PreAuthorize("hasAuthority('SCOPE_ADMIN')")
    public WorkOffer addNewOffer(@RequestBody WorkOfferTDO workOfferTDO){
        workOfferTDO.setId(UUID.randomUUID().toString());
        return  this.offerRepository.save(this.mapper.toEntity(workOfferTDO));
    }
    @GetMapping("/query/all/offers/{keyWord}")
    @PreAuthorize("hasAuthority('SCOPE_USER')")
    public  List<WorkOfferTDO> getOfferByKeyWord(@PathVariable  String keyWord) {

        return  this.gateway.query(new GetQueryKeyWordOffer(keyWord.toLowerCase()),
                ResponseTypes.multipleInstancesOf(WorkOfferTDO.class)).join();
    }

    @GetMapping("/query/offers/all/{id}")
    @PreAuthorize("hasAuthority('SCOPE_USER')")
    public WorkOfferTDO getOneOfferID(@PathVariable String id){
        return this.gateway.query(
                new GetQueryIdOfferDTO(id),ResponseTypes.instanceOf(WorkOfferTDO.class)).join();
    }

    @GetMapping("/query/technologies/all")
    @PreAuthorize("hasAuthority('SCOPE_USER')")
    public List<TechnologyDTO> getAllTechSkills(){
        return this.gateway.query(new GetAllQueryTechDTO(),
                        ResponseTypes.multipleInstancesOf(TechnologyDTO.class)).join();
    }

    @GetMapping("/query/technologies/{id}")
    @PreAuthorize("hasAuthority('SCOPE_USER')")
    public TechnologyDTO getOneTechnology(@PathVariable Long id){
        return  this.gateway.query(new GetQueryIdTechDTO(id),
                ResponseTypes.instanceOf(TechnologyDTO.class)).join();
    }

    @GetMapping("/query/degrees/all")
    @PreAuthorize("hasAuthority('SCOPE_USER')")
    public List<DegreeDTO> getAllDegrees(){
        return  this.gateway.query(new GetAllQueryDegreeDTO(),
                ResponseTypes.multipleInstancesOf(DegreeDTO.class)).join();
    }

    @GetMapping("/query/degrees/{id}")
    @PreAuthorize("hasAuthority('SCOPE_USER')")
    public DegreeDTO getOneDegree(@PathVariable Long id){
        return  this.gateway.query(new GetQueryIdDegreeDTO(id),
                        ResponseTypes.instanceOf(DegreeDTO.class)).join();
    }

    @ExceptionHandler
    public ResponseEntity<String> exceptionHandler(Exception exception){
        return  new ResponseEntity<String>(exception.getMessage(),
                HttpStatus.INTERNAL_SERVER_ERROR);

    }
}
