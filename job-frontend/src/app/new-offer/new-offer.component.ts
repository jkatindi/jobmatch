import {Component, ElementRef, ViewChild} from '@angular/core';
import {AuthenticationService} from "../services/authentication.service";
import {Router} from "@angular/router";
import {DegreeOffer, InfoGeneral, JobOffer, TechSkillOffer} from "../models/jobOffer";
import {OfferService} from "../services/offer.service";
import {FormBuilder, FormGroup} from "@angular/forms";
import {COMMA, ENTER} from "@angular/cdk/keycodes";
import {MatAutocomplete, MatAutocompleteSelectedEvent} from "@angular/material/autocomplete";
import {map, Observable, startWith} from "rxjs";
import {MatChipInputEvent,MatChipsModule} from "@angular/material/chips";

@Component({
    selector: 'app-new-offer',
    templateUrl: './new-offer.component.html',
    styleUrl: './new-offer.component.css',
    standalone: false
})
export class NewOfferComponent {
  offer=new JobOffer();
  selectable = true;
  visible = true;
  isLinear = true;
  removable = true;
  separatorKeysCodes: number[] = [ENTER, COMMA];
  addOnBlur = true;
  responseServer!: any;
  titleForm!: FormGroup;
  companyForm!: FormGroup;
  experienceForm!: FormGroup;
  techsForm!: FormGroup;
  selectItem: number[] = [];
  degrees!: Observable<DegreeOffer[]>;
  techSkills: any[] = [];
  technologies!: TechSkillOffer[];
  filteredTechs!: Observable<TechSkillOffer[]>;
  @ViewChild('techInput') techInput!: ElementRef<HTMLInputElement>;
  @ViewChild('auto') matAutocomplete!: MatAutocomplete;

  constructor(private authService: AuthenticationService, private serviceOffer: OfferService, private router: Router,
              private fb: FormBuilder) {
  }

  ngOnInit() {
    this.degrees=this.serviceOffer.getAllDegrees();
    console.log(this.degrees);
    this.serviceOffer.getAllTechnologies()
      .subscribe(data=>this.technologies=data)

    for (let i = 1; i < 20; i++) {
      this.selectItem.push(i)
    }
     this.titleForm = this.fb.group({
      title : this.fb.control(""),
      positionHeld : this.fb.control(""),
      availablePlace : this.fb.control("")
    });

    this.companyForm = this.fb.group({
      localisation : this.fb.control(""),
      companyDescription : this.fb.control(""),
      companyName : this.fb.control("")
    })

    this.techsForm = this.fb.group({
      generalProfil : this.fb.control(""),
      requiredTechs : this.fb.control(""),
      requiredDegrees : this.fb.control(""),
      experMin : this.fb.control("")
    })

    this.filteredTechs = this.techsForm.controls['requiredTechs'].valueChanges
      .pipe(startWith(null),
        map((tech: TechSkillOffer | null) => tech ? this._filter(tech) : this.technologies));

  }


  private _filter(tech: TechSkillOffer): TechSkillOffer[] {
    const valFilter = tech.technology.toLowerCase();
    return this.technologies.filter(tech => tech.technology.toLowerCase().indexOf(valFilter) === 0);


  }

  selected(event: MatAutocompleteSelectedEvent): void {
    let techSkill={
      id: event.option.value['id'],
      technology: event.option.value['technology']
    };

    let found=this.techSkills.map(value=>value.technology)
      .includes(techSkill.technology)
    if(!found) this.techSkills.push(techSkill);

    this.techInput.nativeElement.value = '';
    this.techsForm.controls['requiredTechs'].setValue(null);

  }

  add(event: MatChipInputEvent): void {
    const input = event.input;
    const value = event.value;
    if ((value || ''))
      this.techSkills.push(value);
    if(input){
      input.value='';
    }

    this.techsForm.controls['requiredTechs'].setValue(null);
  }

  remove(tech: TechSkillOffer): void{
    const  index=this.techSkills.indexOf(tech);
    if(index>=0){
      this.techSkills.splice(index,1);
    }
  }


  addNewOffer() {
    this.offer.title=this.titleForm.value.title;
    this.offer.positionHeld=this.titleForm.value.positionHeld;
    this.offer.availablePlace=this.titleForm.value.availablePlace;

    let genInfo=new InfoGeneral();
    genInfo.companyName=this.companyForm.value.companyName;
    genInfo.companyDescription=this.companyForm.value.companyDescription;
    genInfo.localisation=this.companyForm.value.localisation;
    this.offer.generalInfo=genInfo;

    this.offer.generalProfile=this.techsForm.value.generalProfil;
    this.offer.requiredTechs=this.techSkills;
    this.offer.requiredDegrees=this.techsForm.value.requiredDegrees;
    this.offer.experMin=this.techsForm.value.experMin;
    this.serviceOffer.addNewJobOffer(this.offer)
      .subscribe({
        next: value => {
          this.responseServer = "Success add  new job offer"
          this.offer = value;
        },
        error: err => {
          this.responseServer = err.message
        }
      })
  }


}
