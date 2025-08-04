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
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_SubPeriod
WHERE SubPeriod  = '#Form.SubPeriod#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A milestone with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
<cfquery name="Insert" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_SubPeriod
         (SubPeriod,
		 Description,
		 DescriptionShort,
		 DisplayOrder,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.SubPeriod#',
          '#Form.Description#', 
		  '#Form.DescriptionShort#',
		  '#Form.DisplayOrder#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_SubPeriod
SET 
    SubPeriod       = '#Form.SubPeriod#',
    Description    = '#Form.Description#',
	DescriptionShort    = '#Form.DescriptionShort#',
	DisplayOrder    = '#Form.DisplayOrder#'
WHERE SubPeriod        = '#Form.SubPeriodOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT ActivityPeriodSub as SubPeriod
      FROM ProgramActivityOutput
      WHERE ActivityPeriodSub  = '#Form.SubPeriodOld#' 
	  UNION
	  SELECT DISTINCT SubPeriod
	  FROM ProgramIndicatorTarget
	  WHERE SubPeriod  = '#Form.SubPeriodOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Code is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    DELETE FROM Ref_SubPeriod
    WHERE SubPeriod = '#FORM.SubPeriodOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
