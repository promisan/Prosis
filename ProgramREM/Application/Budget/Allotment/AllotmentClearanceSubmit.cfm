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

<!--- quick clearance for snapshot or not previously recorded transactional 
                                       or reverted to snapshot --->

<cf_tl id="Cleared" var="1">
<cfset vCleared=lt_text>

<cftransaction>

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       Ref_AllotmentEdition
	WHERE      ControlEdit = '1'	   
	AND        EditionId = '#url.editionid#'
</cfquery>

<cfoutput query="Edition">

	<!--- create a header logging action record --->
	    	
    <cfquery name="Check" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT     P.Status, E.EntryMethod, E.EditionClass
     FROM       Ref_AllotmentEdition E, ProgramAllotment P
     WHERE      P.EditionId = '#EditionId#'	
	 AND        E.EditionId = P.EditionId
	 AND        P.ProgramCode = '#url.ProgramCode#'
	 AND        P.Period = '#url.period#'
	 </cfquery>
			
	<cfif Check.Status eq "0" or Check.EntryMethod eq "Snapshot"> <!--- handle as snapshot --->
		
		<cfquery name="Insert" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ProgramAllotmentAction
					(ProgramCode,
					 Period,
					 EditionId,
					 ActionClass, 					 
					 ActionType, 
					 Status,
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 Created)
			VALUES ('#URL.ProgramCode#',
			        '#url.Period#',
					'#EditionId#',
					'Snapshot', 					
					'Approved',
					'1',
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#', 
					getDate())
	      </cfquery>  
	      
		   <cfquery name="SetHeader" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE     ProgramAllotment
				SET        Status = '1'
				WHERE      ProgramCode = '#url.programcode#'	   
				AND        Period      = '#url.period#'
				AND        EditionId   = '#EditionID#' 
		   </cfquery>
		  									
		  <cfquery name="ApproveTransaction" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE     ProgramAllotmentDetail
			SET        Status      = '1'
			WHERE      ProgramCode = '#url.programcode#'	
			AND        Period      = '#url.period#'   
			AND        EditionId   = '#EditionID#'
		  </cfquery>  
	  
	  <cfelse>
	  
	 	 <!--- handle transactional in dialog --->	  
	  
	  </cfif>
	
</cfoutput>

<font color="00BB00">
<cfoutput>#vCleared#</cfoutput>

</cftransaction>

