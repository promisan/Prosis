
<cfquery name="Correct" 
datasource="appsSelection">
	SELECT *
	FROM Applicant
	WHERE PersonNo = '#URL.Correct#' or LoginAccount = '#URL.Correct#'	
</cfquery>

<cfquery name="Incorrect" 
datasource="appsSelection">
	SELECT *
	FROM Applicant
	WHERE PersonNo  = '#URL.Wrong#' or LoginAccount = '#URL.Wrong#'
</cfquery>

<cfif url.correct eq url.wrong>

	<font color="FF0000"><B>You may not select the same account</B></font>

<cfelseif (correct.recordcount eq "1" and url.sel eq "correct") or 
          (incorrect.recordcount eq "1" and url.sel eq "wrong")>

	<cfoutput>
	
	<table width="100%">
	<cfif url.sel eq "Correct">
		<tr class="labelit"><td width="100" style="padding-right:40px"><cf_space spaces="35">First Name:</td><td width="100%">#Correct.FirstName#</td></tr>
		<tr class="labelit"><td>Last Name:</td><td>#Correct.LastName#</td></tr>
		<tr class="labelit"><td>DOB:</td><td>#dateformat(Correct.DOB,CLIENT.DateFormatShow)#</td></tr>
		<tr class="labelit"><td>Nationality:</td><td>#Correct.Nationality#</td></tr>		
		<tr class="labelit"><td>CandidateNo:</td><td>#Correct.PersonNo#</td></tr>	
	<CFELSE>
		<tr class="labelit"><td width="100" style="padding-right:40px"><cf_space spaces="35">First Name:</td><td width="100%">#InCorrect.FirstName#</td></tr>
		<tr class="labelit"><td>Last Name:</td><td>#InCorrect.LastName#</td></tr>
		<tr class="labelit"><td>DOB:</td><td>#dateformat(InCorrect.DOB,CLIENT.DateFormatShow)#</td></tr>
		<tr class="labelit"><td>Nationality:</td><td>#InCorrect.Nationality#</td></tr>	
		<tr class="labelit"><td>CandidateNo:</td><td>#InCorrect.PersonNo#</td></tr>	
	</cfif>
	
	<cfif url.sel eq "Correct">
	
		<cfset go = 0>
		
		<cfif Correct.lastname eq Incorrect.lastName>
		  <cfset go = 1>
		</cfif>
		<cfif Correct.firstname eq Incorrect.firstName>
		  <cfset go = 1>
		</cfif>
		<cfif Correct.dob eq Incorrect.dob>
		  <cfset go = 1>
		</cfif>
		<cfif Correct.nationality eq Incorrect.nationality>
		  <cfset go = 1>
		</cfif>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<cfif go eq "0">
		        <tr  class="labelit"><td><font color="0080C0">Sorry the selected accounts do not qualify for merging</td></tr>
		<cfelse>
				<tr><td colspan="2" align="center" height="35" id="actionbox">
				<input type="button" 
					onclick="ColdFusion.navigate('Person2TimesSubmit.cfm?correct=#url.correct#&wrong=#url.wrong#','correctbox')"
					class="button10g" style="border-radius:7px" class="button10g" name="Merge" value="Merge">
				</td>
				</tr>
		</cfif>
	
	</cfif>
	
	
	</table>
	
		
	</cfoutput>

<cfelse>

	<font color="FF0000"><B>Account not found</B></font>

</cfif>
