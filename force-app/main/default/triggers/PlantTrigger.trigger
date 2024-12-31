trigger PlantTrigger on Plant__c(before insert, before update) {
  //Trigger.isBefore, Trigger.isInsert...

  //Cuando se crea o actualiza una planta (cambiando su fecha de riego) --> calcular sig fecha riego

  if (Trigger.isInsert || Trigger.isUpdate) {
    //Precargar informacion necesaria de objetos relacionados
    Set<Id> specieIds = new Set<Id>();
    for (Plant__c newPlant : Trigger.new) {
      Plant__c oldPlant = Trigger.oldMap.get(newPlant.id);
      if (
        oldPlant == null ||
        oldPlant.Last_Watered__c != newPlant.Last_Watered__c
      ) {
        specieIds.add(newPlant.Species__c);
      }
    }
    List<Species__c> species = [
      SELECT Summering_Watering_Frequency__c
      FROM Species__c
      WHERE Id IN :specieIds
    ];
    Map<Id, Species__c> speciesById = new Map<Id, Species__c>(species);

    //Si esta cambiando la fecha de riego
    //Trigger.old / Trigger.new / Tregger.oldMap / Trigger.newMap
    //Obtener nuevo valor de la fecha de riego de Trigger.new
    //Obtener nuevo valor de la fecha de riego de Trigger.old
    for (Plant__c newPlant : Trigger.new) {
      Plant__c oldPlant = Trigger.oldMap.get(newPlant.id);
      if (
        oldPlant == null ||
        oldPlant.Last_Watered__c != newPlant.Last_Watered__c
      ) {
        //Calcular sig fecha de riego
        //Ver de que especie es mi planta
        Id specieId = newPlant.Species__c;
        //Traer objeto especie //Hay que hacer solo una Query de Precarga
        //MAL YA QUE SALESFORCE SOLO TRAE De 200 en 200 REGISTROS Species_c specie = [SELECT Summer_Watering_Frequency__c FROM Specie_c WHERE Id = :specieId];
        Species__c specie = speciesById.get(specieId);
        //Pedir freq de riego para esa especie
        Integer daysToAdd = FrequencyService.getwateringDays(specie);
        //sig fecha riego = ultima fecha riego + dias devueltos
        NewPlant.Next_Water__c = newPlant.Last_Watered__c.addDays(daysToAdd);
      }
    }
  }

  //Cuando se crea o actualiza una planta (cambiando su fecha de abonado) --> calcular sig fecha abonado

}
