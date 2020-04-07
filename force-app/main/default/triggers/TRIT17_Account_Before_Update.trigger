trigger TRIT17_Account_Before_Update on Account(before insert, before Update) {
 for (Account singleAcc: trigger.new) {
  if (!String.isEmpty(singleAcc.ER_VAT_Number__c) ) {
  if (singleAcc.ER_BUPicklist__c == 'IT') {
   if (trigger.isUpdate) {

    if (singleAcc.ER_VAT_Number__c.isNumeric()) {
     if (trigger.newMap.get(singleAcc.Id).ER_VAT_Number__c != trigger.oldMap.get(singleAcc.Id).ER_VAT_Number__c) {

      IF(APIT00_CheckVAT.ValidatePartitaIVA(trigger.newMap.get(singleAcc.Id).ER_VAT_Number__c) == FALSE) {
       singleAcc.addError('Partita Iva non valida');
      }
      system.debug('dentro');
     }
    } else {
     singleAcc.addError('Partita Iva non valida, inserire solo cifre');
    }
   } else {
    if (singleAcc.ER_VAT_Number__c.isNumeric()) {
     IF(APIT00_CheckVAT.ValidatePartitaIVA(singleAcc.ER_VAT_Number__c) == FALSE) {
      singleAcc.addError('Partita Iva non valida');
     }
    } else {
     singleAcc.addError('Partita Iva non valida, inserire solo cifre');
    }
   }
  }
  }
 }
}