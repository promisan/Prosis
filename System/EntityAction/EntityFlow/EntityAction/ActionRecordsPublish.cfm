
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

<table style="width:70%" align="left" class="navigation_table">
    <tr><td colspan="3" style="height:40px;font-weight:200;font-size:20px;padding-left:10px" class="labelmedium"><cf_tl id="Used in Published versions"></td></tr>
	<tr class="line labelmedium">
	    <td></td>
		<td><cf_tl id="Class"></td>
		<td><cf_tl id="Step"></td>
		<td><cf_tl id="Publish"></td>
		<td><cf_tl id="Effectie"></td>
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