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
<cfparam name="url.actionid"   default="">
<cfparam name="form.selection">


<cfif form.selection eq "percentage">

	<cfset percentage = replace(form.percentage,',','',"ALL")>

	<cfif not LSIsNumeric(percentage)>
	  <table>
	  <tr><td><font color="FF0000">Incorrect mark down percentage entered : <cfoutput>#percentage#</cfoutput></td></tr>
	  </table>
	  <cfabort>
	</cfif>	
		
	<cfset perc = (100-percentage)/100>
		
	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ProgramAllotmentRequestBatchAction
		SET RevisedPrice      = round(RequestPrice*#perc#,2),
		    RevisedAmountBase = round(RequestAmountBase*#perc#,2)
		WHERE ActionId        = '#url.actionid#'	
	</cfquery>

<cfelseif form.selection eq "amount">

	<cfset amount = replace(form.amount,',','',"ALL")>

	<cfif not LSIsNumeric(amount)>
	  <table>
	  <tr><td><font color="FF0000">Incorrect target amount entered : <cfoutput>#amount#</cfoutput></td></tr>
	  </table>
	  <cfabort>
	</cfif>	

	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ProgramAllotmentRequestBatchAction
		SET    RevisedAmountBase = round(#url.amount#*RequestAmountPercentage,2),
		       Revisedprice      = round(#url.amount#*RequestAmountPercentage/RequestQuantity,2)
		WHERE  ActionId          = '#url.actionid#'		
		AND    RequestQuantity != 0
	</cfquery>
	
<cfelse>

	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset DTE = dateValue>

	<!--- copy over existing values first to make sure if there is no std it will have values ---->
	
	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE       ProgramAllotmentRequestBatchAction
		SET          RevisedAmountBase = RequestAmountBase,
		             Revisedprice      = RequestPrice
		WHERE        ActionId          = '#url.actionid#'		
		AND          RequestQuantity != 0
	</cfquery>	
	
	<cfquery name="UpdateItemMaster" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE      ProgramAllotmentRequestBatchAction
		SET         RevisedAmountBase = B.RequestQuantity * I.CostPrice,
		            Revisedprice      = I.CostPrice		
		FROM        Purchase.dbo.ItemMaster AS I INNER JOIN
                    Program.dbo.ProgramAllotmentRequest AS AR ON I.Code = AR.ItemMaster INNER JOIN
                    Program.dbo.ProgramAllotmentRequestBatchAction B ON AR.RequirementId = B.RequirementId
		WHERE       ActionId       = '#url.actionid#'		
		AND         I.CostPrice > 0	
		AND         B.RequestQuantity != 0
	</cfquery>
	
	
	
	<cfquery name="UpdateItemMasterList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE      ProgramAllotmentRequestBatchAction
		SET         RevisedAmountBase = B.RequestQuantity * I.ListAmount,
		            Revisedprice      = I.ListAmount		
		FROM        Purchase.dbo.ItemMasterList AS I INNER JOIN
                    Program.dbo.ProgramAllotmentRequest AS AR ON I.ItemMaster = AR.ItemMaster AND I.TopicValueCode = AR.TopicValueCode INNER JOIN
                    Program.dbo.ProgramAllotmentRequestBatchAction B ON AR.RequirementId = B.RequirementId
		WHERE       ActionId       = '#url.actionid#'		
		AND         I.ListAmount > 0	
		AND         B.RequestQuantity != 0		
	</cfquery>
	
		
	<cfquery name="UpdateItemMasterElement" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    UPDATE ProgramAllotmentRequestBatchAction
		SET    RevisedAmountBase = STD.CostAmount * BA.RequestQuantity,
		       Revisedprice      = STD.CostAmount
		FROM   ProgramAllotmentRequestBatchAction AS BA INNER JOIN
               ProgramAllotmentRequest AS AR ON BA.RequirementId = AR.RequirementId INNER JOIN
              
			     (SELECT   I.ItemMaster, 
				           I.TopicValueCode, 
						   I.Mission, 
						   I.Location, 
						   I.DateEffective, 
						   I.StandardCost as CostAmount
                  FROM     Purchase.dbo.vwItemMasterStandardCost AS I INNER JOIN
                                (SELECT     ItemMaster, TopicValueCode, Mission, Location, MAX(DateEffective) AS Last
                                 FROM       Purchase.dbo.ItemMasterStandardCost
                                 WHERE      DateEffective <= #dte# 
								 AND        Mission = '#form.mission#'
                                 GROUP BY   ItemMaster, TopicValueCode, Mission, Location) AS B 
								 
				 ON I.ItemMaster          = B.ItemMaster 
				     AND I.TopicValueCode = B.TopicValueCode 
					 AND I.Mission        = B.Mission 
					 AND I.Location       = B.Location 
					 AND I.DateEffective  = B.Last) AS STD ON AR.ItemMaster = STD.ItemMaster AND 
                         AR.TopicValueCode = STD.TopicValueCode AND AR.RequestLocationCode = STD.Location	   
						 
		AND    BA.ActionId          = '#url.actionid#'		
		AND    BA.RequestQuantity != 0
	
	</cfquery>
	

</cfif>  

<cfinclude template="MarkDownRevisedList.cfm">
