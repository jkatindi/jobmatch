package com.kat.os.command.aggregate;

import com.kat.os.command.command.CreateOfferCommand;
import com.kat.os.command.command.UpdateOfferCommand;
import com.kat.os.commonDTO.*;
import com.kat.os.event.OfferCreatedEvent;
import com.kat.os.event.OfferUpdatedEvent;
import org.axonframework.commandhandling.CommandHandler;
import org.axonframework.eventsourcing.EventSourcingHandler;
import org.axonframework.modelling.command.AggregateIdentifier;
import org.axonframework.modelling.command.AggregateLifecycle;
import org.axonframework.spring.stereotype.Aggregate;

import java.util.List;

@Aggregate
public class OfferAggregate {
    @AggregateIdentifier
    private String id;
    private String title;
    private InfoGeneralDTO generalInfo;
    private String  positionHeld;
    private String  generalProfile;
    private List<TechnologyDTO> requiredTechs;
    private List<DegreeDTO>  requiredDegrees;
    private int requiredExperience;
    private int availablePlace;
    public  OfferAggregate(){}

    @CommandHandler
    public OfferAggregate(CreateOfferCommand offerCommand) {
        AggregateLifecycle.apply(new OfferCreatedEvent(
                offerCommand.getId(),
                offerCommand.getTitle(),
                offerCommand.getGeneralInfo(),
                offerCommand.getPositionHeld(),
                offerCommand.getGeneralProfile(),
                offerCommand.getRequiredTechs(),
                offerCommand.getRequiredDegrees(),
                offerCommand.getExperMin(),
                offerCommand.getAvailablePlace()
        ));
    }
    @EventSourcingHandler
    public  void on(OfferCreatedEvent  createdEvent){
        this.id=createdEvent.getId();
        this.title=createdEvent.getTitle();
        this.generalInfo=createdEvent.getGeneralInfo();
        this.positionHeld=createdEvent.getPositionHeld();
        this.generalProfile=createdEvent.getGeneralProfile();
        this.requiredTechs=createdEvent.getRequiredTechs();
        this.requiredDegrees=createdEvent.getRequiredDegrees();
        this.requiredExperience=createdEvent.getExperMin();
        this.availablePlace=createdEvent.getAvailablePlace();
    }
    @CommandHandler
    public void on(UpdateOfferCommand offerCommand) {
        AggregateLifecycle.apply(new OfferUpdatedEvent(
                offerCommand.getId(),
                offerCommand.getTitle(),
                offerCommand.getGeneralInfo(),
                offerCommand.getPositionHeld(),
                offerCommand.getGeneralProfile(),
                offerCommand.getRequiredTechs(),
                offerCommand.getRequiredDegrees(),
                offerCommand.getExperMin(),
                offerCommand.getAvailablePlace()
        ));
    }

    @EventSourcingHandler
    public  void on(OfferUpdatedEvent  updatedEventvent){
        this.id=updatedEventvent.getId();
        this.title=updatedEventvent.getTitle();
        this.generalInfo=updatedEventvent.getGeneralInfo();
        this.positionHeld=updatedEventvent.getPositionHeld();
        this.generalProfile=updatedEventvent.getGeneralProfile();
        this.requiredTechs=updatedEventvent.getRequiredTechs();
        this.requiredDegrees=updatedEventvent.getRequiredDegrees();
        this.requiredExperience=updatedEventvent.getExperMin();
        this.availablePlace=updatedEventvent.getAvailablePlace();
    }

}
