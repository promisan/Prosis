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
<cfquery  dbtype="query" name="BestRate"  maxrows="1">

	SELECT Rate, ServiceName, RateClass,RateCategory
	FROM CountryRates
	ORDER BY Rate ASC

</cfquery>

<cfif print eq "1">
	<cfajaximport params="#{googlemapkey='ABQIAAAAi9bIb1xLu73wXCBvJlUoNxRjoBV8zVO6GmA_tH8FeU0TBIg78xRgLzT28i1lowz5Kkogo1KzXUJerg'}#">
</cfif>

<cf_tableround mode="solidcolor" color="silver" totalwidth="50%">
		<cftry>							
			<cfquery name="Country"
					datasource="appsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					SELECT  *
					FROM    Ref_Nation
					WHERE   Code = '#url.country#'		
			</cfquery>
	
			<cfinvoke component="service.maps.googlegeocoder3" 
			          method="googlegeocoder3" 
					  returnvariable="details">	  
					  <cfinvokeargument name="address" value="#Country.Name#">
					  <cfinvokeargument name="ShowDetails" value="false">
			</cfinvoke>	 
			<cfset lat = details.latitude>
			<cfset lng = details.longitude>
			
			<cfoutput>
			<cfmap name="gmap"
			    centerlatitude="#lat#" 
			    centerlongitude="#lng#" 	
			    doubleclickzoom="true" 
				collapsible="false"  
				markercolor="1D8FCC"	
				markerwindowcontent="To call <b>#details.Formatted_Address#</b> (#country.continent#) dial:<br> 011 + <b>#CountryRates.prefix#</b> + destination + PIN CODE.<br><br>The best rate for this call is $<b>#numberformat(BestRate.Rate,"__,__.__")#</b> p/min<br>Thru <b>#BestRate.ServiceName# - #BestRate.RateClass#</b>"	
				overview="true" 
				height="230"
				width="400"
				typecontrol="advanced" 
				hideborder="true"
				type="terrain"
				zoomcontrol="large3d"
			    scrollwheelzoom="false" 
				showmarkerwindow="true"
			    showscale="false"	
			    tip="#details.Formatted_Address#" 
			    zoomlevel="4"/> 
			</cfoutput>
			
		<cfcatch>
		<b>No Map:</b><br>
		Country not found!
		</cfcatch>
		</cftry>
</cf_tableround>

