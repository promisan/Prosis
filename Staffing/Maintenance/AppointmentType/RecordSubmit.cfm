<!--
    Copyright © 2025 Promisan B.V.

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
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AppointmentStatus
		WHERE  Code = '#Form.Code#' 
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
		INSERT INTO Ref_AppointmentStatus
		         (Code,
				 Description,
				 ListingOrder,
				 MemoContent,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Code#',
		          '#Form.Description#', 
		          '#Form.ListingOrder#', 
				  '#Form.MemoContent#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		
		<cfinclude template="RecordSubmitMission.cfm">
		
	    </cfif>		  
  
<cfelseif ParameterExists(Form.Update)>

	<cfparam name="Form.Operational" default="0">
	
	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_AppointmentStatus
	SET   Code          = '#Form.Code#',
	      Description   = '#Form.Description#',
		  ListingOrder  = '#Form.ListingOrder#',
		  Operational   = '#Form.Operational#',
		  MemoContent   = '#Form.MemoContent#'
	WHERE Code  = '#Form.CodeOld#'
	</cfquery>
	
	<cfinclude template="RecordSubmitMission.cfm">

<cfelseif ParameterExists(Form.Delete)> 
	
	<cfquery name="CountRec" 
	      datasource="AppsEmployee" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT PersonNo
	      FROM   PersonContract
	      WHERE  AppointmentStatus  = '#Form.CodeOld#' 
	    </cfquery>
	
	    <cfif CountRec.recordCount gt 0>
			 
	     <script language="JavaScript">
	    
		   alert("Code is in use. Operation aborted.")
	     
	     </script>  
		 
	    <cfelse>
				
		<cfquery name="Delete" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_AppointmentStatus
			WHERE Code = '#FORM.CodeOld#'
	    </cfquery>
		
		</cfif>
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
