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
<cfcomponent output="false">

	  <cffunction name="googlegeocoder3" returntype="query" access="public">
	    <cfargument name="address"     required="false" type="string"  default="">
	    <cfargument name="latlng"      required="false" type="string"  default="">
	    <cfargument name="language"    required="false" type="string"  default="">
	    <cfargument name="bounds"      required="false" type="string"  default="">
	    <cfargument name="region"      required="false" type="string"  default="">
	    <cfargument name="sensor"      required="false" type="boolean" default="false">
	    <cfargument name="ShowDetails" required="false" type="boolean" default="false">
	
	   <cfif arguments.ShowDetails>
		  <cfset variables.geocode_query = QueryNew("Status, Result_Type, Formatted_Address, Address_Type, Address_Long_Name, Address_Short_Name, Latitude, Longitude, Location_Type, Southwest_Lat, Southwest_Lng, Northeast_Lat, Northeast_Lng", "varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar")>
		<cfelse>
		  <cfset variables.geocode_query = QueryNew("Status, Result_Type, Formatted_Address, Latitude, Longitude, Location_Type", "varchar, varchar, varchar, varchar, varchar, varchar")>
		</cfif>
	
		<cftry>    
		    	
		    <cfif len(trim(arguments.address)) is 0 and len(trim(arguments.latlng)) is 0>
			
		      <cfset variables.temp = QueryAddRow(variables.geocode_query, 1)>
		      <cfset variables.temp = QuerySetCell(variables.geocode_query, "Status", "Please pass in either the address or the latitude and lautitude.")>
			  	  
		    <cfelse>
			
						
		      <cfset variables.base_url = "https://maps.google.com/maps/api/geocode/xml?">
		      <cfif len(trim(arguments.address)) is not 0>
			 			  
		        <cfset variables.address_string = urlEncodedFormat(arguments.address)>
		        <cfset variables.final_url = variables.base_url & "address=" & variables.address_string>
		      <cfelse>
			  			 
		        <cfset variables.latlng_string = Replace(arguments.latlng, " ", "", "all")>
		        <cfset variables.final_url = variables.base_url & "latlng=" & variables.latlng_string>
		      </cfif>
		      <cfset variables.final_url = variables.final_url & "&sensor=" & arguments.sensor>
		      <cfif len(trim(arguments.language)) is not 0>
		        <cfset variables.final_url = variables.final_url & "&language=" & arguments.language>
		      </cfif>
		      <cfif len(trim(arguments.bounds)) is not 0>
		        <cfset variables.final_url = variables.final_url & "&bounds=" & arguments.bounds>
		      </cfif>
		      <cfif len(trim(arguments.region)) is not 0>
		        <cfset variables.final_url = variables.final_url & "&region=" & arguments.region>
		      </cfif>
			  
			  <!---
			  <cfoutput>
			  #variables.final_url#&key=#client.googlemapid#
			  </cfoutput>
			  --->
		
			  <cfhttp url="#variables.final_url#&key=#client.googlemapid#" result="variables.resultxml">
		
			  <cfset variables.parsed_result = xmlParse(variables.resultxml.fileContent)>	  	  	  
		
		      <cfset variables.total_count = 1>
			  
		      <cfset variables.temp = QueryAddRow(variables.geocode_query, 1)>
			  
		      <cfset variables.temp = QuerySetCell(variables.geocode_query, "Status", variables.parsed_result.GeocodeResponse.status.xmltext)>
			  
		      <cfset variables.result_status = variables.parsed_result.GeocodeResponse.status.xmltext>
			 			 
		      <cfif StructKeyExists(variables.parsed_result.GeocodeResponse, "result")>			
			  			  
		  	    <cfloop from="1" to="#ArrayLen(variables.parsed_result.GeocodeResponse.result)#" index="counter">  
		          <cfset variables.type_list = "">
		          <cfloop from="1" to="#ArrayLen(variables.parsed_result.GeocodeResponse.result[counter].type)#" index="type_counter">
		            <cfif len(variables.type_list) is 0>
		              <cfset variables.type_list = variables.parsed_result.GeocodeResponse.result[counter].type[type_counter].xmltext>
					<cfelse>
		              <cfset variables.type_list = variables.type_list & "," & variables.parsed_result.GeocodeResponse.result[counter].type[type_counter].xmltext>
					</cfif>
		          </cfloop>
		          <cfif variables.total_count is not 1>
				    <cfset variables.temp = QuerySetCell(variables.geocode_query, "Status", variables.parsed_result.GeocodeResponse.status.xmltext, variables.total_count)>
				  </cfif>
		          <cfset variables.address = variables.parsed_result.GeocodeResponse.result[counter].Formatted_Address.xmltext>
		          <cfset variables.lat = variables.parsed_result.GeocodeResponse.result[counter].geometry.location.lat.xmltext>
		          <cfset variables.lng = variables.parsed_result.GeocodeResponse.result[counter].geometry.location.lng.xmltext>
		          <cfset variables.loc_type = variables.parsed_result.GeocodeResponse.result[counter].geometry.location_type.xmltext>
		          
		      	  <cfset variables.temp = QuerySetCell(variables.geocode_query, "Result_Type", variables.type_list, variables.total_count)>
		          <cfset variables.temp = QuerySetCell(variables.geocode_query, "Formatted_Address", variables.address, variables.total_count)>
		          <cfset variables.temp = QuerySetCell(variables.geocode_query, "Latitude", variables.lat, variables.total_count)>
		          <cfset variables.temp = QuerySetCell(variables.geocode_query, "Longitude", variables.lng, variables.total_count)>
		          <cfset variables.temp = QuerySetCell(variables.geocode_query, "Location_Type", variables.loc_type, variables.total_count)>
		          
		          <cfif arguments.ShowDetails>
		            <cfset variables.southwest_lat = variables.parsed_result.GeocodeResponse.result[counter].geometry.viewport.southwest.lat.xmltext>
		            <cfset variables.southwest_lng = variables.parsed_result.GeocodeResponse.result[counter].geometry.viewport.southwest.lng.xmltext>
		            <cfset variables.northeast_lat = variables.parsed_result.GeocodeResponse.result[counter].geometry.viewport.northeast.lat.xmltext>
		            <cfset variables.northeast_lng = variables.parsed_result.GeocodeResponse.result[counter].geometry.viewport.northeast.lng.xmltext>
		            <cfloop from="1" to="#ArrayLen(variables.parsed_result.GeocodeResponse.result[counter].address_component)#" index="address_counter">
		              <cfif address_counter is not 1>
		                <cfset variables.temp = QuerySetCell(variables.geocode_query, "Status", variables.result_status, variables.total_count)>
		                <cfset variables.temp = QuerySetCell(variables.geocode_query, "Formatted_Address", variables.address, variables.total_count)>
		                <cfset variables.temp = QuerySetCell(variables.geocode_query, "Latitude", variables.lat, variables.total_count)>                
		                <cfset variables.temp = QuerySetCell(variables.geocode_query, "Longitude", variables.lng, variables.total_count)>
		                <cfset variables.temp = QuerySetCell(variables.geocode_query, "Result_Type", variables.type_list, variables.total_count)>
		                <cfset variables.temp = QuerySetCell(variables.geocode_query, "Location_Type", variables.loc_type, variables.total_count)>
		              </cfif>
		              <cfset variables.temp = QuerySetCell(variables.geocode_query, "Southwest_Lat", variables.southwest_lat, variables.total_count)>
		              <cfset variables.temp = QuerySetCell(variables.geocode_query, "Southwest_Lng", variables.southwest_lng, variables.total_count)>
		              <cfset variables.temp = QuerySetCell(variables.geocode_query, "Northeast_Lat", variables.northeast_lat, variables.total_count)>
		              <cfset variables.temp = QuerySetCell(variables.geocode_query, "Northeast_Lng", variables.northeast_lng, variables.total_count)>
		              
		              <cfset variables.address_type = variables.parsed_result.GeocodeResponse.result[counter].address_component[address_counter].type.xmltext>
		              <cfset variables.address_short_name = variables.parsed_result.GeocodeResponse.result[counter].address_component[address_counter].short_name.xmltext>
		              <cfset variables.address_long_name = variables.parsed_result.GeocodeResponse.result[counter].address_component[address_counter].long_name.xmltext>
		              
		              <cfset variables.temp = QuerySetCell(variables.geocode_query, "Address_Type", variables.address_type, variables.total_count)>
		              <cfset variables.temp = QuerySetCell(variables.geocode_query, "Address_Long_Name", variables.address_long_name, variables.total_count)>
		              <cfset variables.temp = QuerySetCell(variables.geocode_query, "Address_Short_Name", variables.address_short_name, variables.total_count)>
		               			  
					  <cfif address_counter lt ArrayLen(variables.parsed_result.GeocodeResponse.result[counter].address_component)>			  
					    <cfset variables.temp = QueryAddRow(variables.geocode_query, 1)>
					  <cfelse>
					    <cfif counter lt ArrayLen(variables.parsed_result.GeocodeResponse.result)>
					      <cfset variables.temp = QueryAddRow(variables.geocode_query, 1)>
					    </cfif>  
		              </cfif>              
		              <cfset variables.total_count = variables.total_count + 1>  			               
		            </cfloop>
		          <cfelse>
		            <cfset variables.total_count = variables.total_count + 1>
		            <cfif counter lt ArrayLen(variables.parsed_result.GeocodeResponse.result)>
		              <cfset variables.temp = QueryAddRow(variables.geocode_query, 1)>
		            </cfif>
				  </cfif>
		        </cfloop>	  	  
			  </cfif>
			</cfif>   
			    
		<cfcatch>
		    error
		</cfcatch>
		
		</cftry>		
	
	<cfreturn variables.geocode_query>
		
	</cffunction>


	  <cffunction name="distance" returntype="any" access="public">
	    <cfargument name="origin"      required="true" type="string" default="">
	    <cfargument name="destination" required="true" type="string" default="">
	    <cfargument name="language" required="false" type="string" default="">
	
		<!--- by dev on 1/5/2015, Promisan b.v. ---->
		
		<cftry>    

			  <cfset variables.distance_query = QueryNew("Status, Duration, Duration_Text, Distance, Distance_Text", "varchar, varchar, varchar, varchar, varchar")>
			  		    	
		      <cfset variables.base_url = "https://maps.googleapis.com/maps/api/distancematrix/xml?">
		      <cfif len(trim(arguments.origin)) is not 0>
		        	<cfset variables.final_url = variables.base_url & "origins=" & arguments.origin>
		      <cfelse>
  			      <cfset variables.temp = QueryAddRow(variables.distance_query, 1)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Status", "Please pass in either the address or the latitude and lautitude.")>
			      <cfabort>
		      </cfif>

		      <cfif len(trim(arguments.destination)) is not 0>
		        	<cfset variables.final_url = variables.final_url & "&destinations=" & arguments.destination>
		      <cfelse>
  			      <cfset variables.temp = QueryAddRow(variables.distance_query, 1)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Status", "Please pass in either the address or the latitude and lautitude.")>
			      <cfabort>
		      </cfif>
		      
		      <cfif len(trim(arguments.language)) is not 0>
		        <cfset variables.final_url = variables.final_url & "&language=" & arguments.language>
		      </cfif>

		      
		      <!--- This is a new key I needed to generated using our gmail account dev@email, to discuss with Hanno
		      on how to add this to the client variables 1/5/2015 ---->
		      
		      <cfif len(trim(client.googleMAPId)) is not 0>
		        <cfset variables.final_url = variables.final_url & "&key=AIzaSyAgMoDlVUhdNqRPoQy20Y7YeuaMMlaEG1w">
		      </cfif>
			  	
			  <cfhttp url="#variables.final_url#" result="variables.resultxml">
			  
			  <cfset variables.parsed_result = xmlParse(variables.resultxml.fileContent)>
			  
			  <cfset variables.result_status = variables.parsed_result.DistanceMatrixResponse.status.xmltext>
			  	
			  <cfif variables.result_status eq "OK">
  			      <cfset variables.temp = QueryAddRow(variables.distance_query, 1)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Status", "OK")>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Duration", variables.parsed_result.DistanceMatrixResponse.row.element.duration.value.xmltext)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Duration_Text", variables.parsed_result.DistanceMatrixResponse.row.element.duration.text.xmltext)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Distance", variables.parsed_result.DistanceMatrixResponse.row.element.distance.value.xmltext)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Distance_Text", variables.parsed_result.DistanceMatrixResponse.row.element.distance.text.xmltext)>
			  	
			  	
			  </cfif>	
		
			    
		<cfcatch>
		    error
		</cfcatch>
		
		</cftry>		
	
	<cfreturn variables.distance_query>
		
	</cffunction>



</cfcomponent>
