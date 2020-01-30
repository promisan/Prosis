<cfparam name="url.owner" default="">
<cfparam name="url.rule" default="">

<cfquery name="Rules"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Rule 
	WHERE  TriggerGroup = 'Process' AND Owner ='#url.owner#' AND Operational = 1
	ORDER  BY Owner, TriggerGroup
</cfquery>


<cf_screentop height="100%"
			  title="Select Business Rule" 
			  scroll="Yes" 
			  layout="webapp" 
			  close = "ColdFusion.Window.hide('RuleWindow');"
			  banner="gray"
			  label="Select Business Rule" >


<table width="100%">
	<tr>
		<td width="100%" style="padding-top:8px" align="center" class="labellarge">
			Rule:&nbsp;&nbsp;
			<select name="rule" id="rule" class="regularxl" onchachange="ColdFusion.navigate(,'ruleDetail')">
				<option value=""></option>
				<cfoutput query="Rules">
					<option value="#Code#" <cfif Rules.Code eq url.rule>selected</cfif> ><cfif Description neq "">#Description#<cfelse>#Code#</cfif></option>
				</cfoutput>
			</select>
			
		</td>
	</tr>
	<tr>
		<td id="ruleDetail">
			
			<cfdiv bind="url:RuleDetail.cfm?rule={rule}&owner=#url.owner#&level=#url.level#&from=#url.from#&to=#url.to#" bindOnLoad="Yes">
			
		</td>
	</tr>
</table>

