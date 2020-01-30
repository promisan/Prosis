	
	<cfquery name="Cover" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM  ApplicantFunctionDocument
		WHERE ApplicantNo         = '#URL.ID#' 
		AND   FunctionId          = '#URL.ID1#'
	</cfquery>
	
	<cfif cover.recordcount gt 0 and len(cover.documenttext) gte "5">

		
		<tr><td colspan="2">
		
       		<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0" class="regular" id="coverletter">
			<tr><td height="2"></td></tr>
			
			<tr><td>
						   
					<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">			
					<cfoutput query="Cover">
							<tr><td style="padding:3px"><font face="Verdana" color="gray" style="font-style: italic;">#DocumentText#</td></tr>
					</cfoutput>					
		   			</table>					
						
			</td></tr>
			</table>

		</td></tr>
		
	</cfif>
	