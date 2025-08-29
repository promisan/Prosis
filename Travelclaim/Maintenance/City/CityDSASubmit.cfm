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
<cfparam name="URL.action" default="Add">
<cfparam name="URL.mode" default="Default">
<cfparam name="URL.DateEffective" default="">
<cfparam name="URL.DateExpiration" default="">

<cfif URL.DateExpiration neq "" or URL.DateEffective neq "">	

	<cfif URL.DateEffective eq "">
		<cfset URL.DateEffective = "01/01/2000">
	</cfif>
	
	<cfif URL.DateExpiration eq "">
		<cfset URL.DateExpiration = "01/01/2099">
	</cfif>

</cfif>


<cfif URL.DateEffective neq "">

	<cfif not isDate(URL.DateEffective)>	
		<cfsavecontent variable="result">
		<font color="#FF0000"><b>Invalid date entered</b></font>
		</cfsavecontent>	
		<cfset url.result = result>
		<cfset url.id = URL.CountryCityId>		
		<cfinclude template="CityDSA.cfm">
		<cfabort>
	</cfif>	
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#URL.DateEffective#">
	<cfset MSTR = dateValue>
		
</cfif>	
	
<cfif URL.DateExpiration neq "">	

	<cfif not isDate(URL.DateExpiration)>
		<cfsavecontent variable="result">
		<font color="#FF0000"><b>Invalid date entered</b></font>
		</cfsavecontent>	
		<cfset url.id = URL.CountryCityId>
		<cfset url.result = result>
		<cfinclude template="CityDSA.cfm">
		<cfabort>
	</cfif>	
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#URL.DateExpiration#">
	<cfset MEND = dateValue>	
	
	<cfif MEND lte MSTR>

		<cfsavecontent variable="result">
    	<font color="#FF0000"><b>Invalid period entered</b></font>
    	</cfsavecontent>	
		<cfset url.result = result>
		<cfset url.id = URL.CountryCityId>
		<cfinclude template="CityDSA.cfm">
		<cfabort>

	</cfif>
	
</cfif>	

<cfif url.mode eq "Hotel">

	<cfquery name="Check" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Ref_PayrollLocation
			SET HotelRate = '#url.action#'
			WHERE LocationCode = '#URL.Code#'		
	    </cfquery>	
		
</cfif>


<cfif url.mode eq "Season">

	<cfquery name="Check" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Ref_PayrollLocation
			SET SeasonalRate = '#url.action#'
			WHERE LocationCode = '#URL.Code#'		
	    </cfquery>	
			
</cfif>

<cfif url.mode eq "Default">
	
	<cfif URL.Action eq "Add">
	
		<cfquery name="Exist" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM   Ref_CountryCityLocation
				WHERE  CountryCityId = '#URL.CountryCityId#'		
				AND    LocationCode  = '#URL.LocationCode#'				
		</cfquery>		
		
		<cfquery name="Default" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM   Ref_CountryCityLocation
				WHERE  CountryCityId = '#URL.CountryCityId#'		
				AND    LocationDefault = 1				
		</cfquery>	
	
		<cfif exist.recordcount eq "0">
	
			<cfquery name="Add" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_CountryCityLocation
			(CountryCityId,LocationCode,LocationDefault
			 <cfif #URL.DateEffective# neq "">
			 ,DateEffective
			 </cfif>
			 <cfif #URL.DateExpiration# neq "">
			 ,DateExpiration
			 </cfif>
			 )
			VALUES ('#URL.CountryCityId#','#URL.LocationCode#',
					<cfif Default.recordcount eq "0">1<cfelse>0</cfif>
					<cfif URL.DateEffective neq "">,#MSTR#</cfif>
					<cfif URL.DateExpiration neq "">,#MEND#</cfif>)
			</cfquery>	
			
		<cfelse>
		
			<cfif URL.DateEffective neq "" and URL.DateExpiration neq "">
		
				<cfquery name="Edit" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE Ref_CountryCityLocation
					SET DateEffective = #MSTR#, DateExpiration = #MEND#
					<cfif url.locationDefault eq "true">
					, LocationDefault = 1
					<cfelse>
					, LocationDefault = 0
					</cfif>
						
					WHERE  CountryCityId = '#URL.CountryCityId#'		
					AND    LocationCode = '#URL.LocationCode#'			
				</cfquery>	
			
			<cfelse>
			
				<cfquery name="Edit" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE Ref_CountryCityLocation
					SET    DateEffective  = NULL, 
					       DateExpiration = NULL			
					WHERE  CountryCityId  = '#URL.CountryCityId#'		
					AND    LocationCode   = '#URL.LocationCode#'			
				</cfquery>	
				
				<cfquery name="Default" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT * 
					FROM   Ref_CountryCityLocation
					WHERE  CountryCityId = '#URL.CountryCityId#'		
					AND    LocationDefault = 1				
				</cfquery>	
				
				<cfif Default.recordcount eq "0">
				
					<cfquery name="Check" 
					datasource="appsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE Ref_CountryCityLocation
						SET    LocationDefault = 1  
						WHERE  CountryCityId = '#URL.CountryCityId#'	
						AND    LocationCode  = '#URL.LocationCode#'									
				    </cfquery>	
				
				</cfif>						
			
			</cfif>
		
		</cfif>	
		
		<!--- default was selected --->
	
		<cfif URL.locationDefault eq "true">
		
			<cfquery name="Exist" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM   Ref_CountryCityLocation
				WHERE  CountryCityId = '#URL.CountryCityId#'		
				AND    LocationCode  = '#URL.LocationCode#'				
		   </cfquery>		
		
			<cfquery name="Check" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Ref_CountryCityLocation
				SET    LocationDefault = 0
				WHERE  CountryCityId = '#URL.CountryCityId#'	
				AND    LocationCode != '#URL.LocationCode#'
				
				<cfif  Exist.dateeffective neq "">
				AND  (
				       (DateExpiration is NULL OR DateEffective is NULL) OR
					   (DateEffective     <= '#dateformat(Exist.DateExpiration,client.dateSQL)#' 
					   AND DateExpiration >= '#dateformat(Exist.DateExpiration,client.dateSQL)#') OR
					   (DateEffective     <= '#dateformat(Exist.DateEffective,client.dateSQL)#' 
					   AND DateExpiration >= '#dateformat(Exist.DateEffective,client.dateSQL)#')
					   				
				     )
			    </cfif>		
						
		    </cfquery>	
			
			<cfquery name="Exist" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Ref_CountryCityLocation
				SET    LocationDefault = 1
				WHERE  CountryCityId = '#URL.CountryCityId#'		
				AND    LocationCode  = '#URL.LocationCode#'				
		   </cfquery>		
			
		<cfelse>
		
			<cfquery name="Default" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM   Ref_CountryCityLocation
				WHERE  CountryCityId = '#URL.CountryCityId#'		
				AND    LocationDefault = 1				
			</cfquery>	
			
			<cfif Default.recordcount eq "0">
			
				<cfquery name="Check" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE Ref_CountryCityLocation
					SET    LocationDefault = 1 
					WHERE  CountryCityId = '#URL.CountryCityId#'	
					AND    LocationCode  = '#URL.LocationCode#'									
			    </cfquery>	
			
			</cfif>		
			
		</cfif>
		
					
	<cfelseif URL.Action eq "Edit">
	
		<cfquery name="DefaultSet" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM   Ref_CountryCityLocation
				WHERE  CountryCityId = '#URL.CountryCityId#'		
				AND    LocationCode  = '#URL.Code#'				
		</cfquery>			
	
		<cfquery name="Default" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Ref_CountryCityLocation
			SET    LocationDefault = 0
			WHERE  CountryCityId = '#URL.CountryCityId#'
			<cfif  DefaultSet.dateeffective neq "">
				AND  (
				       (DateExpiration is NULL OR DateEffective is NULL) OR
					   (DateEffective     <= '#dateformat(DefaultSet.DateExpiration,client.dateSQL)#' 
					   AND DateExpiration >= '#dateformat(DefaultSet.DateExpiration,client.dateSQL)#') OR
					   (DateEffective     <= '#dateformat(DefaultSet.DateEffective,client.dateSQL)#' 
					   AND DateExpiration >= '#dateformat(DefaultSet.DateEffective,client.dateSQL)#')
					   				
				     )
			</cfif>		
		</cfquery>	
	
		<cfquery name="Default" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Ref_CountryCityLocation
			SET    LocationDefault = 1
			WHERE  LocationCode  = '#URL.Code#'
			AND    CountryCityId = '#URL.CountryCityId#'
		</cfquery>	
	
	<cfelseif URL.Action eq "Delete">
	
	   <cftransaction>
	   
	   <cfquery name="Check" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM Ref_CountryCityLocation
			WHERE CountryCityId = '#URL.CountryCityId#'
			AND   LocationCode  = '#URL.Code#'
		</cfquery>	
	
		<cfquery name="Delete" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_CountryCityLocation
			WHERE CountryCityId = '#URL.CountryCityId#'
			AND   LocationCode  = '#URL.Code#'
		</cfquery>	
					
		<cfif Check.LocationDefault eq "1">
		
			<cfquery name="New" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM Ref_CountryCityLocation
				WHERE CountryCityId = '#URL.CountryCityId#'
			</cfquery>	
			  
			  <cfquery name="Default" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Ref_CountryCityLocation
				SET LocationDefault = 1
				WHERE CountryCityId = '#URL.CountryCityId#'
				AND  LocationCode = '#New.LocationCode#'
			</cfquery>	
		
		</cfif>
		
		</cftransaction>
		
	</cfif>	
				
</cfif>	
	
<cfinclude template="CityDSA.cfm">
	
