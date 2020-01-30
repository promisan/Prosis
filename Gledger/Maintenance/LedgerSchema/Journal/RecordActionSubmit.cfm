

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
