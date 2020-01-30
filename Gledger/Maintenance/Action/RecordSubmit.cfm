
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 



<cfif ParameterExists(Form.Insert)> 

		<cfquery name="Verify" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Action
		WHERE Code  = '#Form.ActionCode#' 
		</cfquery>
		
	 <cfif #Verify.recordCount# is 1>
		   
		   <script language="JavaScript">
		   
		     alert("An Action with this code has been registered already!")
		     
		   </script>  
  
   <cfelse>
   

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Action
	         (Code,
			 Description,
			 <cfif Form.ListingOrder neq "">ListingOrder,</cfif>
			 LeadDays,
			 MailTextBody,
			 IsOpen,
			 Template,
			 Operational)
	  VALUES ('#Form.ActionCode#', 
	          '#Form.Description#',
			  <cfif Form.ListingOrder neq "">#Form.ListingOrder#,</cfif>
			  #Form.LeadDays#,
	          '#Form.BodyText#',
			  #Form.IsOpen#,
			  '#Form.Template#',
			  #Form.Operational#)
	  </cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>


<cfquery name="Update" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_Action
SET 
Description           = '#Form.Description#',
LeadDays           	  =  #Form.LeadDays#,
<cfif Form.ListingOrder neq "">
ListingOrder          = #Form.ListingOrder#,
</cfif>
MailTextBody         = '#Form.BodyText#',
IsOpen               =  #Form.IsOpen#,
Template             = '#Form.Template#',
Operational			 = #Form.Operational#
WHERE Code   = '#Form.ActionCode#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

 <cfquery name="CountRec" 
      datasource="AppsLedger" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT Journal
      FROM   JournalAction
      WHERE  ActionCode  = '#Form.ActionCode#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
	
	   <script language="JavaScript">
    	   alert("Action code is in use. Operation aborted.")     
        </script>  
	 
    <cfelse>
		
	<cfquery name="Delete" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_Action WHERE Code  = '#Form.ActionCode#' 
    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
     window.close()
	 opener.history.go()
</script>  
