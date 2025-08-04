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

<!--- servicelinesbilling submission --->

<cfparam name="FORM.payerid"           default="">
<cfparam name="FORM.orgunit"           default="">
<cfparam name="FORM.ServiceReference"  default="">
<cfparam name="FORM.ReferenceNo"       default="">
<cfparam name="FORM.ApplyAll"          default="0">
<cfparam name="FORM.WorkActionId"      default="">
<cfparam name="Form.DateEffective"     default="#dateformat(now(),client.dateformatshow)#">
<cfparam name="Form.DateExpiration"    default="#dateformat(now(),client.dateformatshow)#">

<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId     = '#url.workorderid#'	
</cfquery>

<cfquery name="Item" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    #CLIENT.lanPrefix#ServiceItem
	 WHERE   Code   = '#workorder.serviceitem#'	
</cfquery>

<cfquery name="Domain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ServiceItemDomain
	 WHERE   Code   = '#item.servicedomain#'	
</cfquery>

<!--- check if record exists --->
<cfquery name="Check" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    WorkOrderLineBilling
	 <cfif url.billingid eq "">
	 WHERE   1=0
	 <cfelse>
	 WHERE   BillingId = '#url.billingid#'			
	 </cfif>
	
</cfquery>

<cfif check.recordcount eq "1">

	<cfif Domain.AllowConcurrent eq "0">

		<CF_DateConvert Value="#dateformat(Check.BillingEffective,CLIENT.DateFormatShow)#">
		<cfset EFF = dateValue>
	
	<cfelse>
	
		<cfset EFF = now()>
		
	</cfif>

<cfelse>

    <cfif Domain.AllowConcurrent eq "0">

		<CF_DateConvert Value="#Form.DateEffective#">
		<cfset EFF = dateValue>
		
	<cfelse>
	
		<cfset EFF = now()>
	
	</cfif>	
	
</cfif>	

<cfif Check.recordcount eq "0">

    <!--- check if record exists --->
	<cfquery name="Check" 
	  datasource="appsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT * 
		FROM   WorkOrderLineBilling
		WHERE  WorkOrderId      = '#url.workorderid#'
		AND    WorkOrderLine    = '#url.workorderline#'
		AND    BillingEffective = #EFF#		
				
	</cfquery>		
	
	<cfif check.recordcount eq "1">
		<cfset url.billingid = check.billingid>
	</cfif>

</cfif>

<cfif form.dateexpiration eq "">
	
	<cfset EXP = "">
	
<cfelse>

	<CF_DateConvert Value="#Form.DateExpiration#">
	<cfset EXP = dateValue>
	
</cfif>	

<cfif Domain.AllowConcurrent eq "1">
		<!---must check for the index (unique) and see if must add the time to the date portion, this would make it unique) --->
		
	<cfquery name="checkIX" 
  		datasource="appsWorkOrder" 
  		username="#SESSION.login#" 
  		password="#SESSION.dbpw#">
			SELECT count(1), WorkORderId, WorkOrderLine, OrgUnit, BillingExpiration 
			FROM   WorkOrderLineBilling
			GROUP BY WorkORderId, WorkOrderLine, OrgUnit, BillingExpiration 
			HAVING count(1) >1
	</cfquery>
	
	<cfif checkIX.recordCount lte 0>
	
		<cfquery name="checkIAhead" 
  			datasource="appsWorkOrder" 
  			username="#SESSION.login#" 
  			password="#SESSION.dbpw#">
				SELECT top 1 WorkOrderID
				FROM   	WorkOrderLineBilling
				WHERE  	WorkOrderId 		= 	'#url.workorderid#'
			    AND 	WorkORderLine 		=	'#url.workorderline#'
			    AND 	BillingExpiration   =   #EXP#
		    	<cfif form.OrgUnit neq "">
			  	AND  	OrgUnit = '#Form.OrgUnit#'
		   		</cfif>	
		</cfquery>
		
		<cfif checkIAhead.recordCount gte 1>
			<!---just add the time ---->
			<cfset hour = Hour(now())>
			<cfset minute = Minute(now())>
			<cfset second = Second(now())>
			<cfif hour lt 10>
				<cfset hour ="0#hour#">
			</cfif>
			<cfif minute lt 10>
				<cfset minute ="0#minute#">
			</cfif>
			<cfif second lt 10>
				<cfset second = "0#second#">
			</cfif>
			<cfset EXP = replace(EXP,"{d ","{ts ","all")>
			<cfset EXP = replace(EXP,"'}"," #hour#:#minute#:#second#' }","all")>
		</cfif>
	</cfif>
	
</cfif>

<cftransaction>

<cfparam name="Form.BillingReference" default="">
<cfparam name="Form.BillingName"      default="">
<cfparam name="Form.WorkActionId"     default="">
<cfparam name="Form.BillingAddress"   default="">

<cfif check.recordcount eq "1">

<!--- Hanno 28/3/2016
<cfif check.recordcount eq "1" and Domain.AllowConcurrent eq "0">
--->	
	
	<cfquery name="Update" 
	  datasource="appsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	 	 
		UPDATE  WorkOrderLineBilling
		<cfif exp eq "">
		SET     BillingExpiration = NULL
		<cfelse>
		SET     BillingExpiration = #EXP# 
		</cfif>
		<cfif form.ServiceReference neq "">
			,ServiceDomain    = '#item.servicedomain#'
			,Reference        = '#form.ServiceReference#'
		</cfif>
		,BillingReference = '#form.billingReference#'
		,BillingAddress   = '#form.BillingAddress#'
		,BillingName      = '#form.billingName#'	
		,ReferenceNo      = '#form.ReferenceNo#'	
	    <cfif form.PayerId neq "" and form.PayerId neq "none">
			,PayerId = '#form.PayerId#'
		<cfelse>
			,PayerId = NULL
		</cfif>
		<cfif form.OrgUnit neq "">
			,OrgUnit = '#Form.OrgUnit#'
		<cfelse>
			,OrgUnit = NULL
		</cfif>
		WHERE   BillingId = '#url.billingid#' 				
	</cfquery>
		
	<!--- check if detail billing info is found with funding information --->
	
	<cfquery name="Update" 
	  datasource="appsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    UPDATE  WorkOrderLineBillingDetail	
		SET     Operational      = 0	
		WHERE   WorkOrderId      = '#check.workorderId#'
		AND     WorkOrderLine    = '#check.workorderline#'
		AND     BillingEffective = '#check.billingeffective#'		
	</cfquery>	
	
	<cfquery name="remove" 
	  datasource="appsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    DELETE  WorkOrderLineBillingAction			
		WHERE   WorkOrderId      = '#check.workorderId#'
		AND     WorkOrderLine    = '#check.workorderline#'
		AND     BillingEffective = '#check.billingeffective#'		
	</cfquery>		
		
	<cfloop index="itm" list="#Form.WorkActionId#">
	
		<!--- check if record exists --->
		<cfquery name="Insert" 
		  datasource="appsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			INSERT INTO WorkOrderLineBillingAction
				( WorkOrderId, 
				  WorkOrderLine, 
				  BillingEffective, 
				  WorkActionId,  
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName
				  )
	
			VALUES
			
			 ( '#check.workorderId#',
			   '#check.workorderline#',
			   '#check.billingeffective#',
			   '#itm#',		 
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#'
			   )		
		</cfquery>	
	
	</cfloop>	
	
<cfelse>

	<cf_assignid>	
	
	<!--- check if record exists --->
	<cfquery name="Insert" 
	  datasource="appsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		INSERT INTO WorkOrderLineBilling
			( BillingId,
			  WorkOrderId, 
			  WorkOrderLine, 
			  BillingEffective, 
			  <cfif exp neq "">
			  BillingExpiration, 
			  </cfif>
			  BillingReference,
			  BillingName,
			  BillingAddress,
			  ReferenceNo,
			  <cfif form.PayerId neq "" and form.Payerid neq "none">
			  PayerId,
			  </cfif>
			  <cfif form.OrgUnit neq "">
			  OrgUnit,
			  </cfif>				  
			  OfficerUserId, 
			  OfficerLastName, 
			  OfficerFirstName
			  )

		VALUES
		
		 ('#rowguid#',
		   '#url.workorderid#',
		   '#url.workorderline#',
		   #EFF#,
		   <cfif exp neq "">
		   #EXP#,
		   </cfif>
		   '#Form.BillingReference#',
		   '#Form.BillingName#',
		   '#Form.BillingAddress#',
		   '#Form.ReferenceNo#',
		   <cfif form.PayerId neq "" and form.PayerId neq "none">
		   '#form.PayerId#',
		   </cfif>
		   <cfif form.OrgUnit neq "">
		   '#Form.OrgUnit#',
		   </cfif>				
		   '#SESSION.acc#',
		   '#SESSION.last#',
		   '#SESSION.first#')		
	</cfquery>		
	
	<cfloop index="itm" list="#Form.WorkActionId#">
	
		<!--- check if record exists --->
		<cfquery name="Insert" 
		  datasource="appsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			INSERT INTO WorkOrderLineBillingAction
				( WorkOrderId, 
				  WorkOrderLine, 
				  BillingEffective, 
				  WorkActionId,  
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName
				  )
	
			VALUES
			
			 ( '#url.workorderid#',
			   '#url.workorderline#',
			   #EFF#,
			   '#itm#',		 
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#'
			   )		
		</cfquery>	
	
	</cfloop>	
		
	<cfquery name="Check" 
	  datasource="appsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineBilling
		WHERE   BillingId = '#rowguid#'				
	</cfquery>	

</cfif>

<!--- --------------------------------------------- --->
<!--- loop through the possible records for regular --->
<!--- --------------------------------------------- --->

<cfset cl = "regular">

<cfquery name="Unit" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT   DISTINCT R.*, 
		          M.Currency, 
			      M.Frequency,
				  M.BillingMode as BillMode,
				  M.StandardCost
	     FROM     ServiceItemUnit R, 
		          ServiceItemUnitMission M
		 WHERE    R.ServiceItem  = '#workorder.serviceitem#'
		 AND      R.ServiceItem = M.ServiceItem
		 <cfif url.billingid eq "">
		 AND      R.Operational = 1
		 </cfif>		
		 AND      R.Unit = M.ServiceItemUnit
		 AND     (M.Mission is NULL OR M.Mission = '#workorder.mission#')	
		 AND      M.DateEffective <= #eff# AND (M.DateExpiration >= #eff# or DateExpiration is NULL)		
		 <!---
		  AND    M.DateEffective <= #eff# AND M.DateExpiration >= #eff# 
		 AND    (DateExpiration is NULL or DateExpiration >= getDate())				
		 --->
		 AND      R.UnitClass = '#cl#' and M.BillingMode <> 'Supply'
		 ORDER BY R.ListingOrder, 
			      R.UnitDescription		
				 				  
				  				 
</cfquery>

<cfoutput query="Unit">
   
	<cfset id = currentrow>
		
	<cfparam name="Form.#cl#_Unit_#id#" default="">
	<cfparam name="Form.#cl#_Charged_#id#" default="0">		
	<cfset selected = evaluate("Form.#cl#_Unit_#id#")>
				
	<cfif selected neq "">		
				
		<cfinclude template="DetailBillingSubmitUnit.cfm">
	
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
				  M.BillingMode as BillMode	
	     FROM     ServiceItemUnit R, 
		          ServiceItemUnitMission M
		 WHERE    R.ServiceItem  = '#workorder.serviceitem#'
		 AND      R.ServiceItem = M.ServiceItem
		 <cfif url.billingid eq "">
		 AND      R.Operational = 1
		 </cfif>	
		 AND      M.BillingMode != 'Supply'		 
		 AND      R.Unit = M.ServiceItemUnit		 
		 AND     (M.Mission is NULL OR M.Mission = '#workorder.mission#')	
		 AND      M.DateEffective <= #eff# AND (M.DateExpiration >= #eff# or DateExpiration is NULL)		
		 <!---
		 AND    M.DateEffective <= #eff# AND M.DateExpiration >= #eff# 
		 AND    (DateExpiration is NULL or DateExpiration >= getDate())				
		 --->	
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
	
	<cfparam name="Form.#cl#_CostId_#id#" default="">	
	<cfset costid = evaluate("Form.#cl#_CostId_#id#")>
		
	<cfif chk neq "" and costid neq "">	
										
		<cfquery name="CostId" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *
			     FROM    ServiceItemUnitMission M
				 WHERE   CostId = '#costid#'		
		</cfquery>
		
		<cfset selected = costid.serviceitemunit>		
		
		<!--- #selected#<br>	--->
		
		<cfinclude template="DetailBillingSubmitUnit.cfm">
		
		<!--- now also include the features for this class --->
					
		<cfquery name="UnitChild" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT R.*, 
				        M.Currency, 
					    M.Frequency,
						M.BillingMode as BillMode,
						M.StandardCost
			     FROM   ServiceItemUnit R, 
				        ServiceItemUnitMission M
				 WHERE  R.ServiceItem  = '#workorder.serviceitem#'
				 AND    R.ServiceItem = M.ServiceItem
				 <cfif url.billingid eq "">
				 AND    R.Operational = 1
				 </cfif>	
				 AND    M.BillingMode != 'Supply'	
				 AND    R.Unit = M.ServiceItemUnit
				 AND    (M.Mission is NULL OR Mission = '#workorder.mission#')	
				  AND    M.DateEffective <= #eff# 
				 AND    (M.DateExpiration >= #eff# OR DateExpiration is NULL)
						
				 AND    R.UnitClass = '#cl#'
				 AND    (
				            R.UnitParent IN (SELECT Code FROM Ref_UnitClass)
				            OR
				            R.UnitParent IN (SELECT Unit FROM ServiceItemUnit WHERE ServiceItem = R.ServiceItem and Unit = R.UnitParent)
						 )
				 ORDER BY R.ListingOrder, 
					      R.UnitDescription							 
		</cfquery>
				
		<cfloop query="UnitChild">
		   
			<cfset id = currentrow>
							
			<cfparam name="Form.#cl#_Unit_#id#" default="">
			<cfparam name="Form.#cl#_Charged_#id#" default="0">		
			<cfset selected = evaluate("Form.#cl#_Unit_#id#")>
				
			<cfif selected neq "">		
			
				<cfinclude template="DetailBillingSubmitUnit.cfm">
			
			</cfif>
			
		</cfloop>			
	
	</cfif>
	
</cfoutput>

	<!--- --------------------------------- --->
	<!--- clear the not operational records --->
	<!--- --------------------------------- --->
	
	<cfquery name="List" 
		  datasource="appsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT    * 
			FROM      WorkOrderLineBillingDetail			
			WHERE     WorkOrderId      = '#check.workorderId#'
			AND       WorkOrderLine    = '#check.workorderline#'
			AND       BillingEffective = '#check.billingeffective#'		
			AND       Operational = 0
	</cfquery>
	
	<cfloop query="List">
		
			<cfquery name="Clean" 
			  datasource="appsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				DELETE FROM WorkOrderFunding		
				WHERE  BillingDetailId  = '#billingdetailid#'			
			</cfquery>
		
			<cfquery name="Clean" 
			  datasource="appsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				DELETE FROM WorkOrderLineBillingDetail		
				WHERE  BillingDetailId  = '#billingdetailid#'			
			</cfquery>
		
	</cfloop>

</cftransaction>

<cfif form.applyAll eq "1" and Form.WorkActionId eq "">
	<cfif url.billingid eq "">
	    <cfset url.billingid = rowguid>
	</cfif>
	<cfinclude template="DetailBillingSubmitSync.cfm">
</cfif>

<cfoutput>

	<script>
	   try {
	      parent.linebillingrefresh('#check.workorderId#','#check.workorderline#')    	
		  } catch(e) {}
		
	   try {	        
	      parent.lineactionrefresh('#check.workorderId#','#check.workorderline#')    							
		  } catch(e) {}	
		
	  try {	   
	      parent.window.focus();				 
     	  parent.ProsisUI.closeWindow('myprovision',true)		
	 	  } catch(e) {}	
	</script>
	
	
</cfoutput>
