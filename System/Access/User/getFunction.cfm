
<!--- get function --->

<cfparam name="url.mission"   default="">
<cfparam name="url.usergroup" default="">

<cfquery name="Function" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *, (SELECT count(*) 
	            FROM   MissionProfileGroup 
			    WHERE  ProfileId       = M.ProfileId 			   
			    AND    AccountGroup     = '#url.usergroup#') as Counted
    FROM     MissionProfile M
	WHERE    Mission = '#url.mission#'
	AND      Operational = 1
	ORDER BY ListingOrder	
</cfquery>

<cfif function.recordcount eq "0">

<table><tr class="labelmedium"><td>No functions set</td></tr></table>

<cfelse>

<cfset cnt = 0>
<table style="background-color:f1f1f1">
<cfoutput query="Function">
	<cfset cnt = cnt + 1>
    <cfif cnt eq "1">
	  <tr class="labelmedium2" style="height:18px">
	</cfif>
	<td style="width:30px;padding-left:2px;padding-right:8px">
	     <input type="checkbox" class="radiol" name="functionselect" <cfif counted gte "1">checked</cfif> value="#ProfileId#">
	 </td>
	 <td style="padding-right:8px;width:200px">#FunctionName#</td>
	 
	 <cfif cnt eq "3">
	     <cfset cnt = 0></tr>
	</cfif>
</cfoutput>
</table>

</cfif>

