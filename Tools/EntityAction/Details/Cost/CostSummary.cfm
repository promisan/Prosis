<!--
    Copyright © 2025 Promisan

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

<cfquery name="Total" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     DocumentCurrency, SUM(DocumentAmount) AS Total
	FROM         OrganizationObjectActionCost
	WHERE     ObjectId = '#URL.ObjectId#'
	GROUP BY DocumentCurrency	
</cfquery>	 

<table width="98%" align="center" cellspacing="0" cellpadding="0"><tr><td>
<cfoutput query="Total">
<tr>
	<td width="90%"><cf_tl id="Total">:</td>
	<td width="40">#DocumentCurrency#</td>
	<td align="right">#numberformat(total,"__,__.__")#</td>
</tr>
</cfoutput>
<tr><td height="1" colspan="3" bgcolor="C0C0C0"></td></tr>

<cfquery name="Class" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     DocumentType, DocumentCurrency, SUM(DocumentAmount) AS Total
	FROM         OrganizationObjectActionCost
	WHERE     ObjectId = '#URL.ObjectId#'
	GROUP BY DocumentType,DocumentCurrency	
</cfquery>	 

<cfoutput query="Class">
<tr bgcolor="DCF2FA">
	<td width="90%">&nbsp;&nbsp;#DocumentType#:</td>
	<td width="40">#DocumentCurrency#</td>
	<td align="right">#numberformat(total,"__,__.__")#</td>
</tr>
</cfoutput>
<tr><td height="1" colspan="3" bgcolor="C0C0C0"></td></tr>


<cfquery name="Status" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     ActionStatus, DocumentCurrency, SUM(DocumentAmount) AS Total
	FROM         OrganizationObjectActionCost
	WHERE     ObjectId = '#URL.ObjectId#'
	GROUP BY ActionStatus,DocumentCurrency	
</cfquery>	 

<cfoutput query="Status">
<tr>
	<td width="90%"><cfif actionStatus eq "1">Cleared<cfelse>Pending</cfif>:</td>
	<td width="40">#DocumentCurrency#</td>
	<td align="right">#numberformat(total,"__,__.__")#</td>
</tr>
</cfoutput>
<tr><td height="1" colspan="3" bgcolor="C0C0C0"></td></tr>

</table>

