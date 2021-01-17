
<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * FROM Ref_Mandate
WHERE    Mission = '#URL.Mission#'
ORDER BY DateEffective DESC
</cfquery>

<cfoutput>
	
	<table width="200" class="formpadding">
	
		<input type="hidden" name="mandateno" id="mandateno" value="#Mandate.MandateNo#">
		
		<cfloop query="Mandate">
		
			<tr class="labelmedium2">
			    <td><input type="radio" class="radiol"
				onclick="document.getElementById('mandateno').value='#mandateno#'" 
				name="mymandate" 
				value="#MandateNo#" <cfif currentRow eq "1">checked</cfif>></td>
				<td style="padding-left:4px">#MandateNo#</td>
				<td style="padding-left:4px">#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
				<td style="padding-left:4px">#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>
			</tr>
				
		</cfloop>
	
	</table>

</cfoutput>