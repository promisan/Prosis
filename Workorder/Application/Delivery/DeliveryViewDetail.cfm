
<!--- detailed scope deliveries to be shown --->

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>

<cfquery name="getCountry"
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT    *
		FROM      Ref_Mission
		WHERE     Mission = '#url.mission#'		
</cfquery>

<cfset nat = getCountry.CountryCode>

<cfquery name="Deliveries"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   A.DateTimePlanning, 	
		         W.WorkOrderId,
				 WL.WorkOrderLine,
				 WL.WorkOrderLineId,				
				 W.OrgUnitOwner,				
				 C.Address,
				 C.AddressNo,
				 C.City,
				 C.PhoneNumber,
				 C.MobileNumber,
				 C.PostalCode,		 				 
		         C.CustomerName,	
				 A.WorkActionId,
				 A.DateTimePlanning,
				 A.DateTimeActual,
																		   
				 (SELECT TopicValue FROM WorkOrderLineTopic  WHERE WL.WorkOrderId = WorkOrderId  
				                                           AND   WL.WorkOrderLine = WorkOrderLine 
				                                           AND   Topic = 'f009' 
														   AND   Operational = 1 ) as Instructions,	
														   
				 (SELECT TopicValue FROM WorkOrderLineTopic  WHERE WL.WorkOrderId = WorkOrderId  
				                                           AND   WL.WorkOrderLine = WorkOrderLine 
				                                           AND   Topic = 'f007' 
														   AND   Operational = 1 ) as Item,		
														   
				 (SELECT TopicValue FROM WorkOrderLineTopic  WHERE WL.WorkOrderId = WorkOrderId  
				                                           AND   WL.WorkOrderLine = WorkOrderLine 
				                                           AND   Topic = 'f008' 
														   AND   Operational = 1 ) as Size,		
														   
				 (SELECT TOP 1 TopicValue FROM WorkOrderLineTopic  WHERE WL.WorkOrderId = WorkOrderId  
				                                           AND   WL.WorkOrderLine = WorkOrderLine 
				                                           AND   Topic = 'f010' 
														   AND   Operational = 1 ORDER BY DateEffective DESC) as Notification
				 
	    FROM     WorkOrder AS W 
		
				 INNER JOIN Customer                           as C ON W.CustomerId   = C.CustomerId  
				
				 INNER JOIN WorkOrderLine                      as WL ON W.WorkOrderId = WL.WorkOrderId 
				 
				 INNER JOIN WorkOrderLineAction                as A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 	
				 
							 													 
											
	   WHERE     A.ActionClass = 'Delivery' 	   
	   AND       A.DateTimePlanning = #dts#	   	   	    
	   AND       W.OrgUnitOwner = '#url.orgunit#'  		  	  	   
	   AND       WL.Operational = '1'		
	   AND       W.ActionStatus != '9'		   
	   ORDER BY  C.City
</cfquery>

<table width="100%">
	<cfoutput query="Deliveries">
	<tr class="labelit">
	  <td style="width:30px;padding-left:50px">
	    <input type="checkbox" checked id="workaction_#orgunit#" name="workaction_#orgunit#" onclick="reloadcontent('partial')" value="'#workorderlineid#'">	
	  </td>
	  <td style="width:96%;padding-left:40px">#City# #PostalCode#</td>	  
	</tr>	
	</cfoutput>
</table>
