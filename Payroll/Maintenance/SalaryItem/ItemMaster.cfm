<cf_compression>

<cfquery name="ItemMaster" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ItemMaster
	WHERE Code IN (SELECT ItemMaster FROM ItemMasterObject WHERE ObjectCode = '#url.object#')
	AND Operational = 1				
</cfquery>

<cfquery name="Check"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM SalarySchedulePayrollItem
	WHERE Mission       = '#url.mission#'
	AND  SalarySchedule = '#url.schedule#'
	AND PayrollItem     = '#url.item#'
</cfquery>			

<select name="<cfoutput>itemmaster_#url.row#</cfoutput>" id="<cfoutput>itemmaster_#url.row#</cfoutput>" class="regularxl" style="width:220">
      <option value=""></option>
	      <cfoutput query="ItemMaster">
			     <option value="#Code#" <cfif Check.ItemMaster eq Code> SELECTED</cfif>>
					 #Code# #Description#</option>
		   </cfoutput>
</select>