import { Component, OnInit } from '@angular/core';
import { BuildingDetails } from 'src/app/models/building-details.model';

@Component({
  selector: 'buildings',
  templateUrl: './buildings.component.html',
  styleUrls: ['./buildings.component.scss']
})
export class BuildingsComponent implements OnInit {

  buildings: Array<BuildingDetails> = [
    {
      id: "coral_wall",
      name: "Korall fal",
      effects: [{id: 1, name: "asd"}],
      count: 0,
      price: 123
    },
    {
      id: "coral_wall",
      name: "Korall fal",
      effects: [{id: 1, name: "asd"}],
      count: 0,
      price: 123
    }
  ]

  constructor() { }

  ngOnInit(): void {
  }

  asd(){
    console.log('asd');
  }
}
