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
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Group
WHERE GroupCode  = '#Form.GroupCode#' 
</cfquery>


<cfif #Verify.recordCount# is 1>
   
	<script language="JavaScript">
	   
	     alert("a record with this code has been registered already!")
	     
	</script>  
  
<cfelse>
 
	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Group
	         (GroupCode,
			 GroupDomain,
			 Description,
			 ShowInView,
			 ShowInColor,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	  VALUES ('#Form.GroupCode#',
	          '#Form.GroupDomain#',
	          '#Form.Description#',
			  '#Form.ShowInView#',
			  '#Form.ShowInColor#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())</cfquery>
			  
	 </cfif>
	 
	 <!--- Missions --->
	  
	  <cfif isDefined("Form.Mission") and Form.Mission neq "">
	  
	  <cfloop index="mis" list="#Form.Mission#">
	  
		<cfquery name="Insert" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_GroupMission
					         (GroupCode,
							 Mission,				
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				  VALUES ('#Form.GroupCode#',
				          '#mis#', 				
						  '#SESSION.acc#',
			    		  '#SESSION.last#',		  
					  	  '#SESSION.first#')
		</cfquery>
		  	  
	  </cfloop>
	  
	  </cfif>
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfparam name="Form.Operational" default="0">

	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Group
		
		SET    GroupCode      = '#Form.GroupCode#',
		       Description    = '#Form.Description#',
			   GroupDomain    = '#Form.GroupDomain#',
			   ShowInView     = '#Form.ShowInView#',
			   ShowInColor    = '#Form.ShowInColor#',
			   Operational    = '#Form.Operational#'
			  
		WHERE  GroupCode      = '#Form.GroupCodeOld#'
	</cfquery>
	
	<cfquery name="Clear" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_GroupMission	
		WHERE  GroupCode    = '#Form.GroupCode#'
	</cfquery>
		
	<cfif isDefined("Form.Mission") and Form.Mission neq "">
	  
		  <cfloop index="mis" list="#Form.Mission#">
		  
			<cfquery name="Insert" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_GroupMission
						         (GroupCode,
								 Mission,				
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
					  VALUES ('#Form.GroupCode#',
					          '#mis#', 				
							  '#SESSION.acc#',
				    		  '#SESSION.last#',		  
						  	  '#SESSION.first#')
			</cfquery>
			  	  
		  </cfloop>
	  
	</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
	      datasource="AppsEmployee" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT PositionGroup as GroupCode
	      FROM  PositionGroup
	      WHERE PositionGroup  = '#Form.GroupCodeOld#' 
		  UNION
		  SELECT AssignmentGroup as GroupCode
		  FROM PersonAssignmentGroup
	      WHERE AssignmentGroup  = '#Form.GroupCodeOld#' 
	</cfquery>
	
	<cfif #CountRec.recordCount# gt 0>
	
		<script language="JavaScript">
		
			alert("Group reference is in use. Operation aborted.")
		
		</script>  
	
	<cfelse>
	
		<cfquery name="Delete" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_Group
		WHERE GroupCode = '#FORM.GroupCodeOld#'
		</cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
