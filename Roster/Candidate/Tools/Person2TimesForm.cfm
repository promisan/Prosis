<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfoutput>

<cf_screentop label="Merge Applicant Profiles" html="No" bannerheight="55" line="no" height="100%" layout="webapp" scroll="Yes" banner="gray">

<table width="92%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

	<tr><td height="4"></td></tr>
	<tr><td colspan="2" class="labelmedium">
	This utility will allow you to merge two accounts. It will retain the PHP information from the <font color="408080"><b>CORRECT</b></font> account but will
	redirect all applications and recruitment tracks from the wrong account to the <font color="408080"><b>CORRECT</b></font> account.
	<p>
	</p>
	You must know the <cfoutput>#SESSION.welcome#</cfoutput> account number (PersonNo) in order to proceed. The system will verify and validate your entry
	
	</td></tr>
	
	<tr>
	<td width="300" valign="top">
	<table><tr class="labelmedium2">
	<td style="width:300px">
	<cf_UIToolTip
	tooltip="This profile will be removed from the system and applications will be linked to the above profile">
	Account with <font color="FF0000">INCORRECT</font> Profile:
	</cf_UIToolTip>
	</td>
	<td width="100">
	<input type="text" 
	       name="wrong" 
	       id="wrong"
		   class="regularxxl regular3"
		   size="10" 
		   style="border:0px;font-size:20px"
		   readonly
		   value="#url.personNo#"
		   onChange="ptoken.navigate('Person2TimesSelect.cfm?sel=wrong&correct='+correct.value+'&wrong='+this.value,'incorrectbox')">
	</td>
	</table>	   
	</td>
	</tr>
	<tr>
	<td colspan="2" style="padding-left:4px;background-color:f1f1f1">
		<cf_securediv bind="url:Person2TimesSelect.cfm?sel=wrong&correct='+this.value+'&wrong=#url.personno#" id="incorrectbox"/>
	</td>
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
	<td width="300" valign="top">
		<table><tr class="labelmedium2">
		<td style="width:300px">
		<cf_UIToolTip  tooltip="This profile will be retained">
		<font color="408080">Selected <b>CORRECT</b></font> PHP Profile:
		</cf_UIToolTip>
		</td>
		<td width="100">
		
		<cfquery name="wrong" 
		datasource="appsSelection">
		SELECT *
		FROM Applicant
		WHERE PersonNo = '#URL.PersonNo#'
		</cfquery>
		
		<cfquery name="correct" 
		datasource="appsSelection">
		SELECT   *
		FROM     Applicant
		WHERE    PersonNo IN (SELECT PersonNo 
		                      FROM Applicant 
							  WHERE LastName  = '#wrong.lastName#'
							  <!---
							  AND   FirstName = '#wrong.firstname#'
							  AND   DOB       = '#wrong.DOB#' --->)
		AND      PersonNo <> '#URL.PersonNo#'
		
		UNION
		
		SELECT   *
		FROM     Applicant
		WHERE    PersonNo IN (SELECT PersonNo 
		                      FROM Applicant 
							  WHERE Nationality = '#wrong.nationality#'
							  AND   FirstName   = '#wrong.firstname#'
							  AND   DOB         = '#wrong.DOB#')
		AND      PersonNo <> '#URL.PersonNo#'
				
		UNION
		
		SELECT   *
		FROM     Applicant
		WHERE    PersonNo IN (SELECT PersonNo 
		                      FROM Applicant 
							  WHERE Nationality = '#wrong.nationality#'
							  AND   LastName    = '#wrong.lastname#'
							  AND   DOB         = '#wrong.DOB#')
		AND      PersonNo <> '#URL.PersonNo#'
		
		UNION
				
		SELECT   *
		FROM     Applicant
		WHERE    PersonNo IN (SELECT PersonNo 
		                      FROM Applicant 
							  WHERE Nationality = '#wrong.nationality#'
							  AND   LastName    = '#wrong.lastname#'
							  AND   FirstName   = '#wrong.firstname#')
		AND      PersonNo <> '#URL.PersonNo#'
				
		ORDER BY FirstName
		</cfquery>
				
		<select name="correct" class="regularxxl" onChange="ptoken.navigate('Person2TimesSelect.cfm?sel=correct&correct='+this.value+'&wrong='+document.getElementById('wrong').value,'correctbox')">
		<option value="">select</option>
		<cfloop query="correct">
		<option value="#PersonNo#">
		#LastName#, #FirstName# #Nationality# #dateformat(DOB, CLIENT.DateFormatShow)#
		</option>
		</cfloop>
		</select>
		
		<!---
		<input type="text" 
		       name="correct" 
			   size="10" 
			   onChange="ColdFusion.navigate('Person2TimesSelect.cfm?sel=correct&correct='+this.value+'&wrong='+wrong.value,'correctbox')">
		--->
			   
		</td>
		</table>
	</td>
	</tr>
	<tr>
	<td colspan="2"><cfdiv id="correctbox"/></td>
	</tr>

</table>

<cf_screenbottom layout="webapp">

</cfoutput>