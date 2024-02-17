Source: https://www.ng-conf.org/mocking-dependencies-angular/

Just add `NO_ERRORS_SCHEMA` to you Test file and you dont have to care about imports from other components. You can still test normally with spies, Mocks or other ways.

```
import { TestBed, inject } from '@angular/core/testing';

import { ComponentToTest } from './componentToTest';
import { SomeService } from 'app/service';
import { NO_ERRORS_SCHEMA } from '@angular/core';

describe('ReleaseInfoService', () => {
 let component: AddFilterComponent;
 let fixture: ComponentFixture<AddFilterComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declaration: [ComponentToTest],
      providers: [SomeService],
      schemas: [NO_ERRORS_SCHEMA]
    });
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ComponentToTest);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });



  it('should be created') => {
    expect(component).toBeTruthy();
  }));
});
```
