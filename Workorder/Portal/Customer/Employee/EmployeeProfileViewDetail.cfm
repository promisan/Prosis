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
<!--- to be reviewed and move to the table workorderscheduleDate --->
<!--- ---------------------------------------------------------- --->

<cfquery name="personDetail" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT 	P.*,
				(SELECT Name FROM System.dbo.Ref_Nation WHERE Code = P.BirthNationality) as BirthNationalityName,
				(
					SELECT TOP 1 Contact 
					FROM 	PersonAddress
					WHERE 	PersonNo = P.PersonNo 
					AND		AddressType = 'Emergency'
					ORDER BY Created DESC
					
				) as EmergencyContact,
				
				( SELECT TOP 1 DateEffective 
					FROM 	PersonAssignment
					WHERE 	PersonNo = P.PersonNo 
					AND		AssignmentStatus IN ('0','1') 
					ORDER BY DateEffective DESC
					
				) as AssignmentStart,
				
				(
					SELECT 	ContactCallSign
					FROM	PersonAddressContact
					WHERE	AddressId =
										(
											SELECT TOP 1 AddressId 
											FROM 	PersonAddress
											WHERE 	PersonNo = P.PersonNo 
											AND		AddressType = 'Emergency'
											ORDER BY Created DESC
										)
					AND		ContactCode = 'Phone'
				) as EmergencyPhone
		FROM	Person P
		WHERE	P.PersonNo = '#url.personno#'
</cfquery>

<cfoutput query="personDetail">
				
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
	   
		<tr>
			<td width="33%" style="height:16;padding-left:7px" class="labelit"><cf_tl id="IndexNo">:</td>
			<td width="67%" class="labelmedium" style="padding-right:5px;" align="right"><b>#IndexNo#</b></td>
		</tr>
		<tr><td class="line" colspan="2"></td></tr>
		
		<tr>
			<td class="labelit" style="height:16;padding-left:7px"><cf_tl id="Date of Birth">:</td>
			<td class="labelmedium" style="padding-right:5px;" align="right">#dateFormat(birthDate,'#client.dateformatshow#')#</td>
		</tr>
		<tr><td class="line" colspan="2"></td></tr>
		
		<tr>
			<td class="labelit" style="height:16;padding-left:7px"><cf_tl id="Place of Birth">:</td>
			<td class="labelmedium" style="padding-right:5px;" align="right"><cfif BirthCity neq "">#BirthCity#, </cfif>#BirthNationalityName#</td>
		</tr>
		<tr><td class="line" colspan="2"></td></tr>
				
		<tr>
			<td class="labelit" style="height:16; padding-left:7px"><cf_tl id="EOD">:</td>
			<td class="labelmedium" style="padding-right:5px;" align="right">#dateFormat(organizationStart,'#client.dateformatshow#')#</td>
		</tr>
				
		<cfif trim(EmergencyPhone) neq "">
		<tr><td class="line" colspan="2"></td></tr>
		<tr>
			<td class="labelit" style="height:16;padding-left:7px"><cf_tl id="Contact Number">:</td>
			<td class="labelmedium" style="padding-right:5px;" align="right">#EmergencyContact#-#EmergencyPhone#</td>
		</tr>
		</cfif>
		
		<cfif false>
		<tr><td class="line" colspan="2"></td></tr>
		<tr>
			<td class="labelit" style="height:16;padding-left:7px">#session.Welcome#<cf_tl id="Mail">:</td>
			<td class="labelmedium" style="padding-right:5px;" align="right">---</td>
		</tr>
		</cfif>
		
		<cfif false>
		<tr><td class="line" colspan="2"></td></tr>
		<tr>
			<td class="labelit" style="padding-left:7px"><cf_tl id="Certification">:</td>
			<td class="labelit" style="padding-right:5px;" align="right"><font color="gray">[<cf_tl id="coming soon">]</font></td>
		</tr>
		</cfif>
		
	</table>

</cfoutput>