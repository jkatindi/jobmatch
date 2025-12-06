import { Injectable } from '@angular/core';
import { HttpClient } from "@angular/common/http";
import {AuthenticationService} from "./authentication.service";
import {Observable} from "rxjs";
import {JobOffer} from "../models/jobOffer";
import {environment} from "../../environments/environment";
import { ComputeService } from './compute.service';

@Injectable({
  providedIn: 'root'
})
export class OfferService {
  remote_host: any=environment.BACKEND_HOST+"/api";
  jobOffers!:JobOffer;
  

  constructor(private  http: HttpClient,private authService: AuthenticationService,private computeService:ComputeService) {
  
  }


  getAllJobOffers(): Observable<JobOffer[]> {
    return  this.http.get<Array<JobOffer>>(this.remote_host+"/query/offers/all");
  }



  getJobOfferById(id:string): Observable<JobOffer> {
    return  this.http.get<JobOffer>(this.remote_host+"/query/offers/all/"+id);
  }

  updateJobOff(job: JobOffer): Observable<any>{
    return  this.http.put(this.remote_host+"/command/offers/updateOffer",job);

  }

  addNewJobOffer(offer: JobOffer): Observable<any>{
    return this.http.post(this.remote_host+"/command/offers/addOffer",offer)

  }

  getOneTechnology(id:number): Observable<any>{
    return  this.http.get(this.remote_host+"/query/technologies/"+id)

  }

  getAllTechnologies(): Observable<any>{
    return  this.http.get<Array<any>>(this.remote_host+"/query/technologies/all");
  }

  getOneDegree(id:number): Observable<any>{
    return  this.http.get<any>(this.remote_host+"/query/degrees/"+id);
  }

  getAllDegrees(): Observable<any>{
    return  this.http.get<Array<any>>(this.remote_host+"/query/degrees/all");
  }


}
