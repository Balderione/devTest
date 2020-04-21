trigger TRIT18_FlagContentDocumentProject on IT_Welfare_Project__c (before update) {
    
    
    IT_Welfare_Project__c project = Trigger.new[0];
   
    List<ContentDocumentLink> cdl = [SELECT id, LinkedEntityId, ContentDocument.Title from ContentDocumentLink where LinkedEntityId  =: project.ID ];
    if ( (cdl.size() == 0) && ( project.IT_Contract__c == true || project.IT_Logo__c == true || 
                               project.IT_Sanitary_Cash_Activation_Form__c == true || project.IT_PO_List__c == true || 
                              project.IT_Graphic_Customization_Form__c == true)) 
    {
        project.addError('Non è possibile aggiungere il flag Allegati: nessun documento allegato');
    }
    system.debug('List ' + cdl.size());
}