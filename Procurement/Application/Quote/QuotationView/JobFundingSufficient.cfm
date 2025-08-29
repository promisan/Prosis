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
<cfquery name="Job" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   	 SELECT *
     FROM   Job
	 WHERE  JobNo    = '#URL.ID1#'  
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#Job.Mission#' 
</cfquery>

<cfquery name="Requisition" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    sum(RequestAmountBase) as RequestAmount
	FROM      RequisitionLine 
	<!---  WHERE     ActionStatus IN ('2k','3') --->
	WHERE   ActionStatus != '9'	
	AND     ActionStatus != '0z'				
	AND     JobNo    = '#URL.ID1#' 
	<!--- not needed, based on CICIG report 
	AND     Period   = '#URL.Period#'
	--->
</cfquery>
    
<cfquery name="CheckFunding" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   SUM(QuoteAmountBaseCost) AS Total
	FROM     RequisitionLineQuote
	WHERE    JobNo = '#URL.ID1#' 
	AND      Selected = 1
    AND      RequisitionNo IN 	(SELECT RequisitionNo 
				                 FROM   RequisitionLine 
				                 WHERE  ActionStatus != '9'	
				                 AND    ActionStatus != '0z')
  </cfquery>
  
  <cfoutput>
      
  <table width="99%" cellspacing="0" cellpadding="0" align="center">
  
	  <cfif Parameter.PurchaseExceed neq "" and Requisition.RequestAmount neq "">
		  <cfset ceiling = Requisition.RequestAmount +(Requisition.RequestAmount*Parameter.PurchaseExceed)/100>
	  <cfelse>
	      <cfset ceiling = Requisition.RequestAmount>
	  </cfif>	 
	     
	  <cfif Checkfunding.total gt ceiling>
			  
		  <tr class="line"><td class="line labelmedium" style="height:40" colspan="4" align="center" bgcolor="yellow">		  
		  Awarded amount #NumberFormat(Checkfunding.total, "__,__.__")# exceeds pre-encumbered amount. <b>#SESSION.first#</b> you must request additional funding!
		  </td></tr>
		  	   		  
	  </cfif>
  
  </table>
  
  </cfoutput>	