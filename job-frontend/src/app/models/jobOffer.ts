export class  JobOffer{
  id!: number;
  title!: string;
  generalInfo!: InfoGeneral;
  positionHeld!: string;
  generalProfile!: string;
  requiredTechs!: Array<TechSkillOffer>;
  requiredDegrees!: Array<DegreeOffer>;
  experMin!:number;
  availablePlace!: number;
}
export  class  DegreeOffer{
  id!: number;
  degreeName!: string ;
}
export  class  InfoGeneral{
  id!:number;
  localisation!: string;
  companyDescription!: string;
  companyName!: string;
}
export  class TechSkillOffer{
  id!: number;
  technology!: string;
}
