
<cfif url.action eq "0">

<cfquery name="Delete" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ProgramObject 
		WHERE    ProgramCode = '#URL.ProgramCode#'
		AND      Fund        = '#url.fund#'
		AND      ObjectCode  = '#url.object#'		
	</cfquery>

<cfelse>
		
	<cfquery name="CheckEntry" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     ProgramObject 
			WHERE    ProgramCode = '#URL.ProgramCode#'
			AND      Fund        = '#url.fund#'
			AND      ObjectCode  = '#url.object#'		
	</cfquery>
	
	<cfif checkentry.recordcount eq "0">
		
		<cfquery name="Insert" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ProgramObject
			(ProgramCode, ObjectCode,Fund)
			VALUES ('#url.ProgramCode#','#url.Object#','#url.fund#')			
		</cfquery>
	
	</cfif>

</cfif>

<cfquery name="CheckEntry" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ProgramObject 
		WHERE    ProgramCode = '#URL.ProgramCode#'
		AND      Fund        = '#url.fund#'
		AND      ObjectCode  = '#url.object#'		
</cfquery>
	
<cfoutput>
	
	<img src="#SESSION.root#/images/finger.gif" border="0" align="absmiddle">
	
	<cfif Checkentry.recordcount eq "1">	
	  
		<a href="javascript:ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentInquiryEnforce.cfm?action=0&programcode=#url.programcode#&object=#url.object#&fund=#url.fund#&rowguid=#rowguid#','enforce#url.rowguid#')">
		<font color="blue">No records found but this #url.fund# and #url.object# combination will be shown to the requester for selection. </font>
		</a>
			
	<cfelse>
		
		<a href="javascript:ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentInquiryEnforce.cfm?action=1&programcode=#url.programcode#&object=#url.object#&fund=#url.fund#&rowguid=#rowguid#','enforce#url.rowguid#')">
		<font color="0080FF">This #url.fund# and #url.object# combination is not accessible for funding for the requester as there are NO budget/allotment records recorded. </font>
		</a>
			
	</cfif>
	
</cfoutput>