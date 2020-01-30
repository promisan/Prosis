<cfoutput>

<cfif url.PublishNo eq "">

	<cfquery name="ClassLng" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityClassAction_Language
		WHERE  EntityCode    = '#URL.EntityCode#'
		AND    EntityClass   = '#URL.EntityClass#'
		AND    ActionCode    = '#URL.ActionCode#'
	</cfquery>
	
<cfelse>

	<cfquery name="ClassLng" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_EntityActionPublish_Language
		WHERE  	ActionCode    = '#URL.ActionCode#'
		AND     ActionPublishNo  = '#URL.PublishNo#'		
	</cfquery>
</cfif>

<table width="92%" border="0" cellspacing="0" align="center" cellpadding="0">
		
	<tr class="line"><td colspan="2" style="font-weight:200;font-size:11px">Action labels <cfif url.PublishNo neq ""><cfoutput>(#url.PublishNo#)</cfoutput></cfif></td></tr>
		
	<tr class="line">
		<td valign="top" style="padding-top:2px" class="labelmedium">Action descriptive</font>
		</td>
		<td>
		<table width="100%" class="formspacing">
			<cfloop query = "ClassLng">
			<tr height="20">
				<td width="10%" class="labelmedium">#LanguageCode#</td>
				<td width="90%"><input type="Text" class="regularxl enterastab" name="#LanguageCode#_ActionDescription" maxlength="80" size="60" value="#ActionDescription#"></td>
			</tr>
			</cfloop>	
		</table>
		</td>
	</tr>	
	
	<tr class="line">
		<td valign="top" style="padding-top:2px" class="labelmedium">Action process</font>
		</td>
		<td>
		<table width="100%" class="formspacing">
			<cfloop query = "ClassLng">
			<tr height="20">
				<td width="10%" class="labelmedium">#LanguageCode#</td>
				<td width="90%"><input type="Text" class="regularxl enterastab" name="#LanguageCode#_ActionProcess" maxlength="80" size="20" value="#ActionProcess#"></td>
			</tr>
			</cfloop>	
		</table>
		</td>
	</tr>	
	
	<tr class="line">
		<td valign="top" style="padding-top:2px" class="labelmedium">.... completed
		</td>
		<td>
		<table width="100%" class="formspacing">
			<cfloop query = "ClassLng">
				<tr height="20">
					<td width="10%" class="labelmedium">#LanguageCode#</td>
					<td width="90%"><input type="Text" class="regularxl enterastab" name="#LanguageCode#_ActionCompleted" maxlength="80" size="60" value="#ActionCompleted#"></td>
				</tr>
			</cfloop>	
		</table>
		</td>
	</tr>	
	<tr class="line">
		<td valign="top" style="padding-top:2px" class="labelmedium">.... denied
		</td>
		<td>
		<table width="100%"class="formspacing">
			<cfloop query = "ClassLng">
				<tr height="20">
					<td width="10%" class="labelmedium">#LanguageCode#</td>
					<td width="90%"><input type="Text" class="regularxl enterastab" name="#LanguageCode#_ActionDenied" maxlength="80" size="60" value="#ActionDenied#"></td>
				</tr>
			</cfloop>	
		</table>
		</td>
	</tr>	
	<tr class="line">
		<td valign="top" style="padding-top:2px" class="labelmedium">"Go To" description
		</td>
		<td>
		
		<table width = "100%" class="formspacing">
			<cfloop query = "ClassLng">
				<tr height="20">
					<td width="10%" class="labelmedium">#LanguageCode#:</td>
					<td width="90%"><input type="Text" class="regularxl enterastab" name="#LanguageCode#_ActionGoToLabel" maxlength="20" size="20" value="#ActionGoToLabel#"></td>
				</tr>
			</cfloop>	
		</table>
		
		</td>
	</tr>			
	<tr class="line">
		<td valign="top" class="labelmedium" style="padding-top:8px">Actor name</td>
		<td>		
		<table width="100%" class="formspacing">
			<cfloop query = "ClassLng">
				<tr height="20">
					<td width="10%" class="labelmedium">#LanguageCode#:</td>
					<td width="90%"><input type="Text" class="regularxl enterastab" name="#LanguageCode#_ActionReference" maxlength="20" size="20" value="#ActionReference#"></td>
				</tr>
			</cfloop>	
		</table>
		
		</td>
	</tr>					
	
	<tr><td height="30" align="center" colspan="2" style="height:30px">
		<input class="button10g"  style="width:240;height:21" type="button" name="Update" id="Update" value="Apply" onClick="savequick()">
	</td></tr>	
	
</table>	
</cfoutput>