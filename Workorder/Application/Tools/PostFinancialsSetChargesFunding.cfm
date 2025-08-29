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
<!--- The purpose of this tool is to define the funding of the charges based on the settings
if the posting mode is defined as "Funding". The system tries to assign the
funding as good as possible based on the effective date for the funding in a top down fashion --->

<!--- 2012-01-27 JDiaz. Provision to avoid overlaping effective periods in fundings at the billing level --->

<cfquery name = "OverlapingFunding"
  datasource  = "NovaWorkOrder"
  username    = "#SESSION.login#"
  password    = "#SESSION.dbpw#"
  timeout="#scripttimeout#">	
  
	UPDATE F
		SET F.DateExpiration = 
				(
				SELECT Dateadd(day,-1,F2.DateEffective)
				FROM   WorkorderFunding F2
				WHERE  F2.WorkOrderId      = F.WorkOrderId
				AND    F2.WorkORderLine    = F.WorkOrderLine
				AND    F2.FundingDetailId <> F.FundingDetailId
				AND    F2.DateEffective   > F.DateEffective
				AND    (F2.DateExpiration <= F.DateExpiration or F.DateExpiration IS NULL)
				AND    F2.Operational     = 1)
	
	FROM   WorkOrderFunding F
	WHERE  Operational = 1
	AND    BillingEffective is not null
	AND    EXISTS (
		SELECT *
		FROM skWorkOrderCharges C
		WHERE  C.WorkOrderId = F.WorkOrderId
		AND C.WorkOrderLine = F.WorkOrderLine)
	AND EXISTS (
		SELECT *
		FROM workorderFunding F1
		WHERE F1.WorkOrderId   = F.WorkOrderId
		AND F1.WorkORderLine   = F.WorkOrderLine
		AND F1.FundingDetailId <> F.FundingDetailId
		AND F1.DateEffective > F.DateEffective
		AND (F1.DateExpiration <= F.DateExpiration or F.DateExpiration IS NULL)
		AND F1.Operational = 1)
  
</cfquery>
<!--- end provision for overlaping funding effective periods --->


<!--- A. first we define the global level for the workorder in which we look at the funding on workorder level : UNIT is ANY only --->
<cfquery name = "Global"
  datasource  = "NovaWorkOrder"
  username    = "#SESSION.login#"
  password    = "#SESSION.dbpw#"
  timeout="#scripttimeout#">	
			UPDATE    skWorkOrderCharges
			SET       FundingId = F.FundingId
			FROM      WorkOrderFunding AS F INNER JOIN
			          skWorkOrderCharges AS C ON F.WorkOrderId = C.WorkOrderId
			WHERE     F.ServiceItemUnit IS NULL  <!--- unit global --->		  
			AND       F.WorkOrderLine   IS NULL  <!--- billing line --->	
			AND       F.BillingDetailId IS NULL  <!--- detail unit --->	 
			<!--- define only matching funding period --->    			
			AND       C.ServiceItem   = '#ProcessService#'
			<!--- ignore cancelled records --->
			AND       F.Operational   = 1			
			AND       C.SelectionDate >= F.DateEffective
			AND       (
			          C.SelectionDate <= F.DateExpiration or F.DateExpiration is NULL
					  )  
</cfquery>		

<!--- B. additional granularly define it on the workorder / UNIT level : this is the definition in the main screen to select a unit in addition --->

<cfquery name  = "GlobalUnit"
  datasource  = "NovaWorkOrder"
  username    = "#SESSION.login#"
  password    = "#SESSION.dbpw#"
  timeout     = "#scripttimeout#">	
	UPDATE    skWorkOrderCharges
	SET       FundingId = F.FundingId
	FROM      WorkOrderFunding AS F INNER JOIN
	          skWorkOrderCharges AS C ON F.WorkOrderId = C.WorkOrderId
			  AND F.ServiceItemUnit = C.ServiceItemUnit
	WHERE     F.WorkOrderLine IS NULL    <!--- billing line --->	
	AND       F.BillingDetailId IS NULL <!--- detail unit --->
	<!--- define only matching funding period --->    
	
	AND       C.ServiceItem = '#ProcessService#'
	<!--- ignore cancelled records --->
	AND       F.Operational = 1
	
	AND       C.SelectionDate >= F.DateEffective
	AND       (C.SelectionDate <= F.DateExpiration or F.DateExpiration is NULL)  
</cfquery>		

<!--- C. then we define an overrule by the billing level for a workorder line 
BUT ONLY IF of this is NOT an SLA enabled workorder  --->

<cfquery name = "BillingPerLine"
  datasource  = "NovaWorkOrder"
  username    = "#SESSION.login#"
  password    = "#SESSION.dbpw#"
  timeout="#scripttimeout#">	
		UPDATE    skWorkOrderCharges
		SET       FundingId = F.FundingId
		FROM      WorkOrderFunding AS F INNER JOIN
		          skWorkOrderCharges AS C ON F.WorkOrderId = C.WorkOrderId 
				                         AND F.WorkorderLine = C.WorkorderLine
		
		
		<!--- no SL defined --->
		
		AND       F.Operational = 1
		
		AND       C.WorkorderId NOT IN (
		
						SELECT   TOP 1 WorkOrderId
						FROM     WorkOrderBaseLine
						WHERE    ActionStatus = '3'
						AND      WorkOrderId = C.WorkOrderId 
						AND      DateEffective >= '#Param.DatePostingStart#'					
						ORDER BY DateEffective DESC
					
				  )
		  
		AND       F.BillingDetailId IS NULL  
		AND       F.ServiceItemUnit IS NULL <!--- this means that it is defined on the level --->
		AND       C.ServiceItem = '#ProcessService#'
	
		<!--- define only matching funding period --->
		
		<!--- ------------------------------------------------------------------------------------------------------------------------------- --->
		<!--- 26/01/2012  HANNO we need to do a better job to take ONLY the most recent funding record here as these may have several results --->
		<!--- ------------------------------------------------------------------------------------------------------------------------------- --->
				    
		AND       C.SelectionDate >= F.DateEffective		
		AND       (C.SelectionDate <= F.DateExpiration or F.DateExpiration is NULL)  
		
</cfquery>		


<!---------------JDiaz 2011-11-15 Provision for expired fundings : NO LONGER NEEDED I BELIEVE ------------->

		<cfquery name    = "BillingPerLine"
		  datasource = "NovaWorkOrder"
		  username   = "#SESSION.login#"
		  password   = "#SESSION.dbpw#"
		  timeout="#scripttimeout#">	
			UPDATE    skWorkOrderCharges
			SET       FundingId = F.FundingId
			FROM      WorkOrderFunding AS F INNER JOIN
			          skWorkOrderCharges AS C ON F.WorkOrderId = C.WorkOrderId 
					                         AND F.WorkorderLine = C.WorkorderLine
					  			 
			WHERE     C.SelectionDate >= (
			
			                              SELECT TOP 1 BillingEffective 
			                              FROM   WorkorderLineBilling
										  WHERE  WorkOrderid    = F.WorkorderId
										  AND    WorkOrderLine  = F.WorkorderLine								
										  AND    BillingExpiration is not NULL 
										  and    BillingExpiration >= C.SelectionDate 
										  ORDER BY BillingEffective  desc
										 )         
			
			<!--- no SL defined --->
			
			AND       F.Operational = 1
			
			AND       C.WorkorderId NOT IN (
			
							SELECT   TOP 1 WorkOrderId
							FROM     WorkOrderBaseLine
							WHERE    ActionStatus = '3'
							AND      WorkOrderId = C.WorkOrderId 
							AND      DateEffective >= '#Param.DatePostingStart#'					
							ORDER BY DateEffective DESC
						
					  )
			  
			AND       F.BillingDetailId IS NULL 
			AND       F.ServiceItemUnit IS NULL <!--- detail unit --->
			<!--- define only matching funding period --->    
			AND       C.SelectionDate >= F.DateEffective
			AND       C.ServiceItem = '#ProcessService#'
			AND       (C.SelectionDate <= F.DateExpiration or F.DateExpiration is NULL)  
			AND		  C.fundingId IS NULL
		</cfquery>		

<!---------------END JDiaz Provision for expired fundings ------------->



<!--- ------------------------------------------------------ --->
<!--- as we define the overrule by the billing && unit level --->
<!--- ------------------------------------------------------ --->

<cfquery name    = "BillingPerLineUnit"
   datasource = "NovaWorkOrder"
   username   = "#SESSION.login#"
   password   = "#SESSION.dbpw#"
   timeout="#scripttimeout#">	
	UPDATE    skWorkOrderCharges
	SET       FundingId = F.FundingId
	FROM      WorkOrderFunding AS F INNER JOIN
	          skWorkOrderCharges AS C ON F.WorkOrderId     = C.WorkOrderId 
									<!--- AND F.WorkOrderLine   = C.WorkOrderLine--->  <!--- added --->
			                         AND F.ServiceitemUnit = C.ServiceItemUnit
			  			 
	WHERE     F.BillingDetailId IN 
	
         	  <!--- 			
			     Monthly charges are funded based on the association of the funding to
				 a workorder billing line which applies to that month for the workorderline and unit				  
				 26/01/2012 it is important that each billing line has the correct funding associated				  
			  --->			 		
			  
                (
                  SELECT BillingDetailId
                  FROM   WorkorderLineBillingDetail
				  WHERE  WorkOrderid       = F.WorkorderId
				  AND    WorkOrderLine     = C.WorkorderLine		
				  AND    BillingEffective <= C.SelectionDate
				  AND    ServiceitemUnit   = F.ServiceItemUnit																		  
				) 						 			 	
	
	AND       F.Operational = 1
	
	<!--- but no SL defined --->
	
	AND       C.WorkorderId NOT IN (
	
					SELECT   TOP 1 WorkOrderId
					FROM     WorkOrderBaseLine
					WHERE    ActionStatus = '3'
					AND      WorkOrderId = C.WorkOrderId 
					AND      DateEffective >= '#Param.DatePostingStart#'					
					ORDER BY DateEffective DESC
									
			  )
			
	AND       C.ServiceItem = '#ProcessService#'
	
	<!--- define only matching funding period --->    
	AND       C.SelectionDate >= F.DateEffective
	AND       (C.SelectionDate <= F.DateExpiration OR F.DateExpiration is NULL)  						       	  
	
</cfquery>	

	
<!--- ---------------------- --->
<!--- now set the GL account --->
<!--- ---------------------- --->

<cfquery name  = "DefineGLAccount"
  datasource   = "NovaWorkOrder"
  username     = "#SESSION.login#"
  password     = "#SESSION.dbpw#"
  timeout="#scripttimeout#">	
	UPDATE   skWorkOrderCharges
	SET      GLAccount = R.GLAccount
	FROM     skWorkOrderCharges S, Ref_Funding R
	WHERE    S.FundingId = R.FundingId
	AND      S.ServiceItem = '#ProcessService#'
	<!--- only for valid [result] accounts --->
	AND      R.GLAccount IN (SELECT GLAccount 
	                         FROM   Accounting.dbo.Ref_Account 
							 WHERE  GLAccount    = R.GLAccount
							 AND    AccountClass = 'Result')
</cfquery>		

