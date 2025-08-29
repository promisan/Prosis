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
<cf_screentop height="100%" jquery="Yes"  scroll="Yes" html="No" title="#URL.Mission# Staffing period">		

<cf_calendarscript>

<!--- <cfinclude template="MandateListing.cfm"> --->

<cfquery name="MissionTemplate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Mandate
	WHERE Mission = '#URL.Mission#'
	ORDER BY DateEffective DESC
</cfquery>

<script>

function showpost(form,mis,pst,fun,unit,grd) {
 	ptoken.open("../../DWarehouse/InquiryPost/LookupSearch.cfm?FormName= " + form + "&mission=" + mis + "&postnumber=" + pst + "&functionaltitle=" + fun + "&organizationunit=" + unit + "&postgrade=" + grd, "IndexWindow", "width=600, height=550, toolbar=yes, scrollbars=yes, resizable=no");
}

function verify() {
    if (document.documententry.postnumber.value == "") {
	
	alert("please identify a postnumber")
	document.documententry.Search.focus()
	document.documententry.Search.select()
	document.documententry.Search.click()
	return false	
	}
}

</script>

<cfform action="MandateEntrySubmit.cfm?Mission=#URL.Mission#" method="POST" name="documententry">

<table width="94%" border="0" rules="void" cellspacing="0" cellpadding="0" align="center">

  <tr><td height="20"></td></tr>
  <tr class="line">
    <td width="100%" style="font-weight:200;padding-left:4px;height:44;font-size:25px" align="left" valign="middle" class="labelmedium">
	<cf_tl id="Register new staffing period">
    </td>
  </tr> 	
           
  <tr>
    <td width="100%">
    <table width="99%" align="center" class="formpadding formspacing">
	
	<TR class="labelmedium2">
    <TD width="180">Period that will be the basis:</TD>
    <TD width="70%">
	
   	<cfselect name="MissionTemplate" required="No" class="regularxl" onchange="verify(this.value)">
		<cfoutput query="MissionTemplate">
		<option value="#MandateNo#">#MandateNo# : #dateformat(dateEffective,client.dateformatshow)# - #dateformat(DateExpiration,client.dateformatshow)#</option>
		</cfoutput>
		<option value="None">No prior mandate</option>
	</cfselect>
				
	</td>
	</TR>	
		
	<cfoutput>
		
		<script>
	
		function verify(mandate) {
			
			url = "MandateEntryVerify.cfm?mission=#URL.mission#&mandateno="+mandate;
		    ptoken.navigate(url,'verify')
			_cf_loadingtexthtml='';	
		}
		
		</script>
		
	</cfoutput>	
	
	<tr><td></td><td colspan="1" style="padding-left:30px;width:300px;border:0px solid silver;padding:5px;border-radius:5px">	
		<cf_securediv id="verify" bind="url:MandateEntryVerify.cfm?mission=#url.mission#&mandateno=#missiontemplate.MandateNo#">		
	</td></tr>
	
	<TR class="labelmedium2">    
    <td>Period No:  </td>
	<td><cfinput type="Text" name="MandateNo" message="Please enter a No" required="Yes" size="4" maxlength="4" class="regularxl"> i.e 2 or 002
	</td>
	</TR>	
	
	<TR class="labelmedium2">    
    <td>Period name:  </td>
	<td><cfinput type="Text" name="Description" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
	</td>
	</TR>	
		
	<tr class="labelmedium2"> 		
		<TD><cf_tl id="Effective date"></td>
    
		<td><cfset end = DateAdd("m",  2,  now())> 
		
			<cfif MissionTemplate.DateExpiration neq "">
			
		   	   	<cf_intelliCalendarDate9
				FieldName="DateEffective" 
				DateValidStart="#Dateformat(MissionTemplate.DateExpiration+1, 'YYYYMMDD')#"
				Default="#Dateformat(MissionTemplate.DateExpiration+1, CLIENT.DateFormatShow)#"
				class="regularxl"
				AllowBlank="False">	
				
			<cfelse>
			
				<cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				class="regularxl"
				AllowBlank="False">	
		
			</cfif>	
		</td>
	</TR>
	
	<tr class="labelmedium2"> 		
		<TD>Expiration date</td>
    
		<td><cfset end = DateAdd("yyyy",  1,  "#MissionTemplate.DateExpiration#")>
		 
			<cfif MissionTemplate.DateExpiration neq "">
			
		   	   	<cf_intelliCalendarDate9
					FieldName="DateExpiration" 
					DateValidStart="#Dateformat(MissionTemplate.DateExpiration+1, 'YYYYMMDD')#"
					Default="#Dateformat(end, CLIENT.DateFormatShow)#"
					class="regularxl"
					AllowBlank="False">	
			
			<cfelse>
			
				<cf_intelliCalendarDate9
					FieldName="DateExpiration" 			
					Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
					class="regularxl"
					AllowBlank="False">	
				
			</cfif>	
								
		</td>
	</TR>
		
	<tr class="labelmedium2"> 		
		<TD>Make this mandate the default:</td>    
		<td><input type="checkbox" class="radiol" name="MandateDefault" value="1"></td>	
	</TR>
	
	<tr class="labelmedium2"> 		
		<TD>Migrate user authorizations to new mandate:</td>    
		<td><input type="checkbox" class="radiol" name="SettingUser" checked value="1"></td>	
	</TR>
	
	<tr class="labelmedium2"> 		
		<TD>Migrate Funding:</td>    
		<td><input type="checkbox" class="radiol" name="SettingFunding" value="1"></td>	
	</TR>
	
	<tr class="labelmedium2"> 		
		<TD>Migrate Recruitment Tracks:</td>    
		<td><input type="checkbox" class="radiol" name="SettingTrack" value="1"></td>	
	</TR>
				
	<tr><td height="4"></td></tr>
				
	<tr><td height="1" colspan="2" class="line"></td></tr>
	
	<tr>
	<td colspan="2">
	
		<input class="button10g" type="button" style="width;120px" name="cancel" value="Cancel" onClick="history.back()">
		<input class="button10g" type="submit" style="width;120px" name="Submit" value="Submit">
	
	</td>
	</tr>
		
</TABLE>

</td>
</tr>

</table>

</CFFORM>

