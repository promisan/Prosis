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

<cfparam name="Form.Overwrite" default="0">
<cfparam name="Form.LocationEnabled" default="0">

<cfif ParameterExists(Form.Insert)> 
    
	<cfquery name="Verify" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM stProgramMeasure
	WHERE fileName  = '#Form.FileName#' 
	AND Mission     = '#Form.Mission#'
	AND Period      = '#Form.Period#'
	</cfquery>

   <cfif Verify.recordCount gte 1>
   
   <script language="JavaScript">
   
     alert("A database table name with this name and period has been registered already!")
     
   </script>  
  
   <cfelse>
   				
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO stProgramMeasure
		         (FileName,
				 Mission,
				 DataSource,
				 Period,
				 Overwrite,
				 Operational,
				 Source,
				 LocationEnabled,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.FileName#',
        		  '#Form.Mission#', 
				  '#Form.DataSource#',
				  '#Form.Period#',
				  '#Form.Overwrite#',
				  '#Form.Operational#',
				  '#Form.Source#',
				  '#Form.LocationEnabled#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')</cfquery>
		  	     		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE stProgramMeasure
		SET 
		    FileName  = '#Form.FileName#',
		    Mission   = '#Form.Mission#',
			Period    = '#Form.Period#',
			DataSource = '#Form.DataSource#',
			Overwrite = '#Form.Overwrite#',
			Source    = '#Form.Source#',
			LocationEnabled  = '#Form.LocationEnabled#',
			Operational      = '#Form.Operational#'
		WHERE FileNo = '#URL.FileNo#'		
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 
		
	<cfquery name="Delete" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM stProgramMeasure
WHERE FileNo = '#URL.FileNo#'	
    </cfquery>
			
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  

