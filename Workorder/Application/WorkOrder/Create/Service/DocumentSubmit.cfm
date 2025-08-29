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
<!--- ---------------------------------------- --->
<!--- --Contract service for OICT data entry-- --->
<!--- ---------------------------------------- --->
<!--- ---------------------------------------- --->

<!--- save line --->

<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline" default="1">
<cfparam name="form.Reference"    default="">
<cfparam name="url.scope"         default="entry">

<cfquery name="Param" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Parameter			  
</cfquery>		

<cfquery name="WorkOrder" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkOrder
		WHERE  WorkOrderId   = '#URL.workorderid#'					  
</cfquery>			

<cfif WorkOrder.recordcount eq "0">

	<cf_assignId>
	
	<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
		
			<cfquery name="Parameter" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_ParameterMission
				WHERE Mission = '#url.Mission#' 
			</cfquery>		
				
			<cfset No = Parameter.WorkOrderSerialNo+1>
			<cfif No lt 10000>
			     <cfset No = 10000+No>
			</cfif>
				
			<cfquery name="Update" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Ref_ParameterMission
				SET    WorkOrderSerialNo = '#No#'
				WHERE  Mission = '#url.Mission#' 
			</cfquery>
		
	</cflock>
	
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset dte = dateValue>
		
	<cfset no = "#Parameter.WorkOrderPrefix#-#No#">
	
	<cfparam name="form.OrgUnitOwner" default="">
	
	<cfset id = rowguid>
	  
		<cfquery name="Insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WorkOrder
			         (WorkOrderId,
					 CustomerId,
					 ServiceItem,
					 Currency,
					 <!---
					 ServiceItemUnit,
					 --->
					 OrderMemo,
					 Mission, 
					 Reference, 
					 OrgUnitOwner,
					 OrderDate,			
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#id#',
			          '#url.customerid#',
					  '#url.serviceitem#',
					  '#form.Currency#',
					  <!---
					  '#form.Unit#',		
					  --->
					  '#Form.Ordermemo#',			  
			          '#url.Mission#', 
					  <cfif form.reference eq "">
					  '#no#', 
					  <cfelse>
					  '#Form.Reference#',
					  </cfif>
					  <cfif form.OrgUnitOwner neq "">
					  '#form.OrgUnitOwner#',
					  <cfelse>
					  NULL,
					  </cfif>
					  #dte#,			 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>
		
		<!--- record implementer list --->
		
		<cfif form.OrgUnitOwner neq "">
		
			<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO WorkOrderImplementer
				         (WorkOrderId,
						 OrgUnit,					
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				  VALUES ('#id#',
				          '#form.OrgUnitOwner#',					 
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
			</cfquery>
		
		</cfif>
				
		
<cfelse>

	<cfparam name="form.OrgUnitOwner" default="">

	<cfset id = URL.workorderid>
			
	<cfquery name="WorkOrder" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			UPDATE  WorkOrder
			<cfif form.OrgUnitOwner neq "">
			SET OrgUnitOwner = '#Form.OrgUnitOwner#'
			<cfelse>
			SET OrgUnitOwner = NULL
			</cfif>
			WHERE  WorkOrderId   = '#id#'						  
	</cfquery>			

</cfif>


<cfquery name="GL" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMissionGledger
		WHERE  Mission = '#url.mission#'	
		AND    ServiceItem = '#url.serviceitem#'						  
</cfquery>	

<cfif GL.recordcount eq "1">

	<cfquery name="GL" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMissionGledger
		WHERE  Mission = '#url.mission#'	
		AND    ServiceItem = ''						  
	</cfquery>	

</cfif>

<cfloop query="GL">

	<cfquery name="Insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WorkOrderGledger
			         (WorkOrderId,
					 Area,    
					 GLAccount,						
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			VALUES ('#id#',
			        '#Area#', 					   
			   	    '#GLAccount#', 
				    '#SESSION.acc#',
			    	'#SESSION.last#',		  
				  	'#SESSION.first#')
	</cfquery>


</cfloop>

<!--- 
	
<cfquery name="Line" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkOrderLine
		WHERE  WorkOrderId   = '#id#'		  
		AND    WorkOrderLine = '#url.workorderline#'					  
</cfquery>	

<cfif Line.recordcount eq "0">

		<cfquery name="Insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WorkOrderLine
			         (WorkOrderId,
					 WorkOrderLine,    
					 PersonNo,						
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  VALUES ('#id#',
			          '#url.workorderline#',
			          '#Form.PersonNo#', 					   
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
		</cfquery>
		
<cfelse>
				
	<cfquery name="Update" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			UPDATE  WorkOrderLine
			SET PersonNo = '#Form.PersonNo#'
			WHERE  WorkOrderId   = '#id#'	
			AND   WorkOrderLine = '#url.workorderline#'					  
	</cfquery>		

</cfif>

<!--- save custom --->

<cfinclude template="../CustomFieldsSubmit.cfm">

<!--- save action --->

<cfinclude template="../ActionFieldsSubmit.cfm">

--->

<cfoutput>

	<script>
	
	   opener.applyfilter('5','','content')		  
	   ptoken.open('#session.root#/WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=#id#&idmenu=#url.idmenu#','_self')
	  		
	</script>
	
</cfoutput>

				
		<!--- refresh the dialog screen for adding 
		<cfif url.scope eq "entry">		   
			ColdFusion.navigate('CustomerEdit.cfm?height='+h+'&dsn=appsWorkOrder&customerid=#url.customerid#&mode=view','detail',mycallBack,myerrorhandler)				  
		<cfelseif url.scope eq "add">			   		    
		    ColdFusion.navigate('CustomerEdit.cfm?height='+h+'&dsn=appsWorkOrder&customerid=#url.customerid#&mode=view','detail',mycallBack,myerrorhandler)		
			ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?mission=#url.mission#&customerid=#url.customerid#','addworkorder')
		<cfelseif url.scope eq "edit">	
		    ColdFusion.Window.hide('adddetail') 		   
			applyfilter('1','','#url.workorderid#')
			
		</cfif>		
		--->	
