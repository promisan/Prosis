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

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Select">
		
	<cffunction name="DropdownSelect"
             access="remote"
             returntype="array"
             displayname="DropdownSelect"
			 secureJSON = "yes" verifyClient = "yes">
		
		    <cfargument name="DataSource"    type="string" required="true">
			<cfargument name="Table"         type="string" required="true">
			<cfargument name="FieldKey"      type="string" required="true">
			<cfargument name="FieldName"     type="string" required="true">
			<cfargument name="Filter1Field"  type="string" required="true">
			<cfargument name="Filter1Value"  type="string" required="true">
			<cfargument name="Filter2Field"  type="string" required="true">
			<cfargument name="Filter2Value"  type="string" required="true">
			<cfargument name="Selected"      type="string" required="true">
					
						
			 <!--- Get data --->
		      <cfquery name="Values" datasource="#DataSource#">
			      SELECT #FieldKey# as PK, #FieldName# as Name   
			      FROM #Table#
				  WHERE #Filter1Field# = '#Filter1Value#'	
				 
				 
				  <cfif Filter2Field neq "">	
				  		  
					  <cfif Filter2Field neq "ParentOrgUnit">
					  	  AND #Filter2Field# = '#Filter2Value#'	
					  <cfelse>
					      AND ParentOrgUnit IN (SELECT OrgUnitCode 
						                        FROM Organization.dbo.Organization 
												WHERE OrgUnit = '#Filter2Value#')	  
					  </cfif>	
				  
				  </cfif>	
				 
				  
				  AND #FieldKey# != '#selected#'			
			  </cfquery>
			  
			  <cfset s = 0>
			  <cfset list = arraynew(2)>
							  
			  <cfif selected eq "" and values.recordcount gte "2">
					  
					  <cfset list[1][1]= "">
		       	      <cfset list[1][2]= "[Select]">
					  
					  <cfset s = s+1>		
				  
			  </cfif>	  			  
			  
			  <cfif selected neq "">
			  
			   <cfquery name="Select" datasource="#DataSource#">
			      SELECT #FieldKey# as PK, #FieldName# as Name
			      FROM #Table#
				  WHERE #FieldKey# = '#selected#'				
			  </cfquery>
			  
			    <cfif select.recordcount eq "1">
				
			    	<cfset list[1][1]= Select.PK[1]>
		            <cfset list[1][2]= Select.Name[1]>
					
					<cfset s = s+1>					

				</cfif>
			  
			  </cfif>
			  
			<!--- Convert results to array --->
	      	<cfloop index="i" from="1" to="#Values.RecordCount#">
			   	 <cfset list[i+s][1]= Values.PK[i]>
	        	 <cfset list[i+s][2]= Values.Name[i]>
	      	</cfloop>
		
		<cfreturn list>
		
	</cffunction>
	
	
</cfcomponent>	