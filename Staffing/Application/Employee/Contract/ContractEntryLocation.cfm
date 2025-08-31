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
<cftry>

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
	
	<select name="ServiceLocation" class="regularxxl">
	
	    <option value="">-- select --</option>
		<cfoutput query="Location">
		     <option value="#LocationCode#" <cfif LocationCode eq Default.LocationCode>selected</cfif>>#LocationCode# <cfif LocationName eq "">#Description#<cfelse>#LocationName#</cfif>
		</cfoutput>		
		
	</select>
		
	<cfcatch>
	
	<cfquery name="Location" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			SELECT   *
			FROM     Location
			WHERE    Mission = '#url.mission#'		
		</cfquery>	
		
		<select name="ServiceLocation" class="regularxxl">
		
		    <option value="">-- select --</option>
			<cfoutput query="Location">
			     <option value="#LocationCode#">#LocationCode# #LocationName#</option> 
			</cfoutput>		
			
		</select>
	
	
	</cfcatch>	
	
</cftry>	