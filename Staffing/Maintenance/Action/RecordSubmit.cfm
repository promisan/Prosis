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
	
	<cfparam name="form.operational" default="0">
	
	<cfquery name="Verify" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Action
		WHERE  ActionCode  = '#Form.ActionCode#' 
	</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">   
	     alert("A record with this code has been registered already!")     
   </script>  
  
	<cfelse>
	   
	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Action
	         (ActionCode,
			 ActionSource,
			 Description,
			 ModeEffective,
			 EntityClass,
			 Operational,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.ActionCode#',
	          '#Form.ActionSource#',
			  '#Form.Description#',
			  '#Form.ModeEffective#',
			  '#Form.EntityClass#',
			  '#Form.Operational#', 
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
    </cfquery>
			  
	</cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfparam name="form.operational" default="0">

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_Action
	SET  ActionCode    = '#Form.ActionCode#',
	     ActionSource  = '#Form.ActionSource#',
	     Description   = '#Form.Description#',
		 ModeEffective = '#Form.ModeEffective#',
		 Operational   = '#Form.Operational#',
		 EntityClass   = '#Form.EntityClass#'
	WHERE ActionCode   = '#Form.ActionCodeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT ActionCode
      FROM  EmployeeAction
      WHERE ActionCode  = '#Form.ActionCodeOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Action Class is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_Action
			WHERE ActionCode = '#FORM.ActionCodeOld#'
			    </cfquery>
		
		</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
