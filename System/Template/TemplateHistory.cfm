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
<cfquery name="Find" 
datasource="appsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE TemplateId = '#URL.ID#'
</cfquery>	

<cfset srvnme  = "#Find.ApplicationServer#">
<cfset filedir = "#Find.PathName#">
<cfset filenme = "#Find.FileName#">

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding"><tr>

<cfquery name="Template" 
	datasource="appsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE  FileName          = '#filenme#'
	AND    PathName          = '#filedir#'
	AND    ApplicationServer = '#srvnme#'
	<!--- 
	AND    VersionDate != '#dateFormat(find.VersionDate,client.DateSQL)#'
	--->
	AND    TemplateStatus = '1'
	ORDER BY Created DESC 
</cfquery>
		
<cfif template.recordcount eq "0">
  <tr><td align="center"><b>No history found</td></tr>

<cfelse>  

<!---
<tr bgcolor="white">
    <td></td>
	<td>Modified on</td>
	<td>Officer</b></td>
	<td>Size</td>
	<td>Version Date</td>
</tr>
<tr><td height="1" bgcolor="silver" colspan="5"></td></tr>			
--->
		
<cfloop query="Template">

	<cfif dateformat(VersionDate,client.DateSQL) eq dateFormat(find.VersionDate,client.DateSQL)>
	<cfset color = "ffffcf">
	<cfelse>
	<cfset color = "white">
	</cfif>
	
	<tr bgcolor="#color#"><td width="20" align="center">
	<img src="#SESSION.root#/Images/pointer.gif" alt="" align="absmiddle" border="0">
	</td>
	<td>
	<cfif find(".cfr",filename)>
		#dateFormat(TemplateModified,CLIENT.DateFormatShow)# #timeFormat(TemplateModified,"HH:MM")#
	<cfelse>
		<a href="javascript:detail('#TemplateId#','prior')" title="Retrieve template details">
		  #dateFormat(TemplateModified,CLIENT.DateFormatShow)# #timeFormat(TemplateModified,"HH:MM")#
		</a>
	</cfif>
		
	</td>
	<td>#TemplateModifiedBy#</td>
	<td>#numberformat(TemplateSize/1024,"_._")# kb</td>
	<td>#dateFormat(VersionDate,CLIENT.DateFormatShow)#</td>
	</tr>
</cfloop>
	
</tr>

</cfif>

</cfoutput>

