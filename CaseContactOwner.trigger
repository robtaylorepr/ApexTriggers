// Homework 3

// 3) Write a trigger that sets the contact owner to whomever most recently 
// created a case on the record

// In the same trigger, set the account owner to whomever most recently 
// created a case on it.



trigger CaseContactOwner on Case (after insert) {
  for (Case myCase : Trigger.new) {

    // Make sure there's a contact for null pointer exceptions
    if (myCase.ContactId != null) {

      // Find the contact for updating
      Contact myCon = [SELECT ContactId
                         FROM Contact
                        WHERE Id = :myCase.ContactId];

      // Update the contact - needs DML
      myCon.OwnerId = myCase.CreatedByID;
      update.myCon;
    }

    // Repeat for the account
    if (myCase.AccountId != null) {

      // Find the account for updating
      Account acc = [SELECT Id
                       FROM Account
                      WHERE Id = :myCase.AccountId];
      acc.OwnerId = myCase.CreatedById;
      update acc;
    }
  }
}