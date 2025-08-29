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
<cfif group1 eq "">

	<cfset grp1Nme = "">
	<cfset grp1Hdr = "">
	<cfset grp1Ser = "">
	<cfset grp1Ord = "">
	<cfset grp1Rec = "">
	<cfset grp1Wid = "">

</cfif>

<cfif group2 eq "">

	<cfset grp2Nme = "">
	<cfset grp2Hdr = "">
	<cfset grp2Ser = "">
	<cfset grp2Ord = "">
	<cfset grp2Rec = "">
	<cfset grp2Wid = "">
	
</cfif>

<cfif group3 eq "">

	<cfset grp3Nme = "">
	<cfset grp3Hdr = "">
	<cfset grp3Ser = "">
	<cfset grp3Ord = "">
	<cfset grp3Rec = "">
	<cfset grp3Wid = "">

</cfif>

<!---
<cfif group4 eq "">

	<cfset grp4Nme = "">
	<cfset grp4Hdr = "">
	<cfset grp4Ser = "">
	<cfset grp4Ord = "">
	<cfset grp4Rec = "">
	<cfset grp4Wid = "">

</cfif>
--->

<!--- prepare the output data --->

<cfset hasData = "1">

<cfif xyshow eq "yes">

	<!--- we precheck if the value exists if not we bypass the rest of the queries --->
	
	<cfquery name="Check"
		datasource="#Alias#"		 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM    #SESSION.acc#_#fileNo#_#node#_CrossTabData
		
		<!--- level 1 --->
			
		<cfif mode eq "1" and xyshow eq "yes">
			WHERE Grouping1    = '#group1#'  
		</cfif>
					
		<!--- level 2 --->
			
		<cfif mode eq "2">
				WHERE Grouping1    = '#group1#'
				AND   Grouping2    = '#group2#'
		</cfif>
			
		<!--- level 3 --->
			
		<cfif mode eq "3">
				WHERE Grouping1    = '#group1#'
				AND   Grouping2    = '#group2#'
				AND   Grouping3    = '#group3#'
		</cfif>
				
	</cfquery>
	
	<cfif check.recordcount eq "0">		
		<cfset hasData = "0">	
	</cfif>

</cfif>

<cfif hasData eq "1">
	
	<cfquery name="CrossTabData"
		datasource="#Alias#"		 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM #SESSION.acc#_#fileNo#_#node#_CrossTabData
						
				<!--- level 1 --->
				
					<cfif mode eq "1" and xyshow eq "yes">
						WHERE Grouping1    = '#group1#'  
					</cfif>
				
				<!--- end --->
			
				<!--- level 2 --->
				
					<cfif mode eq "2" and xyshow eq "yes">
						WHERE Grouping1    = '#group1#'
						AND   Grouping2    = '#group2#'
					</cfif>
					
					<cfif mode eq "2" and xyshow eq "no" and group1 neq "">
						WHERE Grouping1    = '#group1#'
					</cfif>
				
				<!--- end --->
			
				<!--- level 3 --->
				
					<cfif mode eq "3" and xyshow eq "yes">
						WHERE Grouping1    = '#group1#'
						AND   Grouping2    = '#group2#'
						AND   Grouping3    = '#group3#'
					</cfif>
													
					<cfif mode eq "3" and xyshow eq "no" and group1 neq "" and group2 neq "">
						WHERE Grouping1    = '#group1#'
						AND   Grouping2    = '#group2#'
					</cfif>
					
					<cfif mode eq "3" and xyshow eq "no" and group1 neq "" and group2 eq "">
						WHERE Grouping1    = '#group1#' 
					</cfif>
									
				<!--- end --->
				
			ORDER BY Xax
	</cfquery>
					
	<!--- option to hide X-ax will not look nice, Y-ax is fine --->
		
	<cfsetting enablecfoutputonly="YES">	
	
	    <cfif mode lte "2">
	
			<!--- group line --->
			<cfset box    = "#node#_#Grp1ord#_#Grp2ord#">
			<cfset groupbox1 = "#Grp1ord#">
			<cfset groupbox2 = "#Grp1ord#_#Grp2ord#">		
			<cfset group  = groupbox2>
		
		<cfelseif mode eq "3">
		
			<!--- group line --->
			
			<cfset box    = "#node#_#Grp1ord#_#Grp2ord#_#Grp3ord#">
			<cfset groupbox1 = "#Grp1ord#">
			<cfset groupbox2 = "#Grp1ord#_#Grp2ord#">
			<cfset groupbox3 = "#Grp1ord#_#Grp2ord#_#Grp3ord#">
			<cfset group  = groupbox3>
			
		<cfelseif mode eq "4">	
		
			<!--- future provision --->
				
		</cfif>	
				
		<cfset color        = "f1f1f1"> 
		
		<cfinclude template = "CrossTab_Total.cfm">

		<cfif XYShow eq "Yes">
			<cfset color        = "ffffff"> 		
						
			<cfif celloutput.recordcount gte "1">
				<cfinclude template = "CrossTab_Row.cfm">				
			<cfelse>
				<!--- prevent to run query --->	
			</cfif>		
			
		</cfif>
	
</cfif>	
		
<cfsetting enablecfoutputonly="NO">		



	