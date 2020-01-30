
<cfparam name="url.delete" default="">
<cfparam name="url.mode"   default="detail">

<cfif url.delete neq "">

	<cfquery name="Action" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ProgramAllotmentDetail
			WHERE    ActionId = '#url.delete#'	
		</cfquery>

	<cfquery name="Action" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ProgramAllotmentAction
			WHERE    ActionId = '#url.delete#'	
	</cfquery>
				
</cfif>

<!--- perform a sync --->

<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#url.ProgramCode#" 
	   Period           = "#url.period#"
	   EditionId        = "#url.Edition#">	
	
<cfif url.mode eq "detail">  
	
	<!--- refreshes the details --->		  
	
	<cfinclude template="AllotmentInquiryDetail.cfm">			 
	
	<!--- refresh the main screen used for data entry this is only for the processing screen --->
	<cfoutput>
		<script>
			ptoken.navigate('#SESSION.root#/programrem/application/budget/allotment/AllotmentInquiryAmount.cfm?scope=detail&programcode=#url.programcode#&period=#url.period#&editionid=#url.edition#&objectcode=#url.object#','moveresult') 	
		</script>
	</cfoutput>		
	
<cfelse>

	<script>
		 history.go()	
	</script>
	
</cfif>	 
