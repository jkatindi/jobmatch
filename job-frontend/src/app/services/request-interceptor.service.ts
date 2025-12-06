import { Injectable } from '@angular/core';
import { HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from "@angular/common/http";
import {Observable} from 'rxjs';
import {AuthenticationService} from "./authentication.service";

@Injectable({
  providedIn: 'root'
})
export class RequestInterceptorService implements HttpInterceptor {

  constructor(private  autheService: AuthenticationService) {
  }

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    if(!req.url.includes("/api/auth/login")){
      let reqToken: any=req.clone({
        headers : req.headers.set('Authorization','Bearer '+this.autheService.accessToken)
      })

      return  next.handle(reqToken);
    }
    else{
      return  next.handle(req)
    }
    }
}
