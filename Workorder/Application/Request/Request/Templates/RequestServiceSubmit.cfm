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

<cftransaction>

<!--- --------------------------------------------- --->
<!--- loop through the possible records for regular --->
<!--- --------------------------------------------- --->

<cfparam name="unitlist" default="">

<cfparam name="Form.ServiceitemTo" default="#Form.Serviceitem#">

<cfparam name="ln" default="0">
<cfset cl = "regular">

<cfquery name="Unit" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT   R.*, 
		          M.Currency, 
			      M.Frequency,
				  M.BillingMode,
				  M.StandardCost
	     FROM     ServiceItemUnit R, 
		          ServiceItemUnitMission M
		 WHERE    R.ServiceItem = '#Form.ServiceitemTo#'
		 AND      R.ServiceItem = M.ServiceItem		
		 AND      R.Operational = 1
		  AND     M.BillingMode != 'Supply'			
		 AND      R.Unit = M.ServiceItemUnit
		 AND      (M.Mission is NULL OR Mission = '#url.mission#')	
		 AND      M.DateEffective <= #eff# and M.DateExpiration >= #eff# 
		 AND      (DateExpiration is NULL or DateExpiration >= getDate())				
		 AND      R.UnitClass = '#cl#'
		 ORDER BY R.ListingOrder, 
			      R.UnitDescription							 
</cfquery>

<cfoutput query="Unit">
  
	<cfset id = currentrow>
		
	<cfparam name="Form.#cl#_Unit_#id#"    default="">
	<cfparam name="Form.#cl#_Charged_#id#" default="0">		
	<cfset selected = evaluate("Form.#cl#_Unit_#id#")>
	
	<cfset costid = evaluate("Form.#cl#_CostId_#id#")>
	
	<cfquery name="CostId" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 SELECT  *
			 FROM    ServiceItemUnitMission M
			 <cfif costid neq "">
			 WHERE   CostId = '#costid#'		
			 <cfelse>
			 WHERE   1=0
			 </cfif>
		</cfquery>
		
	<cfif selected neq "">		
				
		<cfset ln = ln+1>	
		<cfinclude template="RequestServiceSubmitUnit.cfm">			
			
	</cfif>
	
</cfoutput>

<!--- ------------------------------------------- --->
<!--- loop through the possible clustered records --->
<!--- ------------------------------------------- --->

<cfquery name="Unit" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT   R.*, 
		          M.Currency, 
				  M.StandardCost, 
				  M.Frequency,
				  M.BillingMode	
	     FROM     ServiceItemUnit R, 
		          ServiceItemUnitMission M
		 WHERE    R.ServiceItem  = '#Form.ServiceitemTo#'
		 AND      R.ServiceItem = M.ServiceItem		
		 AND      R.Operational = 1		 
		  AND    M.BillingMode != 'Supply'	 
		 AND      R.Unit = M.ServiceItemUnit
		 AND      (M.Mission is NULL OR Mission = '#url.mission#')	
		 AND      M.DateEffective <= #eff# and M.DateExpiration >= #eff# 
		 AND      (DateExpiration is NULL or DateExpiration >= getDate())		
		 AND      R.UnitClass != 'Regular'
		 AND     (R.UnitParent is NULL or R.UnitParent NOT IN (SELECT Code FROM Ref_UnitClass))
		 ORDER BY R.UnitClass,
		          R.ListingOrder, 
				  R.UnitDescription				 
</cfquery>

<cfoutput query="Unit" group="UnitClass">

	<cfset cl = unitclass>
	<cfset id = "0">
	
	<cfparam name="Form.#cl#_Unit_#id#" default="">
	<cfparam name="Form.#cl#_Charged_#id#" default="0">		
	<cfset chk = evaluate("Form.#cl#_Unit_#id#")>
		
	<cfif chk neq "">		
	
		<cfset costid = evaluate("Form.#cl#_CostId_#id#")>
						
								
		<cfquery name="CostId" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *
			     FROM    ServiceItemUnitMission M
				 <cfif costid neq "">
				 WHERE   CostId = '#costid#'		
				 <cfelse>
				 WHERE   1=0
				 </cfif>	
		</cfquery>
		
		<cfset selected = costid.serviceitemunit>	
									
		<cfset ln = ln+1>		
		<cfinclude template="RequestServiceSubmitUnit.cfm">
						
		<!--- now also include the features for this class --->
					
		<cfquery name="UnitChild" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT   R.*, 
				          M.Currency, 
					      M.Frequency,
						  M.BillingMode,
						  M.StandardCost
			     FROM     ServiceItemUnit R, 
				          ServiceItemUnitMission M
				 WHERE    R.ServiceItem  = '#form.serviceitemTo#'
				 AND      R.ServiceItem = M.ServiceItem				
				 AND      R.Operational = 1				
				 AND      R.Unit = M.ServiceItemUnit
				 AND      (M.Mission is NULL OR Mission = '#url.mission#')	
				 AND      M.DateEffective <= #eff# and M.DateExpiration >= #eff# 
				 AND      (DateExpiration is NULL or DateExpiration >= getDate())				
				 AND       R.UnitClass = '#cl#'
				 AND       R.UnitParent IN (SELECT Code FROM Ref_UnitClass)
				 ORDER BY  R.ListingOrder, 
					       R.UnitDescription							 
		</cfquery>
		
		<cfloop query="UnitChild">
		   
			<cfset id = currentrow>
				
			<cfparam name="Form.#cl#_Unit_#id#" default="">
			<cfparam name="Form.#cl#_Charged_#id#" default="0">	
				
			<cfset selected = evaluate("Form.#cl#_Unit_#id#")>
				
			<cfif selected neq "">		
						    				
				<cfset ln = ln+1>	
				<cfinclude template="RequestServiceSubmitUnit.cfm">
							
			</cfif>
			
		</cfloop>			
	
	</cfif>
	
</cfoutput>

<!--- check if we select any lines here --->
	
<cfquery name="Check" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    RequestLine
	 WHERE   RequestId = '#url.requestId#'		
</cfquery>
		
<cfif Check.recordcount eq "0">
	
	<cfquery name="Insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
					INSERT INTO RequestLine
					(RequestId,RequestLine,Serviceitem)
			 VALUES
			 ('#url.requestId#','1','#Form.ServiceitemTo#')		
	</cfquery>

</cfif>		

<!--- --------------------- --->
<!--- save also the devices --->
<!--- --------------------- --->

<cfinclude template="RequestDeviceSubmit.cfm">	
	
</cftransaction>

