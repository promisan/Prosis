<cfquery name="getConfigMission" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	skMissionItemPrice 
		WHERE  	ItemNo = '#url.item#'
		AND    	UoM    = '#url.uom#'
        AND     Mission = '#url.mission#'
		ORDER BY ListingOrder ASC
</cfquery>

<cfoutput query="getConfigMission">
    <table width="100%">
        <tr>
            <td width="5%">
                <input type="checkbox" class="clsPrintLabelParameterCheck" name="fprice#priceschedule#" id="fprice#priceschedule#" style="height:15px; width:15px;" onclick="refreshLabelEPLButton('#url.item#', '#url.uom#')" <cfif fieldDefault eq 1>checked</cfif>>
            </td>
            <td class="labelmedium" style="padding-left:5px;"><label for="fprice#priceschedule#">#PriceScheduleDescription#</label></td>
        </tr>
    </table>
</cfoutput>

<cfset ajaxOnLoad("function() { refreshLabelEPLButton('#url.item#', '#url.uom#') }")>