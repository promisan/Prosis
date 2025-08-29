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
<cfquery name="qEvents" 
    datasource="AppsMaterials"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  EC.EventCode, AE.Description 
	FROM    Ref_AssetEventCategory EC INNER JOIN Ref_AssetEvent AE ON EC.EventCode = AE.Code
	WHERE   EC.Category = '#URL.Category#' AND EC.ModeIssuance = '0' 	
</cfquery>

<CF_DateConvert Value="#URL.adate#">
<cfset tDate = dateValue>	

<cfloop query="qEvents">

	<cfset hour         = Evaluate("FORM.#qEvents.EventCode#_hour")>
	<cfset minute       = Evaluate("FORM.#qEvents.EventCode#_minute")>
	<cfset EventDetails = Evaluate("FORM.#qEvents.EventCode#_details")>
	
    <cfset vDate = DateAdd("h", hour, tDate)>		
    <cfset vDate = DateAdd("n", minute, vDate)>
	
	<cfif EventDetails neq "" and vDate neq "">
		<cfquery name = "qInsertMetric" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 DELETE AssetItemEvent
			 WHERE  AssetId          = '#URL.aid#'
			 AND    EventCode        = '#qEvents.EventCode#'
			 AND    DateTimePlanning = #vDate#
		 </cfquery>	
		
		<cfquery name = "qInsertMetric" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			INSERT INTO AssetItemEvent
		    	 ( AssetId, 
				   EventCode, 
				   DateTimePlanning, 
				   EventDetails, 
				   TransactionId, 
				   ActionStatus, 
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName)
			VALUES ('#URL.aid#',
			       '#qEvents.EventCode#',
				   #vDate#,
				   '#EventDetails#',
				   NULL,
				   '1',
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#')
		</cfquery>		
	</cfif>	
	


	
</cfloop>	