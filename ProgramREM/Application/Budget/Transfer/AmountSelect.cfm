
<!--- show the current values --->

<cfparam name="editionid" default="#url.editionid#">
<cfparam name="period" default="#url.period#">
<cfparam name="programcode" default="#url.programcode#">
<cfparam name="fund" default="#url.fund#">
<cfparam name="objectcode" default="#url.objectcode#">

<cfoutput>

	<cfquery name="Amount" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    SUM(Amount) as Amount
			FROM      ProgramAllotmentDetail
			WHERE     ProgramCode = '#programcode#'
			AND       Period      = '#period#'
			AND       EditionId   = '#editionid#' 
			AND       ObjectCode  = '#objectcode#'
			AND       Fund        = '#fund#'
			<cfif url.status eq "Pending">
			AND       Status = '0'
			<cfelse>
			AND       Status = '1'
			</cfif>
	</cfquery>	
			 
	<input type="text"
		   size="10" id="#url.status##url.direction#" 
		   name="#url.status##url.direction#" 
		   style="text-align:right;width:96%;border:0px;" 
		   class="regularxl" 
		   value="#numberformat(Amount.Amount,',.__')#" readonly>		   
				
</cfoutput>


