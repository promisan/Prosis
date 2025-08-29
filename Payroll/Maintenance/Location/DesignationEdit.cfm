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
<cfif url.designation eq "">
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="Location Designation" user="No" banner="gray" option="Add Designation">
<cfelse>
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="Location Designation" user="No" banner="gray" option="Maintain Designation">
	<cfset vyear = mid(url.effective, 1, 4)>
	<cfset vmonth = mid(url.effective, 6, 2)>
	<cfset vday = mid(url.effective, 9, 2)>
	<cfset vEffectiveDate = createDate(vyear, vmonth, vday)>
</cfif>

<cfquery name="Get" 
datasource="appsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*,
			(SELECT Description FROM Ref_Designation WHERE Code = D.Designation) AS DesignationDescription
	FROM 	Ref_PayrollLocationDesignation D
	WHERE 	LocationCode = '#URL.ID1#'
	<cfif url.designation neq "">
		AND		Designation  = '#URL.designation#'
		AND		DateEffective = #vEffectiveDate#
	<cfelse>
		AND   	1=0
	</cfif>
</cfquery>

<table><tr class="hide"><td><iframe name="processDesignation" id="processDesignation" frameborder="0"></iframe></td></tr></table>
	
<cfform action="DesignationSubmit.cfm?id1=#url.id1#&designation=#url.designation#&effective=#url.effective#" method="POST" name="frmDesignation" target="processDesignation">
<table width="80%" cellspacing="0" align="center" class="formpadding">

<tr><td valign="top">

<!--- Entry form --->

<table width="99%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">

	<tr><td></td></tr>
	<cfoutput>

    <TR class="labelmedium">
    <td width="120"><cf_tl id="Designation">:</td>
    <TD>
		<cfif url.designation eq "">
		
		<cfquery name="getLookup" 
			datasource="appsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_Designation
		</cfquery>
		
		<select name="Designation" class="regularxl">
			<cfloop query="getLookup">
				<option value="#getLookup.Code#" <cfif getLookup.Code eq Get.Designation>selected</cfif>>#getLookup.Description#</option>
			</cfloop>
		</select>
		<cfelse>
		#get.DesignationDescription#
		<input type="Hidden" name="Designation" value="#Get.Designation#">
		</cfif>
	</TD>
	</TR>
	

    <TR class="labelmedium">
    <TD>Effective:</TD>
    <TD style="z-index:99; position:relative;">	
		<cfif url.designation eq "">
		<cfset vActualDateEffective = get.dateEffective>
		
		<cfif vActualDateEffective eq "">
		
			<cfquery name="GetLocation" 
			datasource="appsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_PayrollLocation
				WHERE 	LocationCode = '#URL.ID1#'
			</cfquery>
			<cfset vActualDateEffective = GetLocation.dateEffective>
			
		</cfif>
	
		<cf_intelliCalendarDate9
			FieldName="dDateEffective"
			class="regularxl"
			Message="Select a valid Effective Date"
			Default="#dateformat(vActualDateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="False">
		<cfelse>
		#lsDateFormat(get.dateEffective,'#CLIENT.DateFormatShow#')#
		<input type="Hidden" name="dDateEffective" value="#lsDateFormat(get.dateEffective,'#CLIENT.DateFormatShow#')#">
		</cfif>
	</TD>
	</TR>	
		
    <TR class="labelmedium">
    <TD>Expiration:</TD>
    <TD>		
		<cfset vActualDateExpiration = get.dateExpiration>
	
		<cf_intelliCalendarDate9
			FieldName="dDateExpiration"
			class="regularxl"
			Message="Select a valid Expiration Date"
			Default="#dateformat(vActualDateExpiration, CLIENT.DateFormatShow)#"
			AllowBlank="True">
			
		<input type="Hidden" name="dDateExpirationOld" value="#lsDateFormat(get.dateExpiration,'#CLIENT.DateFormatShow#')#">
	</TD>
	</TR>		 
	</cfoutput>
</table>	

</td>

</tr>
	
<tr><td colspan="2" align="center" height="2">
<tr><td colspan="2" class="line"></td></tr>
<tr><td colspan="2" align="center" height="2">
	
<tr><td colspan="2" height="25" align="center">
	<cfif url.designation neq "">
	<!--- <input type="button" class="button10g" style="width:100" name="Delete" value=" Delete " onclick="return askD('#url.id1#','#url.designation#','#url.effective#')"> --->
	</cfif>
	&nbsp;
	<input type="submit" class="button10g" style="width:100" name="Save" value=" Save ">
</td></tr>
	
</TABLE>
	
</CFFORM>

<cfset AjaxOnLoad("doCalendar")>