import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {HomeComponent} from "./home/home.component";
import {DashboardComponent} from "./dashboard/dashboard.component";
import {LoginComponent} from "./login/login.component";
import {AdminTempleteComponent} from "./admin-templete/admin-templete.component";
import {DetailsOfferComponent} from "./details-offer/details-offer.component";
import {NewOfferComponent} from "./new-offer/new-offer.component";
import {UpdateOfferComponent} from "./update-offer/update-offer.component";
import {OffersComponent} from "./offers/offers.component";
import {LogoutComponent} from "./logout/logout.component";
import {adminGuard} from "./guards/admin.guard";
import {UserAddComponent} from "./user-add/user-add.component";

const routes: Routes = [
  {path:"login",component: LoginComponent},
  {path:"",redirectTo:"/login",pathMatch:"full"},
  {path:"admin",component: AdminTempleteComponent,canActivate :[adminGuard],children : [
      {path:"detail-offer/:id",component: DetailsOfferComponent},
      {path:"update-offer",component: UpdateOfferComponent},
      {path:"new-offer",component: NewOfferComponent},
      {path:"offers",component:OffersComponent},
      {path:"logout",component: LogoutComponent},
      {path:"home",component: HomeComponent},
      {path:"dashboard",component: DashboardComponent},
      {path:"user-add",component: UserAddComponent}
    ]}


];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
