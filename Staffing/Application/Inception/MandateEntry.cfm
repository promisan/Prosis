<HTML><HEAD>
<TITLE>Document - Entry</TITLE>
</HEAD><body bgcolor="#FFFFFF" leftmargin="5" topmargin="5">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

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
 	window.open("../../DWarehouse/InquiryPost/LookupSearch.cfm?FormName= " + form + "&mission=" + mis + "&postnumber=" + pst + "&functionaltitle=" + fun + "&organizationunit=" + unit + "&postgrade=" + grd, "IndexWindow", "width=600, height=550, toolbar=yes, scrollbars=yes, resizable=no");
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
    <table border="0" cellpadding="0" cellspacing="0" width="99%" align="center" class="formpadding formspacing">
	
	<TR>
    <TD width="180" class="labelmedium">Period that will be the basis:</TD>
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
		    ColdFusion.navigate(url,'verify')
			_cf_loadingtexthtml='';	
		}
		
		</script>
		
	</cfoutput>	
	
	<tr><td></td><td colspan="1" style="padding-left:30px;width:300px;border:0px solid silver;padding:5px;border-radius:5px">
	
	<cfdiv id="verify" 
	bind="url:MandateEntryVerify.cfm?mission=#url.mission#&mandateno=#missiontemplate.MandateNo#">	
	
	</td></tr>
	
	 <TR>
    
    <td class="labelmedium">Period No:  </td>
	<td><cfinput type="Text" name="MandateNo" message="Please enter a No" required="Yes" size="4" maxlength="4" class="regularxl">
	</td>
	</TR>	
	
	<TR>    
    <td class="labelmedium">Period name:  </td>
	<td><cfinput type="Text" name="Description" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
	</td>
	</TR>	
		
		
	<tr> 		
		<TD class="labelmedium">Effective date</td>
    
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
	
	<tr> 		
		<TD class="labelmedium">Expiration date</td>
    
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
		
	<tr> 		
		<TD class="labelmedium">Make this mandate the default:</td>    
		<td class="labelmedium"><input type="checkbox" class="radiol" name="MandateDefault" value="1"></td>	
	</TR>
	
	<tr> 		
		<TD class="labelmedium">Migrate user authorizations to new mandate:</td>    
		<td class="labelmedium"><input type="checkbox" class="radiol" name="SettingUser" checked value="1"></td>	
	</TR>
	
	<tr> 		
		<TD class="labelmedium">Migrate Funding:</td>    
		<td class="labelmedium"><input type="checkbox" class="radiol" name="SettingFunding" value="1"></td>	
	</TR>
	
	<tr> 		
		<TD class="labelmedium">Migrate Recruitment Tracks:</td>    
		<td class="labelmedium"><input type="checkbox" class="radiol" name="SettingTrack" value="1"></td>	
	</TR>
				
	<tr><td height="10"></td></tr>
				
	<tr><td height="1" colspan="2" class="line"></td></tr>
	
	<tr>
	<td colspan="2" align="center">
	
		<input class="button10g" type="button" style="width;120px" name="cancel" value="Cancel" onClick="history.back()">
		<input class="button10g" type="submit" style="width;120px" name="Submit" value="Submit">
	
	</td>
	</tr>
		
</TABLE>

</td>
</tr>

</table>

</CFFORM>

</BODY></HTML>
