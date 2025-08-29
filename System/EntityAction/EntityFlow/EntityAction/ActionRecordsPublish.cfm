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
<cfquery name="Usage" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   PA.ActionPublishNo, R.EntityCode, R.EntityClass, R.EntityClassName, P.DateEffective, PA.ActionDescription
	FROM     Ref_EntityActionPublish PA INNER JOIN
             Ref_EntityClassPublish P ON PA.ActionPublishNo = P.ActionPublishNo INNER JOIN
             Ref_EntityClass R ON P.EntityCode = R.EntityCode AND P.EntityClass = R.EntityClass
	WHERE    PA.ActionCode = '#URL.ActionCode#'
	ORDER BY  EntityClassName, PA.ActionPublishNo, P.DateEffective
</cfquery>

<table style="width:90%" align="left" class="navigation_table">
    <tr><td colspan="3" style="height:40px;font-weight:200;font-size:20px;padding-left:10px" class="labelmedium"><cf_tl id="Used in Published versions"></td></tr>
	<tr class="line labelmedium">
	    <td></td>
		<td><cf_tl id="Class"></td>
		<td><cf_tl id="Step"></td>
		<td><cf_tl id="Publish"></td>
		<td><cf_tl id="Effective"></td>
	</tr>
	<cfoutput query="Usage">
	<tr class="labelmedium navigation_row line" style="height:15px">
		<td style="width:40"></td>
		<td><a href="javascript:stepedit('#url.actionCode#','#ActionPublishNo#','#entityCode#','#entityClass#','action')">#EntityClassName#</td>
		<td>#ActionDescription#</td>
		<td>#ActionPublishNo#</td>
		<td>#dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
	</tr>
	</cfoutput>
	<tr><td height="10"></td></tr>
</table>

<cfset ajaxonload("doHighlight")>