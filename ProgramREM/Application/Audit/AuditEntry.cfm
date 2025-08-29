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
<HTML><HEAD>
<TITLE><cf_tl id="Audit Registration"></TITLE>



</HEAD><body leftmargin="1" topmargin="1" rightmargin="1" bottommargin="1" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<div id="dwindow" style="position:absolute;background-color:#EBEBEB;cursor: pointer;left:0px;top:0px;display:none" onMousedown="initializedrag(event)" onMouseup="stopdrag()" onSelectStart="return false">
<div align="right" style="background-color:navy">
<input type="button" name="cancel" id="cancel" value="Cancel " class="button10p" onClick="closeit()">

<!---
<img src="Nav_home.gif" id="maxname" onClick="maximize()">
<img src="cancel2.GIF" onClick="closeit()">
--->

</div>
<div id="dwindowcontent" style="height:100%">
<iframe id="cframe" src="" width=100% height=100%></iframe>
</div>
</div>

<cf_dialogREMProgram>

<cfparam Name="URL.Period" default="">
<cfparam Name="URL.OrgUnit" default="">
<cfparam Name="URL.EditCode" default="">

<CFset URL.EditCode    = TRIM("#URL.EDITCODE#")>	
<cfoutput>

<cfif URL.EditCode eq "">
	<cf_assignId>
	<cfset KeyAuditId=#RowGuid#>
	<cfset Update="no">
	<cfset Action="Register">
	<Cfset SubmitAction="AuditEntrySubmit.cfm?AuditId=#KeyAuditId#">
	<cfset Update="no">

<cfelse>
	<cfset Update="yes">
	<cfset Action="Edit">
	<CFSET SubmitAction="AuditEntrySubmit.cfm?EditCode=#URL.AuditId#&AuditId=#URL.AuditId#">
	<cfquery name="EditAudit"	
	 datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ProgramAudit.dbo.Audit
		WHERE  
		AuditId='#URL.EditCode#'
	</cfquery>	
	<cfset KeyAuditId=#URL.AuditId#>

</cfif>


</cfoutput>

<cfform action="#SubmitAction#" method="POST" name="AuditEntry">


<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="e4e4e4" class="formpadding">

  <tr><td>
       
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  
   <tr>
    <td height="23" align="left" valign="middle" bgcolor="f4f4f4">
	
	    	<font face="verdana" size="2"><b><cf_tl id="Audit Registration"> </b></font>
	
    </td>
	<td align="right"  bgcolor="f4f4f4">
	<cfoutput>
	   <input type="button" name="cancel" id="cancel" value="Cancel " class="button10p" onClick="window.close()">
	   <cf_tl id="Save" var="1">	 
	   <input class="button10p" type="submit" id="submit" name="Submit" value="  #lt_text#  ">
   	   <cf_tl id="Reset" var="1">	 
	   <input class="button10p" type="reset"  name="Reset" id="Reset" value="  #lt_text#  ">&nbsp;
	</cfoutput>	   
   	</td>
  </tr> 	
     
  <tr>

	<cfoutput>
	
	<cfparam name="URL.Refresh" default="">
	
	<cfoutput>
	<cfif URL.EditCode eq "">
	<INPUT type="hidden" name="Period" id="Period" value="#URL.Period#">
	<INPUT type="hidden" name="OrgUnit" id="OrgUnit" value="#URL.OrgUnit#">

	<cfelse>
	<INPUT type="hidden" name="Period" id="Period" value="#EditAudit.Period#">
	<INPUT type="hidden" name="OrgUnit" id="OrgUnit" value="#EditAudit.OrgUnit#">

	
	</cfif>
	</cfoutput>
	
	
	</cfoutput>
	
    <td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#F1F1F1" class="formpadding">
	
	<cfoutput>
	<input type="Hidden" name="AuditId" id="AuditId" value="#KeyAuditId#">
    </cfoutput>
	
	
    <!--- Field: Audit Name --->
    <TR>
	
    <TD width=10%>&nbsp;&nbsp;<cf_tl id="Audit No.">:</TD>
	
    <TD>
	<cfoutput>
	<cfif URL.EditCode eq "">
	<input type="text" name="AuditNo" id="AuditNo" value="" maxlength="10" size="10">
	<cfelse>
	<input type="text" name="AuditNo" id="AuditNo" value="#EditAudit.AuditNo#" maxlength="10" size="10">
	</cfif>
	</cfoutput>

	
	</TD>
	</TR>
	
    <!--- Field: Audit Description --->

	<TR>
        <TD width=10%>&nbsp;&nbsp;<cf_tl id="Description">:</td>
		<td>
	<cfoutput>
	<cfif URL.EditCode eq "">
	<input type="text" name="AuditDescription" id="AuditDescription" value="" maxlength="20" size="20">
	<cfelse>
	<input type="text" name="AuditDescription" id="AuditDescription" value="#EditAudit.Description#" maxlength="20" size="20">
	</cfif>	
	</cfoutput>	

		
		
		</td>	
		
	</TR>

    <!--- Field: Objective --->

    <TR>
    <TD  class="regular" width=10%>&nbsp;&nbsp;<cf_tl id="Objective">:</TD>
    <TD class="regular">
	<cfoutput>
	<cfif URL.EditCode eq "">
		<textarea name="AuditObjective" class="regular" cols="80" rows="4"></textarea>
	<cfelse>
		<textarea name="AuditObjective" class="regular"  cols="80" rows="4">#EditAudit.Objective#</textarea>
	</cfif>			
	</cfoutput>
	</TD>
	</TR>	
	
    <!--- Field: Reference --->

    <TR>
    	<TD  class="regular" width=10%>&nbsp;&nbsp;<cf_tl id="External reference">:</TD>
	    <TD class="regular">
		<cfoutput>
		<cfif URL.EditCode eq "">
		<input type="text" name="reference" id="reference" value="" maxlength="20" size="20">
		<cfelse>
		<input type="text" name="reference" id="reference" value="#EditAudit.reference#" maxlength="20" size="20">
		</cfif>			
		</cfoutput>
		</TD>
	</TR>	

    <!--- Field: Start Date --->

	<TR>
        <TD  class="regular" width=10%>&nbsp;&nbsp;<cf_tl id="Start Date">:</td>
        <TD class="regular">
			<cfoutput>
			<cfif URL.EditCode eq "">
				<cf_intelliCalendarDate
				FieldName="AuditDateStart" 
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="False">	
			
			<cfelse>
				<cf_intelliCalendarDate
				FieldName="AuditDateStart" 
				Default="#Dateformat(EditAudit.AuditDateStart, CLIENT.DateFormatShow)#"
				AllowBlank="False">	
			</cfif>		
			</cfoutput>
		 </TD>
	</TR>

    <!--- Field: End Date --->

	<TR>
        <TD  class="regular">&nbsp;&nbsp;<cf_tl id="End Date">:</td>
        <TD class="regular">
	
			<cfoutput>
			<cfif URL.EditCode eq "">
				<cf_intelliCalendarDate
				FieldName="AuditDateEnd" 
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="False">	
			
			<cfelse>
	
				<cf_intelliCalendarDate
				FieldName="AuditDateEnd" 
				Default="#Dateformat(EditAudit.AuditDateEnd, CLIENT.DateFormatShow)#"
				AllowBlank="False">	
			</cfif>	
			</cfoutput>
		 </TD>
	</TR>
     <tr id="Observations" >
	 <td colspan="9">
		 <input type="hidden" name="observation" id="observation" value="0">	
		<cfoutput>
		   <iframe src="Observation/ObservationEntry.cfm?AuditId=#KeyAuditId#"
		   name="iobservation" id="iobservation" width="98%" height="100" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" frameborder="0"></iframe>
		</cfoutput>
	 
	 </td>
	  </tr>	 

	

	

    <tr><td colspan="2">

   <table width="100%">
   		<td align="right">
		<cfoutput>
	   <cf_tl id="Cancel" var="1">	 
	   <input type="button" name="cancel" id="cancel" value="#lt_text# " class="button10p" onClick="window.close()">
   	   <cf_tl id="Save" var="1">	 
	   <input class="button10p" type="submit" name="Submit" id="Submit" value="  #lt_text#  ">
   	   <cf_tl id="Reset" var="1">	 
	   <input class="button10p" type="reset"  name="Reset" id="Reset" value="  #lt_text#  ">&nbsp;
		</cfoutput>
   		</td>
   </table>
   
   </td></tr>	

</table>

</tr></table>

</table>



</cfform>

</BODY></HTML>