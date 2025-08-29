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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = #dateValue#>

<cfset dateValue = "">
<cfif #Form.DateExpiration# neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = #dateValue#>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfif Len(#Form.Remarks#) gt 80>
  <cfset remarks = left(#Form.Remarks#,80)>
<cfelse>
  <cfset remarks = #Form.Remarks#>
</cfif>  

<cfparam name="form.stocklocation" default="0">

<!--- Remove quotes from Organization Name (can affect tree view)--->
<cfset LocName=Replace(Form.LocationName,'"','','ALL')>
<cfset LocName=Replace(LocName,"'","",'ALL')>

<cfquery name="Verify" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT LocationCode
	FROM   Location
	WHERE  Mission = '#FORM.Mission#'
	AND    (LocationCode = '#FORM.LocationCode#' OR LocationName = '#locname#')
</cfquery>

<!--- now the updating starts --->

<cf_tl id = "The location code or name is already in use for this entity!. Operation not allowed." class="message" var = "vAlready">

<cfif Verify.RecordCount gt 0>

	 <cf_message message = "#vAlready#" return = "back">
	  <cfabort>

<cfelse>

		<cfswitch expression="#Form.Level#">
		
			<cfcase value="Root">
			   <cfset Parent = "NULL">
			</cfcase>
			<cfcase value="Same">
			   <cfif FORM.ParentParentLocation eq "">
			       <cfset Parent = "NULL">
			   <cfelse>
			       <cfset Parent = "'#FORM.ParentParentLocation#'">
			   </cfif>
			</cfcase>
			<cfcase value="Child">
			   <cfif FORM.ParentLocation eq "">
			       <cfset Parent = "NULL">
			   <cfelse>
			       <cfset Parent = "'#FORM.ParentLocation#'">
			   </cfif>
			</cfcase>
				
		</cfswitch>	
		
		<cfif Form.OrgUnit neq "">
		
			<cfquery name="Org" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT MissionOrgUnitId
				FROM   Organization
				WHERE  OrgUnit = '#FORM.OrgUnit#'
			</cfquery>
		
		</cfif>
				
		<cfquery name="InsertLocation" 
		     datasource="appsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Location
			         (Location,
					  Mission,
					  LocationCode,
					  TreeOrder,
					  LocationName,
					  LocationClass,
					  ParentLocation,
					  Country, 
					  AddressCity,
					  Address,
					  Latitude, 
					  Longitude,				  
					  DateEffective,
					  DateExpiration,
					  PersonNo,
					  <cfif #Form.OrgUnit# neq "">
						  MissionOrgUnitId,
					  </cfif>
					  StockLocation,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,	
					  Remarks)
		      VALUES 
				     ('#Form.Location#',
				      '#Form.Mission#',
			          '#Form.LocationCode#',
					  '#Form.TreeOrder#',
					  '#LocName#',
					  '#Form.LocationClass#',
					  #PreserveSingleQuotes(Parent)#,
					  '#Form.Country#', 
					  '#Form.AddressCity#',
					  '#Form.Address#',
					  '#Form.cLatitude#', 
					  '#Form.cLongitude#',
					  #STR#,
					  #END#,
					  '#Form.PersonNo#',
					  <cfif #Form.OrgUnit# neq "">
						  '#Org.MissionOrgUnitId#',
					  </cfif>
					  '#Form.StockLocation#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  '#Form.Remarks#')
		</cfquery>
					   
	<cfswitch expression="#Form.Level#">
	
		<cfcase value="Root">
		     <cfset link = "LocationListing.cfm?ID1=#Form.Location#&ID2=#Form.Mission#">
		</cfcase>
		
		<cfcase value="Same">
		    <cfset link = "LocationListing.cfm?ID1=#Form.Location#&ID2=#Form.Mission#">
		</cfcase>
		
		<cfcase value="Child">
		    <cfset Parent = "#FORM.MasterLocation#">
		    <cfset link = "LocationListing.cfm?ID1=#Parent#&ID2=#Form.Mission#">
		</cfcase>
	
	</cfswitch>
	
	<cfoutput>
        <script language="JavaScript">
	    	parent.ptoken.navigate('LocationTree.cfm?id2=#Form.mission#','tree')
			ptoken.location('#link#')
	    </script>	
	</cfoutput> 
				
</cfif>