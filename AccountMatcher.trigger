// AccountMatcher.trigger
// Homework # 5) 
// Move new contact to the matching account based on domain.
/  Contact email domain should match the account’s website domain. 
// Ex: jon@snow.com matches only to an account with a www.snow.com website

// An email like jon@snow.com should also match with the following websites:
// 	http://www.snow.com
// 	https://www.snow.com
// 	snow.com
//	snow.com.eu
//	snow.com.ca

trigger AccountMatcher on Contact (before insert) {
  for (Contact myCon : Trigger.new) {
    if (myCon.Email != null) {
      // Construct various website patters from the email domain
      String domain            = myCon.Email.split('@').get(1);
      String website           = 'www.' + domain;
      String httpWebsite       = 'http://www.' + domain;
      String httpsWebsite      = 'https://www.' + domain;
      String internationalDomain = domain + '.%';

      List<Account> matchingAccounts = 
         [SELECT Id 
            FROM Account
           WHERE Website = :website
              OR Website = :domain
              OR Website = :httpWebsite
              OR Website = :httpsWebsite
              OR Website LIKE :internationalDomain];
        
        // If there is exactly one match, move the contact
        if (matchingAccounts.size() == 1) {
          myCon.AccountId = matchingAccounts.get(0).Id;
        }
    }
  }
}