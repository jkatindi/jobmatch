import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from "@angular/common/http";
import {environment} from "../../environments/environment";
import {jwtDecode} from "jwt-decode";
import { ComputeService } from './compute.service';

@Injectable({
  providedIn: 'root'
})
export class AuthenticationService {
  accessToken!: any;
  isAuthenticated: boolean=false;
  roles!: any[];
  username: any;
  server:string=environment.BACKEND_HOST+"/api";
  constructor(private  http: HttpClient,private computeService:ComputeService) { }

  ngOnInit():void{

  }

  public  login(username: string, password: string){
    let options={
      headers: new HttpHeaders().set("Content-Type","application/x-www-form-urlencoded")
    }
    let params=new HttpParams()
      .set("username",username)
      .set("password",password)
    return this.http.post(this.server+"/auth/login",params,options)
  }


  loadProfile(data: any) {
    this.isAuthenticated=true;
    this.accessToken=data['access-token'];
    this.username=jwtDecode(this.accessToken).sub
  }
}
