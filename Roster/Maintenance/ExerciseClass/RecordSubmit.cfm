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

<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ExerciseClass
	WHERE   ExcerciseClass  = '#Form.ExcerciseClass#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A class with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
   <!---
	   
	<CF_RegisterAction 
	SystemFunctionId="0999" 
	ActionClass="Exercise Class" 
	ActionType="Enter" 
	ActionReference="#Form.ExcerciseClass#" 
	ActionScript="">   

	--->

<cfquery name="Insert" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_ExerciseClass
         (ExcerciseClass,
		 Description,
		 Roster,
 		 OrgUnitClass,
		 TreePublish,
		 EntityClass,
		 Source,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.ExcerciseClass#',
          '#Form.Description#', 
		  '#Form.Roster#',
		  '#Form.OrgUnitClass#',
		  '#Form.TreePublish#',
		  '#Form.EntityClass#',
		  '#Form.DefaultSource#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<!---
<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="ExcerciseClass" 
ActionType="Update" 
ActionReference="#Form.ExcerciseClass#" 
ActionScript="">   
--->

<cfparam name="form.Operational" default="0">

<cfquery name="Update" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ExerciseClass
	SET    ExcerciseClass     = '#ExcerciseClass#',
	       Description        = '#Form.Description#',
		   OrgUnitClass		  = '#Form.OrgUnitClass#',
		   TreePublish        = '#Form.TreePublish#',
		   Operational        = '#Form.Operational#',
		   EntityClass		  = '#Form.EntityClass#', 
		   Roster             = '#Form.Roster#',
		   Source			  = '#Form.DefaultSource#'
	WHERE  ExcerciseClass     = '#Form.ExcerciseClassOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	  SELECT ExerciseClass
	      FROM   Ref_SubmissionEdition
    	  WHERE  ExerciseClass  = '#Form.ExcerciseClass#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert(" Exercise class is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
	
	<!---
	
	<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="ExcerciseClass" 
ActionType="Remove" 
ActionReference="#Form.ExcerciseClassOld#" 
ActionScript="">   

	--->
		
	<cfquery name="Delete" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_ExerciseClass
		WHERE  ExcerciseClass = '#FORM.ExcerciseClassOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
