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
<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="Appsepas" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ContractPeriod R
	WHERE  Code = '#URL.ID#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Are you sure. This action can not be reversed?")) {
		return true 	
	}	
	return false	
}	

</script>

<cf_calendarscript>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  label="Edit Period" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?code=#get.Code#" method="POST" name="dialog">
	
<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">

	<tr><td></td></tr>
	
	<cfoutput>   
		
	<TR class="labelmedium">
   	    <TD height="20"><cf_tl id="Entity">:</TD>
    	<TD>#get.mission#</TD>
	</TR>
	
	<TR class="labelmedium">
	    <TD height="20"><cf_tl id="Class">:</TD>
		<TD>#get.ContractClass#</TD>
	</TR>
	
	<TR class="labelmedium">
	    <TD height="20"><cf_tl id="Code">:</TD>
		<TD>#get.Code#</TD>
	</TR>
	
    <TR class="labelmedium">
	    <TD><cf_tl id="Start">:</TD>
    	<TD>#dateformat(get.PasperiodStart,CLIENT.DateFormatShow)#</TD>
	</TR>
	
	 <TR class="labelmedium">
    	<TD><cf_tl id="End">:</TD>
	    <TD>#dateformat(get.PasperiodEnd,CLIENT.DateFormatShow)#</TD>
	</TR>
	
	 <TR class="labelmedium">
    	<TD><cf_tl id="Midterm">:</TD>
	    <TD>
		
		<cf_intelliCalendarDate9
			FieldName="PASEvaluation" 
			Manual="True"		
			class="regularxl"					
			DateValidStart="#Dateformat(get.PasperiodStart, 'YYYYMMDD')#"
			DateValidEnd="#Dateformat(get.PasperiodEnd, 'YYYYMMDD')#"
			Default="#dateformat(get.PASEvaluation,CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		
		</TD>
	</TR>
	  
	
	 <TR class="labelmedium">
	    <TD><cf_tl id="Operational">:</TD>
    	<TD><cfif get.Operational eq "1">Yes<cfelse>No</cfif></TD>
	</TR>	
	
	</cfoutput>
				
	<tr class="line"><td colspan="2"></td></tr>	
	
	<tr>	
		<td colspan="2" align="center" height="33">
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
    	<input class="button10g" type="submit" name="Update" value="Update">
		</td>	
	</tr>
	
</TABLE>
	
</CFFORM>
