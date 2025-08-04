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
<cfparam name="URL.row"         default="">
<cfparam name="URL.ProgramCode" default="">
<cfparam name="URL.ItemMaster"  default="">
<cfparam name="URL.Overwrite"   default="0">
<cfparam name="URL.TopicValueCode"  default="">
<cfparam name="URL.Location"        default="">

<!--- use the above to acquire the price from the table Purchase.dbo.ItemMasterStandardCost which are then to be modified below --->

<cfquery name="GetProgram" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Program
	WHERE  ProgramCode = '#URL.ProgramCode#'
</cfquery>

<cfquery name="GetPeriod" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Period
	WHERE  Period = '#URL.Period#'
</cfquery>

<cfquery name="GetItemMaster" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   ItemMaster
	WHERE  Code = '#URL.ItemMaster#'
</cfquery>

<cfquery name="Object" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   ItemMasterObject
	WHERE  ItemMaster = '#URL.ItemMaster#'
	AND    ObjectCode = '#url.ObjectCode#'
</cfquery>

<cfquery name="GetItemMasterList" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   ItemMasterList
	WHERE  TopicValueCode = '#URL.TopicValueCode#'
	AND    ItemMaster     = '#URL.ItemMaster#'
</cfquery>

<cfset NewRequest = FALSE>

<cfif URL.requirementId eq "">

	<cfset NewRequest = TRUE>
	
<cfelse>

	<cfquery name="Get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT P.CostOrder,
		       P.CostElement, 
		       P.Calculation as CostBudgetMode, 
			   P.CostElementAmount as CostAmount
		FROM   ProgramAllotmentRequestPrice P INNER JOIN ProgramAllotmentRequest R
			ON P.RequirementId = R.RequirementId
		WHERE  R.RequirementId  = '#URL.requirementid#'
		AND    R.ItemMaster	    = '#URL.ItemMaster#' 
		AND    R.TopicValueCode = '#URL.TopicValueCode#'
		ORDER BY P.CostOrder
	</cfquery>
	
	<cfif Get.recordcount eq 0>
	
			<cfquery name="Get" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT '1' as CostOrder,
				       'Quantity' as CostElement, 
				       '2' as CostBudgetMode, 
					   RequestPrice as CostAmount
				FROM   ProgramAllotmentRequest
				WHERE  RequirementId  = '#URL.requirementid#'
			</cfquery>	
			
			<cfif Get.recordcount eq 0>
				<cfset NewRequest = TRUE>
			</cfif>	
	</cfif>	

</cfif>

<cfif NewRequest>

	<cfquery name="Get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT IC.* 
	
	FROM   ItemMasterStandardCost IC INNER JOIN ItemMasterList L ON 
		   IC.TopicValueCode = L.TopicValueCode AND IC.ItemMaster = L.ItemMaster
		   
	WHERE  IC.ItemMaster		= '#URL.ItemMaster#' AND
		   IC.TopicValueCode	= '#URL.TopicValueCode#' AND 
		   IC.Mission			= '#GetProgram.Mission#' AND

		   DateEffective 		=
				( SELECT  TOP 1 DateEffective
					FROM  ItemMasterStandardCost
					WHERE ItemMaster		= '#URL.ItemMaster#' 
					AND	  TopicValueCode	= '#URL.TopicValueCode#' 					
					AND   Mission			= '#GetProgram.Mission#' 
					<cfif url.location neq "">
					AND    Location         = '#URL.Location#'
					</cfif>
					AND   CostElement       = IC.CostElement 
					AND   DateEffective    <= '#getPeriod.DateEffective#'
				  ORDER BY DateEffective DESC	
				)

			<cfif url.location neq "">
			AND Location	= '#url.Location#'	
			<cfelse>
			AND Location = ''
			</cfif>
			
	ORDER BY  IC.CostOrder
	</cfquery>

	<cfif get.recordCount eq 0>
	
		<cfquery name="Get" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT IC.* 
			
			FROM   ItemMasterStandardCost IC INNER JOIN ItemMasterList L ON 
				   IC.TopicValueCode = L.TopicValueCode AND IC.ItemMaster = L.ItemMaster
				   
			WHERE  IC.ItemMaster		= '#URL.ItemMaster#' AND
				   IC.TopicValueCode	= '#URL.TopicValueCode#' AND 
				   IC.Mission			= '#GetProgram.Mission#' AND
		
				   DateEffective 		=
						( SELECT   TOP 1 DateEffective
						  FROM     ItemMasterStandardCost
						  WHERE    ItemMaster		= '#URL.ItemMaster#' 
						  AND	   TopicValueCode	= '#URL.TopicValueCode#' 					
						  AND      Mission			= '#GetProgram.Mission#' 
						  AND      Location          = ''
						  AND      CostElement       = IC.CostElement 
						  AND      DateEffective    <= '#getPeriod.DateEffective#'
						  ORDER BY DateEffective DESC	
						)
		
					AND Location = ''
					
			ORDER BY  IC.CostOrder
			
		</cfquery>
	
	</cfif>

</cfif>	

<table width="100%" class="formpadding">

<cfoutput>

<cfset vCostList = "">

<cfloop query = "Get">

	<cfset nid = Replace(CostElement,' ','_','all')>
	
	<tr>
		<td width="15%"></td>
		<td width="50%" align="right" class="labelit">
			<input type="hidden" id="CostElement_#URL.ROW#" name="CostElement_#URL.ROW#" value="#nid#_#URL.ROW#">
			#CostElement#:
			<cfif vCostList eq "">
				<cfset vCostList = "#nid#_#URL.ROW#">
			<cfelse>
				<cfset vCostList = vCostList & ",#nid#_#URL.ROW#">
			</cfif>
		</td>	
		<td align="right" width="10%" style="padding-left:8px">
				
			<input class   = "regularh enterastab" 
			     onchange  = "parent.getrate('#URL.Row#','#url.programcode#','#url.itemmaster#','#URL.topicvaluecode#','refresh')" 
				 style     = "padding-top:2px;text-align:right;width:100%" type="text" id="#nid#_#URL.ROW#_Number" 
				 name      = "#nid#_#URL.ROW#_Number"  <cfif object.BudgetForceStandardCost eq "1">readonly</cfif>
				 value     = "#Trim(NumberFormat(CostAmount,',.__'))#" 
				 style     = "width:80;text-align:right">
				 
			<cfparam name="v#nid#_#URL.ROW#_Number" default="#NumberFormat(CostAmount,',.__')#">
			
		</td>
		<td align="left" width="5%" class="labelit" style="padding-left:14px">
			
			<input type="hidden" id="#nid#_#URL.ROW#_Mode"  name="#nid#_#URL.ROW#_Mode"  value="#CostBudgetMode#" class="button3">
			<input type="hidden" id="#nid#_#URL.ROW#_Order" name="#nid#_#URL.ROW#_Order" value="#CostOrder#" class="button3">
			
			<cfparam name="v#nid#_#URL.ROW#_Mode" default="#CostBudgetMode#">	
			<cfparam name="v#nid#_#URL.ROW#_MOrder" default="#CostOrder#">		
			
			<cfswitch expression="#CostBudgetMode#">
				<cfcase value="1">%</cfcase>
				<cfcase value="2"></cfcase>
				<cfcase value="3"></cfcase>
			</cfswitch>
		
		</td>
		<td></td>
		
	</tr>
</cfloop>

<cfparam name="vCostElement_#URL.ROW#" default="#vCostList#">

</cfoutput>
</table>

<cfset URL.rid = URL.requirementid>

<cfif url.overwrite eq "0">
	<cfinclude template="RateCalculation.cfm">
</cfif>
