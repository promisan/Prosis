<!--
    Copyright © 2025 Promisan

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

<cfset rows = attributes.resolution>
<cfset columns = attributes.resolution>

<!--- returns variable.x, variable.y --->
<cffunction name="getCoordinates" access="public">

	<cfargument name="index" type="numeric">
	<cfargument name="angle" type="numeric">
	<cfargument name="radius" type="numeric">
	
	<cfset angle = index * angle>
	
	<cfset var coordinates = structNew()>
	
	<!--- From Polar to Cartesian --->
	<cfset xCartesian = radius * cos(angle)>
	<cfset yCartesian = radius * sin(angle)>
	
	<cfset xCartesian = round(xCartesian)>
	<cfset yCartesian = round(yCartesian)>
	
	<!--- From Cartesian to columns and rows --->
	<cfset xOffset = round(columns/2)>
	<cfset yOffset = round(rows/2)>
	
	<cfset coordinates.r = xCartesian + xOffset-2>
	<cfif coordinates.r lt 1>
		<cfset coordinates.r = 1 >
	</cfif>
	
	<cfset coordinates.c = -yCartesian + yOffset - 1 >
	
	<cfif coordinates.c lt 1>
		<cfset coordinates.c = 1>
	</cfif>

	<cfreturn coordinates>
	
</cffunction>




<!---- returns an array (sub - array) of elements at a given level --->
<cffunction name="getArrayOfLevel" access="public">

	<cfargument name="completeArray" type="array">
	<cfargument name="level" type="numeric">
	
	<cfset var subArray = ArrayNew(1)>
	<cfset var position = 1>
	
	<cfloop index="indx" from="1" to="#ArrayLen(completeArray)#">
	
		<cfif completeArray[indx].level eq level>
		
			<cfset subArray[position] = 
          		{elementid        = completeArray[indx].elementid, 
          		 elementclass   =  completeArray[indx].elementclass,
          		 level = "#level#" }>  
			
			<cfset position = position + 1 >

		</cfif>
		
	</cfloop>	
	
	<cfreturn subArray>
	
</cffunction>




<cfoutput>

<!--- Populate --->
	

	<cfset centerRow = round(rows/2)-2>
	<cfset centerColumn = round(columns/2) -1>
	
	
	<!--- Root object ---->
	
	<cfset row = centerRow>
	<cfset col = centerColumn>
										
	<cfset url.elementId = attributes.content[1].elementId>
	
	<script>   
		      
			ColdFusion.navigate('#SESSION.root#/Tools/ActiveSheet/ActiveSheetCell.cfm?module=#attributes.module#&box=#centerRow#_#centerColumn#&elementid=#elementid#&level=0','cell_#centerRow#_#centerColumn#')
			se = document.getElementById('cell_#centerRow#_#centerColumn#')					
			se.className = "cellstandard"		
			
	</script>
	
	<!--- Related objects --->
	
	<cfset levels = 2>  <!--- Temporary hardcoded variable. Specifies how many levels of relation will be shown --->
	
	<cfset dr = "">
	
	<cfloop index="lvl" from="1" to="#levels#">
	
		<!--- From the query results, I get the elements of a given level --->
		<cfset tempArray = getArrayOfLevel(attributes.content, lvl)> 
		
		<cfset numberOfElements = ArrayLen(tempArray)>
		
		<cfif numberOfElements gt 0 >
		
			<cfset radius = 7 + round(7*(lvl-1))> 
			
			<cfset anglePortion = 2*Pi()/( numberOfElements ) >  
			
			<cfloop index="itm" from="1" to="#numberOfElements#">
				
				<cfset points = getCoordinates(itm,anglePortion,radius)>
				
				<cfset row = points.r>
				<cfset col = points.c>
												
				<cfset elementId = tempArray[itm].elementId>
							
				<cfif dr eq "">
					<cfset dr = "'cell_#row#_#col#'+TRANSPARENT">
				<cfelse>
				    <cfset dr = "#dr#,'cell_#row#_#col#'+TRANSPARENT">
				</cfif>	
			
				<script>   
				        
						ColdFusion.navigate('#SESSION.root#/Tools/ActiveSheet/ActiveSheetCell.cfm?module=#attributes.module#&box=#row#_#col#&elementid=#elementid#&level=#lvl#','cell_#row#_#col#')
						document.getElementById('cell_#row#_#col#').className = "cellstandard"
						
				</script>
			
			</cfloop>	
			
		</cfif>
	
	</cfloop>
	
    <cfset dr = replace(dr,"'",'"',"ALL")>
		
	<script type="text/javascript">
			SET_DHTMLS(SCROLL, #replace(dr,"'",'"',"ALL")#);
	</script> 	
		
	
</cfoutput>