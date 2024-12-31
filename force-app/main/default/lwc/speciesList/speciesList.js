import { LightningElement, wire } from "lwc";
import getFilteredSpecies from "@salesforce/apex/SpeciesService.getFilteredSpecies";

export default class SpeciesList extends LightningElement {
  //PROPERTIES
  searchText = "";

  //LIFECYCLE HOOKS

  //WIRE

  @wire(getFilteredSpecies, { searchText: "$searchText" })
  species;

  //METHODS
  handleInputChange(event) {
    //metodo
    const searchTextAux = event.target.value; //Varable donde se guardara el escrito del input
    console.log("Texto recibido" + searchTextAux);
    if (searchTextAux.length >= 3 || searchTextAux === "") {
      //si el escrito es mayor o igual a 3 y si no va vacio
      this.searchText = searchTextAux;
    }
  }
}
