package com.kat.os.command.service;

import com.kat.os.command.command.CreateOfferCommand;
import com.kat.os.command.command.UpdateOfferCommand;
import com.kat.os.command.dto.request.CreateOfferJobTDO;
import com.kat.os.command.dto.request.CreateTechDTO;
import com.kat.os.command.dto.request.UpdateOfferTDO;
import com.kat.os.commonDTO.TechnologyDTO;
import com.kat.os.commonDTO.WorkOfferTDO;
import org.axonframework.commandhandling.gateway.CommandGateway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.concurrent.CompletableFuture;
@Service
public class OfferCommandServiceImp  implements OfferCommandService{
    @Autowired
    private CommandGateway commandGateway;
    @Override
    public CompletableFuture<String> createOffer(CreateOfferJobTDO offerJobTDO) {
        return commandGateway.send(new CreateOfferCommand(
                UUID.randomUUID().toString(),
                offerJobTDO.getTitle(),
                offerJobTDO.getGeneralInfo(),
                offerJobTDO.getPositionHeld(),
                offerJobTDO.getGeneralProfile(),
                offerJobTDO.getRequiredTechs(),
                offerJobTDO.getRequiredDegrees(),
                offerJobTDO.getExperMin(),
                offerJobTDO.getAvailablePlace()
        ));
    }

    @Override
    public CompletableFuture<String> updateOffer(UpdateOfferTDO updateOfferTDO) {
        return this.commandGateway.send(new UpdateOfferCommand(
                updateOfferTDO.getId(),
                updateOfferTDO.getTitle(),
                updateOfferTDO.getGeneralInfo(),
                updateOfferTDO.getPositionHeld(),
                updateOfferTDO.getGeneralProfile(),
                updateOfferTDO.getRequiredTechs(),
                updateOfferTDO.getRequiredDegrees(),
                updateOfferTDO.getExperMin(),
                updateOfferTDO.getAvailablePlace()
        ));
    }

    @Override
    public CompletableFuture<TechnologyDTO> createTechnology(CreateTechDTO techDTO) {
        // TODO Auto-generated method stub
        return null;
    }

   }
