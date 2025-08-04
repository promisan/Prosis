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
<cfparam name="URL.Mission" default="">
<cfparam name="URL.ItemNo" default="">
<cfparam name="URL.Mode" default="Entry">
<cfparam name="URL.FieldName" default="">
<cfparam name="client.ProgramCode" default="">


<cfif URL.Mode eq "Entry"> 

	<cfquery name="qItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   	SELECT * 
   	FROM   Item
   	WHERE  ItemNo = '#URL.ItemNo#'
	</cfquery>

	<cfquery name="qProgram" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   	SELECT   * 
	   	FROM     Program P
	   	WHERE    ProgramClass = 'Project'
		
	   	-- AND      Mission = '#url.mission#'
	   	ORDER BY P.Mission, P.Created DESC	      
	</cfquery>	
	
	<cf_uiselect style="width:400px" name="programcode" id="programcode" class="regularxl" group="Mission" query = "#qProgram#" queryPosition  = "below" filter="contains"
			value= "ProgramCode" display="ProgramName" selected="#qItem.ProgramCode#">	
	    	<option value="">--<cf_tl id="Undefined">--</option>					
	</cf_uiselect>	
		
<cfelse>

	<cfif URL.FieldName neq "">
		
		<cfif url.mission neq "">
		
			<cfquery name="qProgram" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	   			SELECT   DISTINCT P.Mission, P.ProgramCode,P.ProgramName,P.Created  
	   			FROM     Program P INNER JOIN Materials.dbo.Item I ON P.ProgramCode = I.ProgramCode 
	   			WHERE    P.ProgramClass = 'Project'
	   			AND      P.Mission = I.Mission 
	 			-- AND   P.Mission = '#url.mission#'
	   			ORDER BY P.Mission, P.Created DESC	   
			</cfquery>		
			
			<cfoutput>
			
			<cf_uiselect style="width:400px" name="#url.fieldName#" id="#url.fieldName#" class="regularxl" group="Mission" query = "#qProgram#" queryPosition  = "below"
					value = "ProgramCode" display = "ProgramName" selected="#client.programcode#" filter="contains">	
		    	<option value="">--<cf_tl id="Any">--</option>					
			</cf_uiselect>
			
			</cfoutput>
			
	 	<cfelse>
		
	 		<INPUT type="hidden" name="#url.fieldName#" id="#url.fieldName#" value="">
	 	
	  	</cfif>	
	</cfif>

</cfif>	
