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

<cfparam name="attributes.PurchaseNo" default="">
<cfparam name="attributes.Mode"       default="Both">

<cfquery name="get" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Purchase 
	  WHERE  PurchaseNo = '#attributes.purchaseno#'
</cfquery>

<cfquery name="parameter" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_ParameterMission 
	  WHERE  mission = '#get.Mission#'
</cfquery>

<cfif parameter.PurchaseCustomField neq "">

	<cfset alternate = evaluate("get.UserDefined#parameter.PurchaseCustomField#")>
	
<cfelse>

	<cfset alternate = "">

</cfif>	

<cfif attributes.mode eq "Both">

	<cfoutput>
		#attributes.purchaseno# <cfif alternate neq ""> / #alternate# </cfif>
	</cfoutput>

<cfelseif attributes.mode eq "Only" and alternate neq "">

	<cfoutput>
		#alternate# 
	</cfoutput>
	
	<cfset caller.fResultPurchaseNo = alternate>

<cfelse>

	<cfoutput>
		#attributes.purchaseno#
	</cfoutput>
	
	<cfset caller.fResultPurchaseNo = attributes.purchaseno>
			
</cfif>




