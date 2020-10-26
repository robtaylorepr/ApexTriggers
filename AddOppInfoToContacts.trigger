// AddOppInfoToContacts
// 6) When a new opportunity is created, all contacts on the corresponding 
// account need to have the following info add to their description
// - Opp creators name
// - Opp close date

// Also include the following fields:
// - Opp Owner’s ame
// - Opp owner’s manager name

trigger AddOppInfoToContacts on Opportunity (after insert) {

  for (Opportunity opp : Trigger.new) {
    if (opp.AccountId != null) {
      // Get all contacts we need to update]
      List<Contact> contacts = 
         [SELECT Id,
                 description
            FROM Contact
           WHERE AccountId = :opp.AccountId];
      
      // Get opp with additional info
      Opportunity oppWithRelatedInfo =
         [SELECT CreatedBy.Name,
                 Owner.Name,
                 Owner.Manager.Name
            FROM Opportunity
           WHERE Id = :opp.Id];

      String opportunieyInfo = 'New opportunity created by '
                             + oppWithRelatedInfo.CreatedBy.Name 
                             + ' with close date '
                             + String.valueOf(opp.CloseDate)
                             + '.\n'
                             + 'The owner of the opp is '
                             + oppWithRelatedInfo.Owner.Name 
                             + ' '
                             + 'and this person\'s manager is '
                             + oppWithRelatedInfo.Owner.Manager.Name 
                             + '.';
      
      if (!contacts.isEmpty()) {
        for (Contact myCon : contacts) {
          String newContactDesc = opportunityInfo;

          // Add the existing contact descripptionto the end if it exists
          if (myCon.Description != null) {
            newContactDesc += '\n\n' + myCon.Description;
          }
          myCon.Description = newContactDesc;
        }
        update contacts;
      }
    }
  }
}