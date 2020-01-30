
<cfparam name="url.context"           default="backoffice">
<cfparam name="url.mode"              default="workorder">
<cfparam name="url.accessmode"        default="edit">
<cfparam name="url.billingid"         default="">
<cfparam name="url.requestid"         default="">
<cfparam name="url.workorderid"       default="">
<cfparam name="url.workorderline"     default="">
<cfparam name="url.servicereference"  default="">
<cfparam name="url.orgunitowner"      default="">
<cfparam name="url.operational"       default="0">

<cfif url.mode eq "workorder">
	
	<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrder
		 WHERE   WorkOrderId = '#url.workorderid#'	
	</cfquery>
	
	<cfif workorder.recordcount eq "1">
	
		<cfset url.mission = workorder.mission>
		
		<cfquery name="Item" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT  *	
		     FROM    #CLIENT.lanPrefix#ServiceItem
			 WHERE   Code   = '#workorder.serviceitem#'	
		</cfquery>
		
		<cfset url.serviceitem = workorder.serviceitem>
		
	<cfelse>
	
		<cfquery name="Item" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT  *	
		     FROM    #CLIENT.lanPrefix#ServiceItem
			 WHERE   Code   = '#url.serviceitem#'	
		</cfquery>			
	
	</cfif>
	
	<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine
		 WHERE   WorkOrderId   = '#url.workorderid#'	
		 AND     WorkOrderLine = '#url.workorderline#'
	</cfquery>
		
	<cfset url.servicedomain      = line.servicedomain>
	<cfset url.servicedomainclass = line.servicedomainclass>
	
<cfelse>
	
	<cfquery name="Item" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    #CLIENT.lanPrefix#ServiceItem
		 WHERE   Code   = '#url.serviceitem#'	
	</cfquery>
	
	<cfquery name="getAction" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_RequestWorkflow		
			WHERE  RequestType   = '#url.requesttype#'
			AND    ServiceDomain = '#Item.ServiceDomain#'
			AND    RequestAction = '#url.RequestAction#'					
	</cfquery>
	
	<cfset url.servicedomain      = getAction.servicedomain>
	<cfset url.servicedomainclass = getAction.servicedomainclass>
		
</cfif>

<cfparam name="url.date" default="#date#">
<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset STR = dateValue>

<table width="99%" border="0" cellspacing="0" cellpadding="0">	  
	  
	   <tr class="labelmedium line"><td height="23" width="1"></td>
	       <td width="99%"></td>
		   <td>
		   <cf_space spaces="10">
		   </td>
		   <td>
		   <cf_space spaces="15">
		   </td>
		   <td>
		   <cf_space spaces="10">
		   </td>
		   <cfif url.context neq "portal">
			   <td align="right">
			   <cf_space spaces="30">
			   </td>		  
			   <td align="right">
			   <cf_space spaces="30">
			   </td>
			   <td align="right">
			   <cf_space spaces="30">	
			   </td>
			   <td align="right" style="padding-right:5px">
			   <cf_space spaces="30">	
			   </td>
		   </cfif>
		  
	   </tr>	   
	   	   
	   <!--- select billing classes that have valid entries for this provider --->	   
	   	    		
	   <cfquery name="ClassList" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				
		    SELECT *
			FROM (
								
			SELECT   DISTINCT 
			         C.Code as UnitClass,
					 
					 <cfif url.serviceReference neq "">
					 
						 <!--- alternate sorting --->
						
						(    SELECT MIN(ListingOrder)
						     FROM   ServiceItemUnitWorkorderService
							 WHERE  ServiceItem   = '#url.serviceitem#'
							 AND    ServiceDomain = '#url.servicedomain#'
							 AND    Reference     = '#url.serviceReference#'
							 AND    Mission       = '#url.mission#'
							 AND    Unit IN (SELECT Unit 
							                 FROM   ServiceItemUnit 
											 WHERE  ServiceItem = '#url.serviceitem#' 
											 AND    UnitClass = C.Code) 
							 
						 ) as ClassOrder,	
						 
					 <cfelse>			 
					 
			             C.ListingOrder as ClassOrder,
					 
					 </cfif>
					 
				     C.Description  as ClassDescription
					
		    FROM     #CLIENT.lanPrefix#ServiceItemUnit R, 
			         ServiceItemUnitMission M, 
				     #CLIENT.lanPrefix#Ref_UnitClass C
					 
			WHERE    R.ServiceItem  = '#url.serviceitem#'
			
			AND      R.ServiceItem  = M.ServiceItem
			 
			<cfif url.billingid eq "" or url.operational eq "1">						 
			   AND   R.Operational = 1
			</cfif>
			
			<!--- show provisioning based on the actity of the domain --->
			
			<cfif url.serviceReference neq "">
			
			   AND   R.Unit IN (SELECT Unit 
			                    FROM   ServiceItemUnitWorkorderService
							    WHERE  ServiceItem   = '#url.serviceitem#'
							    AND    ServiceDomain = '#url.servicedomain#'
								AND    Reference     = '#url.serviceReference#'
								AND    Mission       = '#url.mission#') 			
			</cfif>
				 
			AND       C.Code = R.UnitClass
			AND       R.Unit = M.ServiceItemUnit
			AND       (M.Mission is NULL OR Mission = '#url.mission#')	
			AND       M.DateEffective <= #str# 
			AND       ( DateExpiration is NULL OR DateExpiration >= #STR# )					 
			
			) as B
			
			ORDER BY  ClassOrder, 
			          ClassDescription				  	          
			 	 
		</cfquery>	
								
		<cfif ClassList.recordcount eq "0">
		
		<cfoutput>				
						
		<tr><td style="padding-top:60px" colspan="9" align="center" class="labellarge">
		
			<cfif url.serviceReference eq "">
			
				<font color="FF0000">
					<cf_tl id="No rates found for"> #url.mission# <cf_tl id="were defined for this service with an effective date"> #dateformat(str,CLIENT.DateFormatShow)# <cf_tl id="or earlier">.
				</font>
			
			<cfelse>
			
				<font color="FF0000">
					<cf_tl id="No provisioning found for"> #url.mission# <cf_tl id="were defined for this service with an effective date"> #dateformat(str,CLIENT.DateFormatShow)# <cf_tl id="or earlier">.
				</font>
			
			</cfif>
		
		</td></tr>		
				
		</cfoutput>
		
		</cfif>
								
		<cfoutput query="ClassList">		
							
			<cfif UnitClass neq "regular">
																				
				<cfinclude template="DetailBillingFormEntrySelect.cfm">											
						
				<!--- pass the value of the selected service item unit not of the class --->
				
				<!--- parent --->
				<cfset url.unitclass = unitclass>				
				
				<!--- unit specific --->
				<cfset url.parent    = sel>						
				
				<cfif unitUsed.recordcount eq 1 or cl eq "label">	
				   <cfset cl = "regular">
				<cfelse>
				   <cfset cl = "hide">
				</cfif>							
									
				<tr>
				  <td colspan="10" style="height:0px" align="right" id="features_#unitclass#" class="#cl#">					  					 			 				  				  
				   <cfinclude template="DetailBillingFormEntryRegularAjax.cfm">													
				  </td>
				</tr>						
			
			<cfelse>	
			
				<cfset url.parent = "">												 				
				<cfinclude template="DetailBillingFormEntryRegular.cfm">
												
			</cfif>
					
		</cfoutput>		

</table>	

<script>
	Prosis.busy('no')
</script>