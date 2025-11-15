package com.kat.os.command.service;

import com.kat.os.command.dto.request.CreateOfferJobTDO;
import com.kat.os.command.dto.request.CreateTechDTO;
import com.kat.os.command.dto.request.UpdateOfferTDO;
import com.kat.os.commonDTO.TechnologyDTO;
import com.kat.os.commonDTO.WorkOfferTDO;

import java.util.concurrent.CompletableFuture;

public interface OfferCommandService {
    CompletableFuture<String> createOffer(CreateOfferJobTDO createOfferJobTDO);
    CompletableFuture<String> updateOffer(UpdateOfferTDO updateOfferTDO);
    CompletableFuture<TechnologyDTO> createTechnology(CreateTechDTO techDTO); 

}
