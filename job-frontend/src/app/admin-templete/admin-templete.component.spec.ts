import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AdminTempleteComponent } from './admin-templete.component';

describe('AdminTempleteComponent', () => {
  let component: AdminTempleteComponent;
  let fixture: ComponentFixture<AdminTempleteComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [AdminTempleteComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(AdminTempleteComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
