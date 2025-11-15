import {ChangeDetectorRef, Component} from '@angular/core';
import {AuthenticationService} from "../services/authentication.service";
import {Route, Router} from "@angular/router";
import {FormBuilder, FormGroup} from "@angular/forms";
import {jwtDecode} from "jwt-decode";
import { ComputeService } from '../services/compute.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  roles : any;
  username: any;
  formLogin!: FormGroup;
  jwtdecode!: any;
  error!: any;
  constructor(private fb: FormBuilder,protected  authService: AuthenticationService,
              private router: Router,private computeServ:ComputeService) { }

  ngOnInit(): void {
    this.formLogin=this.fb.group({
      username : this.fb.control(""),
      password : this.fb.control("")
    })
  }


  handleConnexion() {
    let username=this.formLogin.value.username
    let password=this.formLogin.value.password
    this.authService.login(username,password)
      .subscribe({
        next: data => {
          this.authService.loadProfile(data);
          this.router.navigateByUrl("/admin")
        },
        error: err => {
          this.error="Wrong  login  or  password";
        }
      })
  }
  tester(){
    console.log(this.formLogin.value.username)
  }
}
