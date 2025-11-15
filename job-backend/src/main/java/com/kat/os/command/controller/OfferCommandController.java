package com.kat.os.command.controller;

import com.kat.os.command.dto.request.CreateOfferJobTDO;
import com.kat.os.command.dto.request.CreateTechDTO;
import com.kat.os.command.dto.request.UpdateOfferTDO;
import com.kat.os.command.service.OfferCommandService;
import com.kat.os.commonDTO.WorkOfferTDO;

import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpStatusCodeException;

import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/command/offers")
public class OfferCommandController {
    private final OfferCommandService commandService;

    public OfferCommandController(OfferCommandService commandService) {
        this.commandService = commandService;
    }

    @PostMapping("/addOffer")
    @PreAuthorize("hasAuthority('SCOPE_ADMIN')")
    public ResponseEntity<CompletableFuture<String>> addOffer(@RequestBody CreateOfferJobTDO offerJobTDO){
        return  ResponseEntity
                .ok()
                .header("status-code","Success  added on server  side")
                .body(this.commandService.createOffer(offerJobTDO));


    }
    

    @PutMapping("/updateOffer")
    @PreAuthorize("hasAuthority('SCOPE_ADMIN')")
    public CompletableFuture<String>  updateOffer(@RequestBody UpdateOfferTDO offerTDO)
    {
        return  this.commandService.updateOffer(offerTDO);
    }

    /*@ExceptionHandler
    public ResponseEntity<String> exceptionHandler(Exception exception){
        return  new ResponseEntity<String>(exception.getMessage(),
                HttpStatus.INTERNAL_SERVER_ERROR);

    }*/

    @ExceptionHandler
    public ResponseEntity<String>  exceptionStatus(Exception exception){
        return ResponseEntity
                .badRequest()
                .header("status-code",exception.getMessage())
                .body(exception.getMessage());
    }

}
