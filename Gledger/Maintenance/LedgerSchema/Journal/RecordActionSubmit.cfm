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
<cfset jrn = replace(form.journal," ", "","All")> 

	<cfquery name="GetActions" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		select	R.Code, 
				R.Description,
				A.Operational
		from Ref_Action R
		left outer join JournalAction A on R.Code = A.ActionCode and A.journal = '#jrn#'		
	</cfquery>	

	<!---
	<cfquery name="DeleteActions" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		delete	from JournalAction
		where Journal  = '#jrn#'
	</cfquery>	
	--->

	<cfloop query="GetActions">
	
		<cfif isdefined ("form.chk#Code#")>
			<!--- the action is checked--->
			<cfset vActionChecked = Evaluate("FORM.chk#Code#")>
					
			<cfif Operational eq "">
				<!--- the Action was not set for this journal --->
				<cfquery name="InsertAction" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">								
					Insert into JournalAction (
						Journal,
						ActionCode)
					Values (
						'#jrn#',
						'#GetActions.Code#')
				</cfquery>	
				
			<cfelseif Operational eq "0">
				<!--- the Action was set (inactive) for this journal. It must be activated --->
				<cfquery name="UpdateAction" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">								
					Update JournalAction 
						set Operational = 1
					where Journal =	'#jrn#'
					and ActionCode = '#GetActions.Code#'
				</cfquery>	
			
			</cfif>
		
		<cfelse>
			<cfif Operational eq "1">
				<!--- the Action was set for this journal. It must be deactivated --->
				<cfquery name="UpdateAction" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">								
					Update JournalAction 
						set Operational = 0
					where Journal =	'#jrn#'
					and ActionCode = '#GetActions.Code#'
				</cfquery>					
				
			</cfif>
		</cfif>		
		
	</cfloop>
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
