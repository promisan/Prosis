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
<cfquery name="qEvents" datasource="AppsMaterials">
	SELECT EC.EventCode
	FROM   Ref_AssetEventCategory EC INNER JOIN Ref_AssetEvent AE ON EC.EventCode = AE.Code
	WHERE  EC.ModeIssuance = '1' 
	AND    EC.Category = '#Asset.Category#' 
</cfquery>

<cfset aEvents = ArrayNew(1)>
<cfset i = 0>

<cfloop query="qEvents">
	   
	   <cfset pos_event = ListContains(FORM.assetdetails, "#EventCode#_")>			
	   
	   <cfset vCode    = EventCode>
	   <cfset vDate   = "">
	   <cfset vHour   = "12">
	   <cfset vMinute = "00">
	   <cfset vDetails = "">
	   
	   
	   <cfloop condition="pos_event neq 0">
	   
		   <cfif pos_event neq 0>
		   		<!--- found, thus now, look for the date, hour, minute and details of the event --->
				<cfset element  = listGetAt(FORM.assetdetails, pos_event)>
				<cfif FindNoCase("_date_",element)>
					<cfset vDate    = replace(element ,"#EventCode#_date_","","ALL")>
				</cfif>
				<cfif FindNoCase("_hour_",element)>
					<cfset vHour    = replace(element ,"#EventCode#_hour_","","ALL")>
				</cfif>	
				<cfif FindNoCase("_minute_",element)>				
					<cfset vMinute  = replace(element ,"#EventCode#_minute_","","ALL")>							
				</cfif>
				<cfif FindNoCase("_details_",element)>				
					<cfset vDetails = replace(element ,"#EventCode#_details_","","ALL")>														
				</cfif>	
		   </cfif>
		   
			<cfset FORM.assetdetails = ListDeleteAt(FORM.assetdetails, pos_event)>		
		    <cfset pos_event = ListContains(FORM.assetdetails, "#EventCode#_")>			
							
	   </cfloop>
	   
	   <cfset i = i + 1>
	   
	   <cfif vDate neq "">
	   
			<cf_DateConvert Value="#vDate#">
			<cfset tDate = dateValue>		   
		    <cfset vDate = DateAdd("h", vHour, tDate)>		
		    <cfset vDate = DateAdd("n", vMinute, vDate)>
			
   		</cfif>	
	   
	   <cfset aEvents[i] = "'#vCode#', #vDate#, '#vDetails#'">



	   
</cfloop>

