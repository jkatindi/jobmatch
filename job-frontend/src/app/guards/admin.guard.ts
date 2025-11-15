import { CanActivateFn } from '@angular/router';
import {AuthenticationService} from "../services/authentication.service";
import {inject} from "@angular/core";

export const adminGuard: CanActivateFn = (route, state) => {
  let authService=inject(AuthenticationService)
  if(!authService.isAuthenticated){
    return  false;
  }
  else
  return true;
};
