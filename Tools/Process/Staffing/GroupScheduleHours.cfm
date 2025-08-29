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
<cfparam name="attributes.dataSource" 		default="AppsEmployee">
<cfparam name="attributes.scheduleQuery" 	default="">
<cfparam name="attributes.hourField"		default="">
<cfparam name="attributes.memoField"		default="">
<cfparam name="attributes.hourMode"			default="60">

<cfquery name="qScheduleHours" 
	datasource="#attributes.dataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    #preserveSingleQuotes(attributes.scheduleQuery)#
</cfquery>
	
<cfset hours       = "">
<cfset currentHour = "">
<cfset nextHour    = 0>

<cfset vMemoText = "">

<cfloop query="qScheduleHours">

	<cfif Evaluate(attributes.HourField) eq -1>
	
		<cfset vMemoText = ": " & Evaluate('#attributes.memoField#')>
		<cf_tl id="Anytime" var="1">
		<cfset hours = lt_text & vMemoText>
	
	<cfelse>
	
		<cf_ConvertDecimalToHour DecimalHour = "#Evaluate('#attributes.HourField#')#">
		<cfset currentHour = StringHour>
		
		<cfif currentrow eq 1>
			<cfset hours = hours & currentHour>
		</cfif>
		
		<cfif currentrow gt 1>
		
			<cfset hrval = "#Evaluate(attributes.HourField)#">
			<cfset hrval = round(hrval*100)>
			<cfset nhval = round(nexthour*100)>
			
			<cfif hrval neq nhval>					
								
				<cf_ConvertDecimalToHour DecimalHour = "#nextHour#">
				
				<cfif findNoCase(StringHour, hours)>					
					<cfset hours = hours & vMemoText & "<br>" & currentHour>
				<cfelse>				
					<cfset hours = hours & " - " & StringHour & vMemoText & "<br>" & currentHour>
				</cfif>
								
			</cfif>
		
		</cfif>
		
		<cfset nextHour = Evaluate(attributes.HourField) + (attributes.HourMode / 60)>
				
		<cfset vMemoText = "">
		<cfif trim(Evaluate(attributes.memoField)) neq "">
			<cfset vMemoText = ": " & Evaluate(attributes.memoField)>
		</cfif>
		
		<!--- last record --->
		
		<cfif currentRow eq recordCount>
			
			<cf_ConvertDecimalToHour DecimalHour = "#nextHour#">	
			
			<cfif NOT findNoCase(StringHour, hours)>
				<cfset hours = hours & " - " & StringHour & vMemoText>
			</cfif>
					
		</cfif>
	
	</cfif>
	
</cfloop>

<cfoutput>			
	#hours#	
</cfoutput>