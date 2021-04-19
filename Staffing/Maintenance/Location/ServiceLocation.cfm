
<cfquery name="ServiceLoc"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_PayrollLocation
	WHERE	LocationCode in (SELECT LocationCode FROM Ref_PayrollLocationMission WHERE Mission = '#url.Mission#')
</cfquery>

<select name="ServiceLocation" id="ServiceLocation" class="regularxxl">
	<option value="" <cfif ServiceLoc.LocationCode eq "">selected</cfif>>---select---</option>
   <cfoutput query="ServiceLoc">
	   <option value="#ServiceLoc.LocationCode#" <cfif #ServiceLoc.LocationCode# eq "#url.ServiceLocation#">selected</cfif>>#ServiceLoc.LocationCode# - #ServiceLoc.Description#</option>
   </cfoutput>
</select>