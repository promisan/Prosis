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
<cfswitch expression="#Level#">
			
		<cfcase value="1">

				<cfquery name="Level01" 
				  datasource="appsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT L.TreeOrder, L.LocationName, L.Location, L.LocationCode
				      FROM    Location L 
				   	  WHERE   L.ParentLocation is NULL
					  AND     L.Mission      = '#Mission#'
					  AND    (L.DateExpiration is NULL or L.DateExpiration > getDate())
					  GROUP BY L.TreeOrder, L.LocationName, L.Location, L.LocationCode
					  ORDER BY L.TreeOrder, L.LocationName
				  </cfquery>	

		  		  <cfset exist  = FALSE>
				  
				  <cfloop query="level01">
		  			    <cfset exist  = TRUE>
					    <cfset nme = replace(LocationName, "'","", "ALL")> 
				  	    <cfset s = StructNew()> 		
					  	<cfset s.value    = "#location#">
				        <cfset s.display  = "<span class='labelit'>#nme#</span>">
						<cfset s.parent   = "Location">
						<cfset s.expand   = "No">						
						<cfset s.href     = "javascript:listshow('PHY','#Level01.Location#','#mission#')">					  

					      <cfquery name="Children" 
					      datasource="appsMaterials" 
					      username="#SESSION.login#" 
					      password="#SESSION.dbpw#">
						      SELECT Count(1) as Total
						      FROM         Location
						 	  WHERE        ParentLocation   = '#location#'
							  AND          Mission          = '#Mission#'
						    </cfquery>			
						<cfif Children.total eq 0>
							<cfset s.leafnode=true/>
						</cfif>					
						
						<cfset arrayAppend(result,s)/>
				  </cfloop>

				  <cfif NOT exist>
	    	    		<cfset s = StructNew()> 
				        <cfset s.value = "Location_Not_Found"> 
				        <cfset s.display = "<i>Empty</i>"> 
						<cfset s.parent  = "Location">
						<cfset s.leafnode=true/>
						<cfset arrayAppend(result,s)/>				
				  </cfif>
				  
		</cfcase>
			
		<cfcase value="2,3,4">
		
		      <cfquery name="SubLevel" 
		      datasource="appsMaterials" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      SELECT     DISTINCT TreeOrder, LocationName, Location, LocationCode 
			      FROM       Location
			 	  WHERE      ParentLocation   = '#vmid#'
				  AND        Mission          = '#Mission#'
				  ORDER BY   TreeOrder, LocationName 
			  </cfquery>			
		
			  <cfloop query="SubLevel">
				
				  <cfset nme = replace(LocationName,"'","", "ALL")> 
				  <cfset nme = replace(nme,',',"", "ALL")> 
				  <cfset nme = replace(nme,'"',"", "ALL")> 
		  
				  <cfset s = StructNew()> 		
				  <cfset s.value="#location#">
			      <cfset s.display="#nme#">
				  <cfset s.parent="#vmid#">					  
				  <cfset s.expand="No">
				  <cfset s.href="javascript:listshow('PHY','#Location#','#mission#')">				
				  
			      <cfquery name="Children" 
			      datasource="appsMaterials" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
				      SELECT    Count(1) as Total
				      FROM      Location
				 	  WHERE     ParentLocation   = '#location#'
					  AND       Mission          = '#Mission#'
				  </cfquery>			

				  <cfif Level eq 4 or children.total eq 0>
  						<cfset s.leafnode=true/>
				  </cfif>
				  
	  			  <cfset arrayAppend(result,s)/>	
				  		
			  </cfloop>		
				  
		</cfcase>
			
</cfswitch>			