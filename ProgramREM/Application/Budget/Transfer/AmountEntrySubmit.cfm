
<cfoutput>

<cfparam name="url.serialNo" default="">

<cfparam name="form.programcode#url.direction#" default="">
<cfparam name="form.objectcode#url.direction#" 	default="">
<cfparam name="form.fundcode#url.direction#" 	default="">
<cfparam name="form.cleared#url.direction#" 	default="">
<cfparam name="form.amount#url.direction#" 		default="">

<cfset program            = evaluate("form.program")>
<cfset contributionlineid = evaluate("form.contributionlineid")>
<cfset programcode        = evaluate("form.programcode#url.direction#")>
<cfset objectcode         = evaluate("form.objectcode#url.direction#")>
<cfset fundcode           = evaluate("form.fundcode#url.direction#")>

<cfset cur                = evaluate("form.cleared#url.direction#")>
<cfset amt                = evaluate("form.amount#url.direction#")>

<cfif programcode neq "" and objectcode neq "" and fundcode neq "">
	
	<cfset cur = replace(cur,',','',"ALL")>
	<cfset cur = replace(cur,' ','',"ALL")>
		
	<cfset amt = replace(amt,',','',"ALL")>
	<cfset amt = replace(amt,' ','',"ALL")>
		
	<cfif not LSIsNumeric(amt)>
	
		<script>
		    alert("Incorrect Amount")
			ptoken.navigate('TransferDialogLines.cfm?mission=#url.mission#&actionclass=#url.actionclass#&program=#program#&direction=#url.direction#&editionid=#Form.editionid#&period=#Form.Period#','lines#url.direction#')
		</script>	 
		
		<cfabort>
	
	</cfif>
	
	<cfif amt lt 0 and (abs(amt) gt cur)>
		
		<script>
		    alert("You may not transfer more than currently alloted.")
			ptoken.navigate('TransferDialogLines.cfm?mission=#url.mission#&actionclass=#url.actionclass#&program=#program#&direction=#url.direction#&editionid=#Form.editionid#&period=#Form.Period#','lines#url.direction#')
			ptoken.navigate('TransferProcess.cfm','process')			
		</script>	 
		
		<cfabort>
	
	</cfif>
	
	<cfif url.direction eq "from" and url.actionClass eq "Transfer">
		 <cfset amt = -1*amt>
	</cfif>
	
	<cfif url.serialNo eq "">
	
		<cfquery name="Amount" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			INSERT INTO dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 
				
				(EditionId,
				 Period,
				 ActionClass,
				 ProgramCode,
				 ContributionLineId,
				 Fund,
				 ObjectCode,
				 AmountCurrent,
				 Amount)
				
			VALUES
			
				('#form.EditionId#',
				 '#form.period#',
				 '#form.actionclass#',
				 '#programcode#',
				 <cfif contributionlineid neq "">
				 '#contributionlineid#',
				 <cfelse>
				 NULL,
				 </cfif>
				 '#fundcode#',
				 '#objectcode#',
				 #cur#,
				 #amt#)		
				 
		</cfquery>	
	
	<cfelse>
	
		<cfquery name="Amount" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 
			SET    ProgramCode        = '#programcode#',
				   <cfif contributionlineid neq "">
				   ContributionLineId = '#contributionlineid#',
				   </cfif>
			       Fund               = '#fundcode#',
				   ObjectCode         = '#objectcode#',
				   AmountCurrent      = #cur#,
				   Amount             = #amt#
			WHERE  SerialNo           = '#url.serialNo#'				
		</cfquery>	
		
	</cfif>	
		
</cfif>	

<!--- refresh result set --->

<script language="JavaScript">

	ptoken.navigate('TransferDialogLines.cfm?mission=#url.mission#&processmode=#url.processmode#&actionclass=#url.actionclass#&program=#program#&direction=#url.direction#&editionid=#Form.editionid#&period=#Form.Period#&resource=#Form.Resource#','lines#url.direction#')
	ptoken.navigate('TransferProcess.cfm','process')	
	
</script>

</cfoutput>

<cf_compression>