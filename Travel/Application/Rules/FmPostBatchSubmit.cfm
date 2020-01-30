<!--- 
	FmPostBatchSubmit.cfm
	
	Handles processing of the candidate batch submit page.
	
	Called by: FmPostBatch.cfm
	

--->
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<cfparam name="DateAction" default="#dateformat(now(),CLIENT.DateformatShow)#">

<!--- Start the transaction block --->
<cftransaction action="BEGIN">

<!--- Loop through each person in the batch submit page --->
<cfloop index="Rec" from="1" to="#Form.No#">

<cfif isDefined("Form.PersonNo_"&#Rec#)> <!--- only the records that are checked --->

   <cfset Candidate = Evaluate("Form.PersonNo_" & #Rec#)>
   <cfset PostNumber = Evaluate("Form.PostNumber_" & #Rec#)>
 
 <!--- If this action is completed, or bypassed or revoked... ---> 
 <CFIF #Form.actionStatus# eq "1" or
       #Form.actionStatus# eq "7" or 
	   #Form.actionStatus# eq "9">
	  
	<!--- If the post number is missing (THIS DOES NOT APPLY TO PM STARS, ONLY FOR VACTRACK ) --->  
    <cfif #PostNumber# eq "">
   	   <cftransaction action="ROLLBACK">
	   <script language="JavaScript">
	     alert("You have not identified a Postnumber");
		 history.back()
       </script>
	   <cfexit method="EXITTEMPLATE">
	</cfif>
     
   <cfset dateValue = "">
   <cfif #FORM.ActionDateActual# NEQ "">
	   	<CF_DateConvert Value="#FORM.ActionDateActual#">
   	   	<cfset DateAction = #dateValue#>
   <cfelse>
	    <cfset DateAction = #dateformat(now(),CLIENT.DateformatShow)#>
   </cfif>
   
   <!--- Update DocumentCandidate record with the Post Number (DOES NOT APPLY TO PM STARS) --->
   <cfquery name="UpdateCandidate" datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" password="#SESSION.dbpw#">
    UPDATE DocumentCandidate
    SET PostNumber 		= '#PostNumber#'
    WHERE 	DocumentNo  = '#FORM.DocumentNo#'
	AND 	PersonNo 	= '#Candidate#'
	</cfquery>
   
   <!--- Update this candidate's action record with latest status and effective date --->
   <cfquery name="Update" datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" password="#SESSION.dbpw#">
    UPDATE DocumentCandidateAction
    SET ActionStatus    = '#Form.actionStatus#',	
	ActionDateActual    = #DateAction#,
	ActionUserId        = '#SESSION.acc#',
	ActionLastName      = '#SESSION.last#',
	ActionFirstName     = '#SESSION.first#',	
	ActionDate          = #now()#,	
	ActionMemo          = '#Form.ActionMemo#'
    WHERE 	DocumentNo  = '#FORM.DocumentNo#'
	AND 	PersonNo 	= '#Candidate#'
	AND 	ActionId 	= '#FORM.ActionId#'
    </cfquery>
   
  <!--- else, if the action is NOT APPLICABLE ---> 	
  <CFELSEIF #Form.actionStatus# eq "8" >	
      
    <cfquery name="Check" datasource="#CLIENT.Datasource#" 
      username="#SESSION.login#" password="#SESSION.dbpw#">
      SELECT ActionResetToOrder
      FROM DocumentFlow
	  WHERE ActionId   = '#FORM.ActionId#'
	   AND  DocumentNo  = '#FORM.DocumentNo#'
     </cfquery>
	   
     <cfquery name="Update" 
      datasource="#CLIENT.Datasource#" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      UPDATE DocumentCandidateAction
      SET ActionStatus    = '0',
	  ActionDateActual    = NULL,
	  ActionUserId        = '#SESSION.acc#',
	  ActionLastName      = '#SESSION.last#',
	  ActionFirstName     = '#SESSION.first#',	
	  ActionDate          = #now()#,
	  ActionMemo          = '#Form.ActionMemo#'	
      WHERE DocumentNo     = '#FORM.DocumentNo#'
	  AND PersonNo = '#Candidate#'
	  AND ActionOrder >= '#Check.ActionResetToOrder#'
     </cfquery>
	
  </CFIF>	
 
<!--- User action logging --->

<cf_DocumentActionNo 
    ActionRemarks="" 
   ActionCode="ACT">  
	   
   <cfset ActionNo = #UserActionNo#>

<!--- roster action line --->

    <cfquery name="DocumentActionAction" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    INSERT INTO  DocumentActionAction
      (DocumentNo,
	  PersonNo,
      ActionId, 
      UserActionNo, 
      ActionDateActual,
	  ActionStatus)
    VALUES 
      ('#Form.DocumentNo#',
	  '#Candidate#',
      '#Form.ActionId#',
      #ActionNo#,
      #DateAction#,
      '#Form.actionStatus#')
   </cfquery> 
   
<cfelse>

 <!--- skip --->  

</cfif>

</cfloop>  

<cftransaction action="COMMIT">
</cftransaction>

<!--- audit the central trail --->

<cfloop index="Rec" from="1" to="#Form.No#">

<cfif isDefined("Form.PersonNo_"&#Rec#)> 

   <cfset Candidate = Evaluate("Form.PersonNo_" & #Rec#)>

   <CF_RegisterAction 
   SystemFunctionId="1101" 
   ActionClass="Document" 
   ActionType="Update Candidate" 
   ActionReference="#FORM.DocumentNo# #Candidate#" 
   ActionScript="">  
   
</cfif>   
   
</cfloop>   
   
  <script>
      window.close()
      opener.location.reload()
  </script>