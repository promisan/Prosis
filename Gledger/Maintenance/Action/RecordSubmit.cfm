<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
