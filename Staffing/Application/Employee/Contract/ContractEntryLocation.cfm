
	<cfquery name="Location" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT   *, (SELECT LocationName 
		             FROM   Ref_PayrollLocationMission
					 WHERE  LocationCode = R.LocationCode 
					 AND    Mission = '#url.Mission#') as LocationName
		FROM     Ref_PayrollLocation R
		WHERE    LocationCode IN (SELECT LocationCode 
		                          FROM   Ref_PayrollLocationMission 
								  WHERE  LocationCode = R.LocationCode  
								  AND    Mission      = '#url.Mission#'
								 )					
	</cfquery>	
	
	<cfquery name="Default" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_PayrollLocationMission							
			WHERE   Mission = '#url.Mission#'					
			AND     LocationDefault = 1
	</cfquery>		
	
	<select name="ServiceLocation" class="regularxl">
	
	    <option value="">-- select --</option>
		<cfoutput query="Location">
		     <option value="#LocationCode#" <cfif LocationCode eq Default.LocationCode>selected</cfif>>#LocationCode# <cfif LocationName eq "">#Description#<cfelse>#LocationName#</cfif>
		</cfoutput>		
		
	</select>