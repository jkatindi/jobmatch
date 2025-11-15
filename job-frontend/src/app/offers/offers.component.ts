import  {ChangeDetectorRef} from '@angular/core';
import {AfterViewInit, Component, OnInit, ViewChild} from '@angular/core';
import {OfferService} from "../services/offer.service";
import {MatTableDataSource} from "@angular/material/table";
import {MatPaginator} from "@angular/material/paginator";
import {JobOffer} from "../models/jobOffer";
import {AuthenticationService} from "../services/authentication.service";
import {Router} from "@angular/router";

@Component({
    selector: 'app-offers',
    templateUrl: './offers.component.html',
    styleUrl: './offers.component.css',
    standalone: false
})
export class OffersComponent implements AfterViewInit{
  public  dataSource!: MatTableDataSource<JobOffer>;
  displayedColumns: string[] = ['id','title', 'availablePlace', 'experMin'];
  @ViewChild('matPaginator') paginator! : MatPaginator;
  constructor(private  serviceOffer: OfferService,private  cdr: ChangeDetectorRef,
              private auth:AuthenticationService,private router: Router) {
  }


  ngOnInit(): void {

       this.serviceOffer.getAllJobOffers().subscribe(
         {
           next:(data)=>{
             this.dataSource=new MatTableDataSource<JobOffer>(data);
             this.cdr.detectChanges();
             this.dataSource.paginator=this.paginator
           }
             ,
             error:(error:any)=>console.log(error)
         })

    }

  ngAfterViewInit(): void {

  }


  applyFilter(event: Event) {
   let value: string=(event.target as HTMLInputElement).value;
   this.dataSource.filter=value;
  }
}
