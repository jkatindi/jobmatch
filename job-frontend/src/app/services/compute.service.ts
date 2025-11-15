import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ComputeService {
  constructor() { }
  
  extract(token: string,keyWord:string): string{
    let i=0;
    let word:string="";
    let find:boolean=false;
    while((i<token.length)&&(!find)){
      let ch=token.charAt(i);
      if(ch=='/'){
         if(word==keyWord)
          find=true;
        else
          word="";
      }
      else{
        word=word+ch;
      }
      i++;
    }
     
    return   token.substring(0, i-word.length-1)+token.substring(i);
    
  }

}
