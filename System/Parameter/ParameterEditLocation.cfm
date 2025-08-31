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

<cfform method="POST" name="editform"  onsubmit="return false">

<input type="hidden" name="Form.HostName" id="Form.HostName" value="#get.hostname#">
	
<table width="92%" border="0" cellspacing="0" cellpadding="0"  align="center" class="formpadding">
	
	<tr><td height="5"></td></tr>
	<tr><td height="3" style="height:44px;font-size:22px;font-weight:200;padding-left:10px" colspan="2" class="labellarge">Source Code location</b></td></tr>
				
	<!--- Field: Prosis Applicantion Root Path--->
    <TR>
    <td style="padding-left:10px;" class="labelit" width="160">URL:</td>
    <TD colspan="2">
	
		<table cellspacing="0" cellpadding="0">
		<tr>
		<td>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="ApplicationRoot" value="#ApplicationRoot#" message="Please enter the correct URL" required="Yes" size="40" maxlength="50">
		</cfoutput>
		</td>
		
		<td class="labelit" style="padding-left:14px;padding-right:5px">Home:</td>
		<td>
		
		<cfoutput query="get">
			<cfinput class="regularxl" 
			  title="Set the default home page for this link. Used for login expiration reset" 
			  type="Text" 
			  name="ApplicationHome" 
			  value="#ApplicationHome#" size="30" maxlength="80">
		</cfoutput>
		
		</td>
		</tr>
		</table>
	
    </TD>
	</TR>	
					
	<TR>
    <td style="padding-left:10px;" class="labelit" width="160">Application File Path:</td>
    <TD colspan="2">
        <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="ApplicationRootPath" value="#ApplicationRootPath#" message="Please enter the correct URL" required="Yes" size="40" maxlength="50">
		</cfoutput>	 	   
    </TD>
	</TR>	
		
	<!--- Field: Prosis Document Root Path--->
	<TR>
    <td style="padding-left:10px;" class="labelit" width="160">Default Attachment URL:</td>
    <TD colspan="2">
        <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="DocumentRoot" value="#DocumentRoot#" message="Please enter the correct attachment URL" required="Yes" size="75" maxlength="100">
		</cfoutput>	 	   
    </TD>
	</TR>
	
    <TR>
    <td style="padding-left:10px;" class="labelit" width="160">Default Attachment Path:</td>
    <TD colspan="2">
  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="DocumentRootPath" value="#DocumentRootPath#" message="Please enter the correct local path" required="Yes" size="40" maxlength="50">		
		</cfoutput>
    </TD>
	</TR>	
	
	<tr><td></td><td><i>This is standard path used for attachments if this is not overwritten for a specific attachment directory under [Attachment Settings]</td></tr>
						
	<TR>
    <td style="padding-left:10px;" class="labelit" width="160">Listing Preparation Path:</td>
    <TD colspan="2">
        <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="ListingRootPath" value="#ListingRootPath#" message="Please enter the correct URL" required="Yes" size="40" maxlength="50">
		</cfoutput>	 	   
    </TD>
	</TR>
		
	<tr><td></td><td><i>This is standard path used for storing listing custom queries</td></tr>
	
			
	<tr><td style="height:45px;font-size:22px;font-weight:200;padding-left:10px" height="3" class="labellarge" colspan="2">Document Management Xythos Server</td></tr>
			
	<!--- Field: Prosis Document Root Path--->
    <TR>
    <td style="padding-left:10px;" width="160" class="labelit">Name:</td>
    <TD colspan="2">
  	   <cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="DocumentServer" value="#DocumentServer#" message="Please enter the server name" required="No" size="40" maxlength="50">
		</cfoutput>
    </TD>
	</TR>	
	
	<!--- Field: Prosis Document Root Path--->
    <TR>
    <td style="padding-left:10px;" width="160" class="labelit">Logon Name:</td>
    <TD colspan="2">
  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="DocumentServerLogin" value="#DocumentServerLogin#" message="Please enter the correct login" required="No" size="50" maxlength="50">		
		</cfoutput>
    </TD>
	</TR>	
	
	<TR>
    <td style="padding-left:10px;" width="160" class="labelit">Logon Password:</td>
    <TD colspan="2">
  	    <cfoutput query="get">
			<cfif Len(DocumentServerPassword) gt 25>
		        <cf_decrypt text = "#DocumentServerPassword#">
				<cfset vPassword = "#Decrypted#">
			<cfelse>
				<cfset vPassword = "#DocumentServerPassword#">
			</cfif>
			<cfinput class="regularxl" type="Password" name="DocumentServerPassword" value="#vPassword#" message="Please enter the correct password" required="No" size="40" maxlength="50">		
		</cfoutput>
    </TD>
	</TR>				
		
	<tr><td style="height:45px;font-size:22px;font-weight:200;padding-left:10px" class="labellarge" height="3">Reporting</td></tr>
	
				
		 <!--- Field: Prosis Document Root Path--->
    <TR>
    <td style="padding-left:10px;" class="labelit" width="160">URL:</td>
    <TD style="padding-right:5px">
  	   <cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="ReportRoot" value="#ReportRoot#" message="Please enter the correct path" required="Yes" size="50" maxlength="50">
	   </cfoutput>
    </TD>
	<td rowspan="5" style="min-width:80px;border:0px solid silver" align="center">	
		<cf_reportlogo size="120">	
	</td>
	</TR>	
	
		 <!--- Field: Prosis Document Root Path--->
    <TR>
    <td style="padding-left:10px;" class="labelit" width="160">Local path:</td>
    <TD>
  	   <cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="ReportRootPath" value="#ReportRootPath#" message="Please enter the correct local path" required="Yes" size="50" maxlength="50">		
		</cfoutput>
    </TD>	
	
	</TR>	
	
	<TR>
    <td style="padding-left:10px;min-width:200px" class="labelit" width="160">Report Page Type:</b></td>
    <TD>
		<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="ReportPageType" value="#ReportPageType#" size="20" maxlength="20">
		</cfoutput>	
	</TD>		
	
	</TR>
	
	<TR>
    <td style="padding-left:10px;" class="labelit" width="160">Logo Report path:</b></td>
    <TD>
	<table cellspacing="0" cellpadding="0"><tr><td>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="LogoPath" value="#LogoPath#" size="50" maxlength="80">
		</cfoutput>
		</td>
		<td class="labelit" style="min-width:80px;padding-left:14px;padding-right:4px">File name:</td>
		<td><cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="LogoFileName" value="#LogoFileName#" size="20" maxlength="30">
		</cfoutput>
		</td>
		</tr></table>
	</TD>		
	
	</TR>
	
	<TR>
    <td style="padding-left:10px;" class="labelit" width="160">Logo Application path:</b></td>
    <TD>
	<table cellspacing="0" cellpadding="0"><tr><td>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="AppLogoPath" value="#AppLogoPath#" size="50" maxlength="80">
		</cfoutput>
		</td>
		<td class="labelit" style="min-width:80px;padding-left:14px;padding-right:4px">File name:</td>
		<td><cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="AppLogoFileName" value="#AppLogoFileName#" size="20" maxlength="30">
		</cfoutput>
		</td>
		</tr></table>
	</TD>		
	
	</TR>
	
	
						
	<!--- Field: Prosis Document Root Path--->
    <TR>
    <td style="padding-left:10px;" class="labelit" width="160">Scheduler Root path:</td>
    <TD>
  	   <cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="SchedulerRoot" title="Location for scheduler task files" value="#SchedulerRoot#" message="Please enter the correct path" required="Yes" size="50" maxlength="50">
		</cfoutput>
    </TD>
	</TR>	
	
	
	<tr><td style="height:40px;font-size:22px;font-weight:200;padding-left:10px" class="labellarge" height="3" colspan="2">Supporting Engines</b></td></tr>		
	
	<TR>
    <td class="labelit" width="160" valign="top" style="padding-left:10px;padding-top:6px">Word/RTF to PDF Converter:</b></td>
    <TD colspan="2">  
	<table cellspacing="0" cellpadding="0">
	 <tr><td>
  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="PDFEngine" value="#PDFEngine#" required="No" size="50" maxlength="50">			
		</cfoutput>
		</td>		
		</tr>
		<tr><td class="labelmedium" style="font-size:12px">
		<cfoutput>
		Enter [OpenOffice] if your CF application server has <a href="http://www.openoffice.org/index.html"><font color="0080C0">Open Office</font> Installed</a> <img src="#SESSION.root#/images/openOffice.png" alt="" width="14" height="14" align="absmiddle" border="0"> or record the local path (like D:\PDF\Convert Doc\ConvertDoc.exe) to file ConvertDoc.exe released by <a href="http://www.softinterface.com/"><font color="0080C0">SoftInterface</a>.</td></tr>
		</cfoutput>
	</table>
		
    </TD>
	</TR>
	
	<TR class="hide">
    <td style="padding-left:10px;" class="labelit" width="160">Excel to PDF Converter:<cf_space spaces="60"></b></td>
    <TD colspan="2">
  
  	    <cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="XLSEngine" value="#XLSEngine#" required="No" size="50" maxlength="50">			
		</cfoutput>
		<cf_tl id="deprecated">
    </TD>
	</TR>

	<tr><td height="6"></td></tr>	
	<tr><td class="line" colspan="3"></td></tr>
	
	<tr><td colspan="3" align="center" height="34">
	 	<input type="button" onclick="validate('location')" name="Update" id="Update" value="Save" class="button10g">	
	</td></tr>
	
	</table>
	
</cfform>	