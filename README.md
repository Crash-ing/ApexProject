<h1>Task 1</h1>
Add a new Case Origin value, "System", to the Case object. <br>
When an Account is created, automatically create a new Case with the following values: <br>
<li>Case Owner = Account Owner</li>
<li>Case Origin = System</li> 
<li>Case Priority = Account Priority</li>
<li>Case Subject = <Account Name> - Onboarding </li>
When a new Contact is added to an Account, and the Contact's Level is set to "Primary", populate that Contact on all related Cases where the Contact field is not already populated. <br>
Important: Complete this task using Apex only.<br> 
 
<h1>Task 2</h1> 
Using Apex, validate that a Contact's age cannot be below the legal age based on the Birthdate field. If the Contact is underage, display the following custom error message: <br>
<b>"All contact persons should be of legal age." </b> <br> <br>
Legal age requirements: <br>
- For Contacts associated with US Accounts, the legal age is 21. <br>
- For Contacts associated with all other Accounts, the legal age is 18. <br> <br>
Additionally, when a Contact's birthday is approaching (2 days in advance), automatically create a new Task with the following details: <br>
<li>Subject: <Contact Name> Birthday! </li>
<li>Owner: Contact Owner </li>
<li>Priority: Low </li>
<li>Due Date: Actual birthdate </li> 
<li>Related To: Contact's Account </li>
<li>Comments: </li>
<b>Today is the birthday of (Contact Name). He/She is now (Age) years old. This Contact is an employee of (Account Name), part of the (Account Industry) industry. Consider making an appropriate gift. The mailing address of the Contact is: (Mailing Address)</b>  <br>
If the Contact's mailing address is not populated, display the following text instead: <br>
<b>The mailing address is unknown.</b>  <br>
Important: Complete this task using Apex only. 
 
