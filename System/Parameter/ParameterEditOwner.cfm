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
<cfquery name="Get" 
datasource="AppsInit">
	SELECT *
	FROM Parameter 
	WHERE HostName = '#URL.host#' 
</cfquery>

<cfquery name="System" 
datasource="AppsSystem">
	SELECT *  
	FROM Parameter 
</cfquery>

<cfform method="POST" name="editform"  onsubmit="return false">

	<input type="hidden" name="Form.HostName" id="form.HostName" value="#get.hostname#">

	<table width="90%" border="0" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td height="5"></td></tr>
		
	<cfif System.ExceptionControl eq "0">
	<tr><td colspan="2" height="20" class="labelmedium"><i>Error Management has been disabled globally. Settings will be ignored</td></tr>
	</cfif>
		
	<TR>
    <td valign="top" class="labelmedium" style="padding-top:5px"><b><a href="##" title="Capture and record all user error messages">Exception Log</a></b> handling:</b></td>
    <TD width="79%">
	 <table cellspacing="0" cellpadding="0">
	  <tr><td class="labelmedium">
	  <input type="radio" class="radiol" name="EnableError" id="EnableError" value="0" <cfif Get.EnableError eq "0" or Get.EnableError eq "">checked</cfif>>Disabled, show default ColdFusion error message only (not recommended).
	  </td></tr>
	  <tr><td>
	  <table cellspacing="0" cellpadding="0">
	  <tr><td class="labelmedium">
	  <input type="radio" class="radiol" name="EnableError" id="EnableError" value="1" <cfif Get.EnableError eq "1">checked</cfif>>Log Enabled, show the error message to the user.
	  <td class="labelmedium">
	  <input type="checkbox" class="radiol" name="EnableDetailError" id="EnableDetailError" value="1" <cfif Get.EnableDetailError eq "1">checked</cfif>>Show Detailed Error	  	
	  </td>
	  </td></tr>
	  </table>	
	  </td></tr>
	  <tr><td class="labelmedium">
	  <input type="radio" class="radiol" name="EnableError" id="EnableError" value="2" <cfif Get.EnableError eq "2">checked</cfif>>Log Enabled, show a friendly message (except administrator)
	  </td></tr>
	  
	 </table> 
	  
    </TD>
	</TR>
	
	<tr><td height="1"></td></tr>
	
	<tr><td colspan="2" class="labelmedium"><i>Note: Coldfusion Exceptions are always logged to be processed in the support portal</td></tr>
	
	<tr><td height="4"></td></tr>
			
	<TR>
    <td valign="top" class="labelmedium" style="padding-top:5px"><b><a href="##" title="Send user error messages to template owner">Exception User Notification</a></b></td>
    <TD>
	
	  <table cellspacing="0" cellpadding="0">
	  
	  <tr><td class="labelmedium">	
	  <input type="radio" class="radiol" name="ErrorMailToOwner" id="ErrorMailToOwner" value="9" <cfif Get.ErrorMailToOwner eq "9" or Get.ErrorMailToOwner eq "9">checked</cfif>>Disabled, allow user to send manually.	
	  </td></tr>
	  <tr><td class="labelmedium">
	  <input type="radio" class="radiol" name="ErrorMailToOwner" id="ErrorMailToOwner" value="2" <cfif Get.ErrorMailToOwner eq "2">checked</cfif>>Mail to Template Owner &nbsp;&nbsp; (if determined) <b>AND</b> to Vendor (BCC)
	  </td></tr>
	  <tr><td class="labelmedium">
	  <input type="radio" class="radiol" name="ErrorMailToOwner" id="ErrorMailToOwner" value="1" <cfif Get.ErrorMailToOwner eq "1">checked</cfif>>Mail to Template Owner <br> &nbsp;&nbsp;&nbsp;&nbsp;(if determined otherwise to Application Server Contact see tab : [Connection Settings])
	  </td></tr>
	  <tr><td class="labelmedium">
	  <input type="radio" class="radiol" name="ErrorMailToOwner" id="ErrorMailToOwner" value="0" <cfif Get.ErrorMailToOwner eq "0" or Get.ErrorMailToOwner eq "">checked</cfif>>Mail to Application Server Contact (see tab: <b>[Connection Settings]</b>).
	  </td></tr>	
	  
	  </table> 
	
    </TD>
	</TR>
	
	<!--- now handled in the support portal 
	
	<tr><td height="4"></td></tr>
	
	<TR>
    <td><b><a href="##" title="Creates a helpdesk workflow object for each error">Error Helpdesk ticket</a></b>:</b></td>
    <TD>
	  <input type="radio" name="ErrorWorkflow" id="ErrorWorkflow" value="1" <cfif Get.ErrorWorkflow eq "1">checked</cfif>>Yes
	  <input type="radio" name="ErrorWorkflow" id="ErrorWorkflow" value="0" <cfif Get.ErrorWorkflow eq "0">checked</cfif>>No
    </TD>
	</TR>
	
	--->
	
	<cfif System.ExceptionControl eq "0">
	<tr><td colspan="2" height="1" bgcolor="red"></td></tr>
	</cfif>
	
	<tr><td height="4"></td></tr>
	
	<!--- adjusted by hanno to no longer allow users to make non - logging settings if cf_reportquery> is used. --->
		
	<TR>
    <td class="labelmedium">Audit&nbsp;<b><a href="##" title="Capture criteria and timestamp of start/end of the SQL portion for each report">Report&nbsp;preparation:</a></b></td>
    <TD class="labelmedium">
	  <input type="radio" class="radiol" name="EnableReportAudit" id="EnableReportAudit" value="2" <cfif Get.EnableReportAudit gte "0">checked</cfif>>Full (incl. enabled queries)
	  <input type="radio" class="radiol" disabled name="EnableReportAudit" id="EnableReportAudit" value="1" <cfif Get.EnableReportAudit eq "1">checked</cfif>>Limited (only start/end)
	  <input type="radio" class="radiol" disabled name="EnableReportAudit" id="EnableReportAudit" value="0" <cfif Get.EnableReportAudit eq "0" or Get.EnableReportAudit eq "">checked</cfif>>Disabled
	  
    </TD>
	</TR>
	
	<tr><td height="4"></td></tr>
	
	<TR>
    <td class="labelmedium"><b><a href="##" title="Archives a copy of the prepared report (report log)">Archive Report</a></b>:</b></td>
    <TD class="labelmedium">
	  <input type="radio" class="radiol" name="EnableReportArchive" id="EnableReportArchive" value="1" <cfif Get.EnableReportArchive eq "1">checked</cfif>>Yes
	  <input type="radio" class="radiol" name="EnableReportArchive" id="EnableReportArchive" value="0" <cfif Get.EnableReportArchive eq "0">checked</cfif>>No
    </TD>
	</TR>
	
	<tr><td height="4"></td></tr>
	
	<TR>
    <td class="labelmedium"><b><a href="##" title="Log Reference tables edits">Maintenance Table Logging</a></b>:</b></td>
    <TD class="labelmedium">
	  <input type="radio" class="radiol" name="EnableMaintenanceLog" id="EnableMaintenanceLog" value="1" <cfif Get.EnableMaintenanceLog eq "1">checked</cfif>>Yes
	  <input type="radio" class="radiol" name="EnableMaintenanceLog" id="EnableMaintenanceLog" value="0" <cfif Get.EnableMaintenanceLog eq "0">checked</cfif>>No
    </TD>
	</TR>
	
	<tr><td height="9"></td></tr>	
	<tr><td class="linedotted" colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center" height="34">
	 	<input type="button" onclick="validate('owner')" name="Update" id="Update" value="Save" class="button10g">	
	</td></tr>
	
	</table>
	
</cfform>	
		