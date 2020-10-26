// Homework #4
// 4) When an account phone number is updated, all related contacts must have 
// their “Other Phone” updated to this number

// Do not update the contact phone number if it’s country doesn’t match the /;;
// account’s.

trigger UpdateContactPhone on Account (before update) {
  for (Account acc : Trigger.new) {
    // Make sure teh phone number is populated
    if (acc.Phone != null) {
      // Find all relevant contacts
      List<Contact> contacts = 
         [SELECT Id
                 MailingCountry
            FROM Contact
           WHERE AccountId = :acc.Id];
      // Loop through and update each contact
      for (Contact myCon : contacts) {
        if (myCon.MailingCountry != null && 
            myCon.MailingCountry == acc.BillingCountry) {
              myCon.OtherPhone = acc.Phone;
            }
      }
      update contacts;
    }
  }
}