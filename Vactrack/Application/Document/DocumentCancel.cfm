<!--- 
1. set document status = 9	  
--->

<cfoutput>

<!--- we check if a candidate is still active --->

<cfif url.status eq "9">
	
	<cfquery name="LogStatus" 
		 datasource="AppsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	
		SELECT       DC.DocumentNo
		FROM         DocumentCandidate AS DC INNER JOIN
		             Organization.dbo.OrganizationObject AS OO ON DC.DocumentNo = OO.ObjectKeyValue1 AND DC.PersonNo = OO.ObjectKeyValue2
		WHERE        (OO.Operational = '1') AND (DC.DocumentNo = '#url.id#') AND (OO.EntityCode = 'VacCandidate')
	</cfquery>
	
	<cfif LogStatus.recordcount gt "0">
		
		<table style="width:100%">
		
			<tr class="labelmedium"><td align="center" style="padding:35px;font-weight:bold">There are still one or more candidate flows open for this track. Please cancel those tracks with the yellow button on the left top first.</td></tr>
		
		</table>
		
	<cfelse>
				
	<form name="revokeform" id="revokeform">
	
	<table style="width:100%">
		
		<tr class="labelmedium2"><td><cf_tl id="Reason for cancellation"></td></tr>		
		<tr><td style="padding:10px" align="center"><textarea style="font-size:15px;padding:4px;width:97%;height:100px"></textarea></td></tr>		
		<tr><td align="center" style="padding:4px"><input type="button" value="Submit" class="button10g" name="Memo" onclick="revokesubmit('#url.status#')"></td></tr>
	
	</table>
	
	</form>	
		
	</cfif>
	
<cfelse>
	
	<form name="revokeform" id="revokeform">
	
	<table style="width:100%">
		
		<tr class="labelmedium2"><td><cf_tl id="Reason for reinstatement"></td></tr>						
		<tr><td style="padding:10px" align="center"><textarea style="font-size:15px;padding:4px;width:97%;height:100px"></textarea></td></tr>		
		<tr><td align="center" style="padding:4px"><input type="button" value="Submit" class="button10g" name="Memo" onclick="revokesubmit('#url.status#')"></td></tr>
	
	</table>
	
	</form>

</cfif>



</cfoutput>


