trigger QuoteOnDemandSyncTrigger on zqu__Quote__c ( after update ) 
{
  if ( Trigger.isUpdate && Trigger.isAfter )
  {
    List<zqu__Quote__c> quotes = Trigger.new; 
    List<zqu__Quote__c> oldQuotes = Trigger.old; 
    Map<Id, String> idSubMap = new Map<Id, String>();
    for ( zqu__Quote__c oldQuote : oldQuotes )
    {
      idSubMap.put( oldQuote.id, oldQuote.zqu__ZuoraSubscriptionID__c );
    }
    Set<String> zuoraAccountIdSet = new Set<String>();
    for ( zqu__Quote__c quote : quotes )
    {
      String oldSubscriptionId = idSubMap.get( quote.id );
      String newSubscriptionId = quote.zqu__ZuoraSubscriptionID__c; 
      System.debug( 'Old subscription id = ' + oldSubscriptionId + ', newSubscripitonId = ' + newSubscriptionId );
      if ( oldSubscriptionId != newSubscriptionId )
      {
        zuoraAccountIdSet.add( quote.zqu__ZuoraAccountID__c);
      }
    }
    if ( zuoraAccountIdSet.size() > 0 )
    {
      Zuora.OnDemandSyncManager syncManager = new Zuora.OnDemandSyncManager();
      syncManager.syncZuoraObjectIdSet = zuoraAccountIdSet; 
      syncManager.sendRequest();
    }
  }
}