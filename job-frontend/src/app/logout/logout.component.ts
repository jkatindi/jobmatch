import { Component } from '@angular/core';
import {AuthenticationService} from "../services/authentication.service";
import {Router} from "@angular/router";

@Component({
    selector: 'app-logout',
    templateUrl: './logout.component.html',
    styleUrl: './logout.component.css',
    standalone: false
})
export class LogoutComponent {
  constructor(private auth:AuthenticationService,private router: Router) {
  }
  ngOnInit(){
    this.auth.isAuthenticated=false;
    this.auth.username=undefined;
    //this.auth.scope=undefined;
    this.auth.accessToken=undefined;
    this.router.navigateByUrl("/login")
  }
}
