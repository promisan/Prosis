
<cfquery name="ObjectsSubmit"
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT	*
		FROM  	Ref_Object
		WHERE  	ObjectUsage = '#url.ObjectUsage#'
</cfquery>

<cfif url.entrymode eq "edition">
	
	<cfquery name="ObjectsClear"
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   	DELETE  FROM  	Ref_AllotmentEditionFundObject
			WHERE  	EditionId = '#url.EditionId#'
			AND		Fund = '#url.Fund#'
	</cfquery>
	
	<cfloop query="ObjectsSubmit">
	
		<cfset vCodeId = replace(Code," ","","ALL")>
		<cfset vCodeId = replace(vCodeId,"-","","ALL")>
		
		<cfif isDefined("Form.cb_#vCodeId#")>
		
			<cfset vRequirementDate = "">
			<cfif evaluate("Form.RequirementDate_#vCodeId#") neq "">
				<cfset dateValue = "">
				<cfset selDate = replace(evaluate("Form.RequirementDate_#vCodeId#"),"'","","ALL")>
				<CF_DateConvert Value="#selDate#">
				<cfset vRequirementDate = dateValue>
			</cfif>
			
			<cfparam name="Form.RequirementEntryMode_#vCodeId#" default="1">
			<cfset mode = evaluate("Form.RequirementEntryMode_#vCodeId#")>
			
			<cfquery name="ObjectsInsert"
				datasource="appsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    INSERT INTO Ref_AllotmentEditionFundObject (
							EditionId,
							Fund,
							ObjectCode,
							<cfif trim(vRequirementDate) neq "">RequirementDate,</cfif>
							RequirementEntryMode,
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES (
							'#url.EditionId#',
							'#url.Fund#',
							'#Code#',
							<cfif trim(vRequirementDate) neq "">#vRequirementDate#,</cfif>
							'#Mode#',
							1,
							'#session.acc#',
							'#session.last#',
							'#session.first#' )
			</cfquery>
			
		</cfif>
	
	</cfloop>
		
	<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
	   method           = "RequirementDue" 
	   fund             = "#url.fund#" 
	   editionid        = "#url.editionid#" 
	   period           = "#url.period#">	   	
	
<cfelse>

	<cfquery name="ObjectsClear"
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   	DELETE  FROM  	ProgramAllotmentObject
			WHERE  	ProgramCode = '#url.programcode#'
			AND     Period      = '#url.period#'
			AND     EditionId   = '#url.EditionId#'
			AND		Fund = '#url.Fund#'
	</cfquery>
	
	<cfloop query="ObjectsSubmit">
	
		<cfset vCodeId = replace(Code," ","","ALL")>
		<cfset vCodeId = trim(vCodeId)>
		<cfset vCodeId = replace(vCodeId,"-","","ALL")>
		<cfif isDefined("Form.cb_#vCodeId#")>
		
			<cfset vRequirementDate = "">
			<cfif evaluate("Form.RequirementDate_#vCodeId#") neq "">
				<cfset dateValue = "">
				<cfset selDate = replace(evaluate("Form.RequirementDate_#vCodeId#"),"'","","ALL")>
				<CF_DateConvert Value="#selDate#">
				<cfset vRequirementDate = dateValue>
			</cfif>		
			
			<cfset vRequirementPercentage = evaluate("Form.RequirementPercentage_#vCodeId#")>	
			
			<cfif vRequirementPercentage neq "" and vRequirementDate eq "">
				<cfset vRequirementCutoff = vRequirementPercentage>	
				<cfset mode = "percentage">
			<cfelse>
			    <cfset vRequirementCutoff = vRequirementDate>		
				<cfset mode = "date">
			</cfif>		
			
			<cfif vRequirementCutoff neq "">
			
			<cfquery name="ObjectsInsert"
				datasource="appsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    INSERT INTO ProgramAllotmentObject (
							ProgramCode,
							Period,
							EditionId,
							Fund,
							ObjectCode,
							<cfif trim(vRequirementCutoff) neq "">RequirementMode, RequirementDate,</cfif>														
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES (
					        '#url.programcode#',
							'#url.period#',
							'#url.EditionId#',
							'#url.Fund#',
							'#Code#',
							<cfif trim(vRequirementCutoff) neq "">'#mode#',#vRequirementCutoff#,</cfif>												
							1,
							'#session.acc#',
							'#session.last#',
							'#session.first#' )
			</cfquery>
			
			</cfif>
			
		</cfif>
	
	</cfloop>
		
	<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
	   method           = "RequirementDue" 
	   programcode      = "#url.programcode#"
	   fund             = "#url.fund#" 
	   editionid        = "#url.editionid#" 
	   period           = "#url.period#">	 
	   
	<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#url.ProgramCode#" 
	   Period           = "#url.Period#"
	   EditionId        = "#url.EditionId#">	  

</cfif>	

<!--- now we apply the percentages to the fund and period --->


<!--- apply the percentage --->

<table><tr><td class="labelmedium"><cf_tl id="Saving data for fund"> <cfoutput>#url.fund#</cfoutput>...</td></tr></table>

<cfoutput>
	<script>		
	     	    		 
	     ColdFusion.navigate('FundObjectDetail.cfm?entrymode=#url.entrymode#&programcode=#url.programcode#&systemfunctionid=#url.systemfunctionid#&period=#url.period#&editionId=#url.editionId#&objectUsage=#url.ObjectUsage#&fund=#url.fund#','divFund');			 
 		 try { opener.document.getElementById('refreshbutton').click() } catch(e) {}
		 
	</script>
</cfoutput>