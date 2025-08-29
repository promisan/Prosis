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
<cfparam name="attributes.requisitionNoFrom" default="">
<cfparam name="attributes.workorder"     default="No">
<cfparam name="attributes.ActionStatus"  default="1">

<cfquery name = "Source" 
	 datasource = "AppsPurchase" 
	 username   = "#SESSION.login#" 
	 password   = "#SESSION.dbpw#">		 
	 	SELECT *
		FROM   RequisitionLine
		WHERE  RequisitionNo = '#Attributes.RequisitionNoFrom#'		 
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#source.Mission#' 
</cfquery>

<!--- only if RequestLine.ActionStatus = 0, 1 we allow --->
<cfif Source.recordCount eq 1 and  
      Source.ActionStatus eq attributes.ActionStatus and 
	  Parameter.MissionPrefix neq "">
							
	<cftransaction>
						
	<cfset No = Parameter.RequisitionNo+1>
	<cfif No lt 10000>
		     <cfset No = 10000+No>
	</cfif>
		
	<cfset requisitionNoTo = "#Parameter.MissionPrefix#-#No#">
			
	<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Ref_ParameterMission
			SET    RequisitionNo = '#No#'
			WHERE  Mission = '#source.Mission#' 
	</cfquery>		
	
	<!--- inherit requisition --->
	
	<!--- use the session.acc, last, first based on the actor of this action --->
	
	<!--- for dbo.RequisitionLine assign its own 
	          RequisitionLineId 
	          Populate ParentRequisitionNo with the From--->	
	<cf_AssignId>

	<cfset rId = rowguid>
	
	<cfif attributes.workorder eq "Yes">
	
		<cfinvoke component 	= "Service.Process.System.Database"  
			   method           = "getTableFields" 
			   datasource	    = "AppsPurchase"	  
			   tableName        = "RequisitionLine"
			   ignoreFields		= "'ParentRequisitionNo','Reference','ActionStatus','JobNo','ModificationNo','OrgUnit','OrgUnitImplement','BuyerActionRequest','RequestDate','RequestDue','RequisitionNo','ParentRequisitionNo','RequisitionId','SourceNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
			   returnvariable   = "fields">	
			   
	<cfelse>
	
		<cfinvoke component 	= "Service.Process.System.Database"  
			   method           = "getTableFields" 
			   datasource	    = "AppsPurchase"	  
			   tableName        = "RequisitionLine"
			   ignoreFields		= "'ParentRequisitionNo','Reference','ActionStatus','JobNo','ModificationNo','OrgUnit','OrgUnitImplement','BuyerActionRequest','RequestDate','RequestDue','RequirementId','WorkOrderId','WorkOrderLine','RequisitionNo','ParentRequisitionNo','RequisitionId','SourceNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
			   returnvariable   = "fields">	
	
	</cfif>	   
	
	<!--- validate orgunit --->
	
	<cfquery name="getMandate" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   Organization.dbo.Ref_MissionPeriod
			WHERE  Mission = '#source.Mission#'
			AND    Period  = '#source.Period#'			
	</cfquery>		
	
	<cfquery name="getOrganization" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			    SELECT * 
				FROM   Organization.dbo.Organization
				WHERE  Mission    = '#getMandate.Mission#'
				AND    MandateNo  = '#getMandate.MandateNo#'			
				AND    OrgUnit    = '#source.OrgUnit#'
	</cfquery>		
	
	<cfif getOrganization.recordcount eq "0">
	
		<cfquery name="base" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 * 
				FROM   Organization.dbo.Organization
				WHERE  Mission    = '#getMandate.Mission#'
				AND    MandateNo  = '#getMandate.MandateNo#'						
		</cfquery>		
	
		<cfset org = base.OrgUnit>
		
	<cfelse>
	
		<cfset org = source.OrgUnit>	
		
	</cfif>	
		
	<cfquery name="InsertRequisitionLine" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 			 
			 	INSERT INTO RequisitionLine	(
					  RequisitionNo,
				      SourceNo,
					  RequisitionId,
					  RequestDate,
					  ActionStatus,
					  OrgUnit,
					  OrgUnitImplement,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,
					  Created,
					  #fields#  )
				  
				SELECT '#requisitionNoTo#' AS RequisitionNo,
			           '#Attributes.requisitionNoFrom#' AS SourceNo,
				       '#rId#' AS RequisitionId,
					   '#dateformat(now(),client.dateSQL)#',
					   '1',
					   '#Org#',
					   '#Org#',
				       '#SESSION.Acc#'   AS OfficerUserId,
			      	   '#SESSION.Last#'  AS OfficerLastName,
			      	   '#SESSION.First#' AS OfficerFirstName,
			            getdate() AS Created,
						#fields#
						
			  FROM Purchase.dbo.RequisitionLine
			  WHERE RequisitionNo = '#attributes.requisitionNoFrom#' 
	  
	</cfquery>

	<!--- RequisitionLineActor --->
	<cfinvoke component 	= "Service.Process.System.Database"  
		   method           = "getTableFields" 
		   datasource	    = "AppsPurchase"	  
		   tableName        = "RequisitionLineActor"
		   ignoreFields		= "'RequisitionNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
		   returnvariable   = "fields">	
						
	<cfquery name="InsertRequisitionLineActor" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			  	INSERT INTO RequisitionLineActor (
				  RequisitionNo,
			      OfficerUserId,
			      OfficerLastName,
			      OfficerFirstName,
			      Created,
				  #fields# )
				
				SELECT '#RequisitionNoTo#' AS RequisitionNo,
			     	   '#SESSION.Acc#'   AS OfficerUserId,
				       '#SESSION.Last#'  AS OfficerLastName,
				       '#SESSION.First#' AS OfficerFirstName,
				       getdate() AS Created,
					   #fields#
					   				  
			  	FROM Purchase.dbo.RequisitionLineActor
				WHERE RequisitionNo = '#attributes.requisitionNoFrom#'
			  
	</cfquery>
	
	<!--- RequisitionLineFunding --->
	<cfinvoke component 	= "Service.Process.System.Database"  
		   method           = "getTableFields" 
		   datasource	    = "AppsPurchase"	  
		   tableName        = "RequisitionLineFunding"
		   ignoreFields		= "'RequisitionNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
		   returnvariable   = "fields">	

						
	<cfquery name="InsertRequisitionLineFunding" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	
		  INSERT INTO RequisitionLineFunding (
				  RequisitionNo,
	 			  OfficerUserId,
			      OfficerLastName,
			      OfficerFirstName,
			      Created,
				  #fields# )			
		  SELECT '#RequisitionNoTo#' AS RequisitionNo,
	 			  '#SESSION.Acc#'   AS OfficerUserId,
			      '#SESSION.Last#'  AS OfficerLastName,
			      '#SESSION.First#' AS OfficerFirstName,
		    	  getdate() AS Created,
				  #fields#			  
		  FROM Purchase.dbo.RequisitionLineFunding
		  WHERE RequisitionNo = '#attributes.requisitionNoFrom#'		  
	</cfquery>
	
	<!--- RequisitionLineBudget --->
	
	<cfinvoke component 	= "Service.Process.System.Database"  
		   method           = "getTableFields" 
		   datasource	    = "AppsPurchase"	  
		   tableName        = "RequisitionLineBudget"
		   ignoreFields		= "'RequisitionNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
		   returnvariable   = "fields">	
						
	<cfquery name="InsertRequisitionLineBudget" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
		 	INSERT INTO RequisitionLineBudget (
				  RequisitionNo,
	 			  OfficerUserId,
			      OfficerLastName,
			      OfficerFirstName,
			      Created,
				  #fields# )			
		  SELECT '#RequisitionNoTo#' AS RequisitionNo,
 			     '#SESSION.Acc#'   AS OfficerUserId,
		         '#SESSION.Last#'  AS OfficerLastName,
		         '#SESSION.First#' AS OfficerFirstName,
		         getdate() AS Created,
			     #fields#			  
		  FROM  Purchase.dbo.RequisitionLineBudget
		  WHERE RequisitionNo = '#attributes.requisitionNoFrom#'
		  
	</cfquery>
	
	<!--- RequisitionLineItinerary --->
	<cfinvoke component 	= "Service.Process.System.Database"  
		   method           = "getTableFields" 
		   datasource	    = "AppsPurchase"	  
		   tableName        = "RequisitionLineItinerary"
		   ignoreFields		= "'RequisitionNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
		   returnvariable   = "fields">	
						
	<cfquery name="InsertRequisitionLineItinerary" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
	 	 INSERT INTO RequisitionLineItinerary (
				  RequisitionNo,
				  OfficerUserId,
			      OfficerLastName,
			      OfficerFirstName,
			      Created,
				  #fields# )
		  SELECT '#RequisitionNoTo#' AS RequisitionNo,
				 '#SESSION.Acc#'   AS OfficerUserId,
			     '#SESSION.Last#'  AS OfficerLastName,
			     '#SESSION.First#' AS OfficerFirstName,
			     getdate() AS Created,
				 #fields#				  
		  FROM   Purchase.dbo.RequisitionLineItinerary
		  WHERE  RequisitionNo = '#attributes.requisitionNoFrom#'		  
	  </cfquery>
	
	<!--- RequisitionLineTravel --->
	<cfinvoke component 	= "Service.Process.System.Database"  
		   method           = "getTableFields" 
		   datasource	    = "AppsPurchase"	  
		   tableName        = "RequisitionLineTravel"
		   ignoreFields		= "'RequisitionNo','Created'"
		   returnvariable   = "fields">	
	
	<cfquery name="InsertRequisitionLineTravel" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
		 	INSERT INTO Purchase.dbo.RequisitionLineTravel (RequisitionNo,Created,#fields# )
			SELECT '#RequisitionNoTo#' AS RequisitionNo,
		      		getdate() AS Created,
					#fields#					
		    FROM    Purchase.dbo.RequisitionLineTravel
		    WHERE   RequisitionNo = '#attributes.requisitionNoFrom#'		  
	</cfquery>
	
	<!--- RequisitionLineTravelPointer --->
	<cfinvoke component 	= "Service.Process.System.Database"  
		   method           = "getTableFields" 
		   datasource	    = "AppsPurchase"	  
		   tableName        = "RequisitionLineTravelPointer"
		   ignoreFields		= "'RequisitionNo','Created'"
		   returnvariable   = "fields">	
	
	<cfquery name="InsertRequisitionLineTravelPointer" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
		 	INSERT  INTO Purchase.dbo.RequisitionLineTravelPointer (RequisitionNo,Created,#fields#)
			SELECT  '#RequisitionNoTo#' AS RequisitionNo,getdate() AS Created,#fields#				  
			FROM    Purchase.dbo.RequisitionLineTravelPointer
			WHERE   RequisitionNo = '#attributes.requisitionNoFrom#'			
	  </cfquery>
  
	<!--- RequisitionLineUnit --->
	<cfinvoke component 	= "Service.Process.System.Database"  
		   method           = "getTableFields" 
		   datasource	    = "AppsPurchase"	  
		   tableName        = "RequisitionLineUnit"
		   ignoreFields		= "'RequisitionNo','Created'"
		   returnvariable   = "fields">	
	
	<cfquery name="InsertRequisitionLineUnit" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">			 
	 	 INSERT INTO Purchase.dbo.RequisitionLineUnit (RequisitionNo,Created,#fields# )			
		 SELECT  '#RequisitionNoTo#' AS RequisitionNo,
				 getdate() AS Created,
				 #fields#				
		  FROM   Purchase.dbo.RequisitionLineUnit
		  WHERE  RequisitionNo = '#attributes.requisitionNoFrom#'		  
    </cfquery>
  
	<!--- RequisitionLineService --->
	<cfinvoke component 	= "Service.Process.System.Database"  
		   method           = "getTableFields" 
		   datasource	    = "AppsPurchase"	  
		   tableName        = "RequisitionLineService"
		   ignoreFields		= "'RequisitionNo','Created'"
		   returnvariable   = "fields">		
	
	<cfquery name="InsertRequisitionLineService" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	
		 
		 	INSERT INTO Purchase.dbo.RequisitionLineService	(
			  RequisitionNo,
		      Created,
			  #fields# )
			SELECT '#RequisitionNoTo#' AS RequisitionNo,getdate() AS Created,#fields#
			  
		  FROM   Purchase.dbo.RequisitionLineService
		  WHERE  RequisitionNo = '#attributes.requisitionNoFrom#'
		  
	  </cfquery>
  
	<!--- RequisitionLineTopic --->
	<cfinvoke component 	= "Service.Process.System.Database"  
		   method           = "getTableFields" 
		   datasource	    = "AppsPurchase"	  
		   tableName        = "RequisitionLineTopic"
		   ignoreFields		= "'RequisitionNo','Created'"
		   returnvariable   = "fields">		
	
	<cfquery name="InsertRequisitionLineTopic" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	
		 
		 	INSERT INTO Purchase.dbo.RequisitionLineTopic (
				  RequisitionNo,Created,#fields#
			)
			
			SELECT '#RequisitionNoTo#' AS RequisitionNo,getdate() AS Created, #fields#				
		    FROM   Purchase.dbo.RequisitionLineTopic
	 	    WHERE  RequisitionNo = '#attributes.requisitionNoFrom#'
		  
  	</cfquery>
	
	</cftransaction>
	
</cfif>
