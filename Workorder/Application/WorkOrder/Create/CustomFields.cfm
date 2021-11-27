 
<!--- define custom topics --->

<cfparam name="URL.mode"           default="edit">
<cfparam name="URL.mission"        default="">
<cfparam name="URL.topicclass"     default="WorkOrder">
<cfparam name="URL.domainclass"    default="">
<cfparam name="URL.workorderid"    default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.workorderline"  default="0">
<cfparam name="URL.selectionDate"  default="">
<cfparam name="URL.topic"          default="">
<cfparam name="URL.context"        default="backoffice">
<cfparam name="URL.inputclass"     default="regular">
<cfparam name="URL.style"          default="padding-left:7px">

<cfif url.selectiondate neq "">

	<CF_DateConvert Value="#url.selectiondate#">
    <cfset DTE = dateValue>

</cfif>

<cfquery name="ServiceItem" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT  *
    FROM    Serviceitem					
	WHERE   Code = '#url.ServiceItem#' 	
</cfquery> 
  
<cfquery name="hasClassFilter" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT  Code
    FROM    Ref_TopicDomainClass					
	WHERE   ServiceDomain      = '#ServiceItem.ServiceDomain#' 	
</cfquery> 
  
<cfquery name="GetTopics" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT    *
  FROM      #client.lanPrefix#Ref_Topic
  <cfif url.topic neq "">
  WHERE     Code = '#url.topic#'
  <cfelse>
  WHERE     Code IN (SELECT Code 
                     FROM   Ref_TopicServiceItem
				     WHERE  ServiceItem = '#url.ServiceItem#'
				     AND    ShowInContext IN ('Any','#url.context#')
				  )
  AND       (Mission = '#url.Mission#' or Mission is NULL)	   
  </cfif>				    			 
  AND       Operational = 1   
  AND       TopicClass = '#url.topicclass#'  
  ORDER BY  ListingOrder  
</cfquery>

<cfoutput query="GetTopics">

<!--- check if this topic has classes defined for the service item --->

<cfquery name="hasClassFilter" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_TopicDomainClass					
	WHERE  Code             = '#Code#'
	AND    ServiceDomain    = '#ServiceItem.ServiceDomain#' 	
 </cfquery> 
 
<cfif hasClassFilter.recordcount eq "0">
		<cfset show = "1">		
<cfelse>
	
	<cfquery name="checkClass" 
	  datasource="AppsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_TopicDomainClass					
		WHERE  Code               = '#Code#'
		AND    ServiceDomain      = '#ServiceItem.ServiceDomain#' 	
		AND    ServiceDomainClass = '#url.domainclass#'
	 </cfquery> 
	 	 
	 <cfif checkclass.recordcount eq "1">	 	
	 	<cfset show = "1">		
	 <cfelse>	 
	 	<cfset show = "0">	 
	 </cfif>

</cfif> 

<cfif show eq "1">
		
	<cfif url.topic eq "">	
		
		<tr class="labelmedium fixlengthlist">     
					
			<cfif ValueClass neq "Memo">	
			
				   <cfif tooltip neq "">
				      <td valign="top" style="#url.style#;cursor:pointer;padding-top:5px">						  
				   	  <cf_UIToolTip  tooltip="#Tooltip#"><font color="0080C0">#Description# : <cfif valueobligatory eq "1"><font color="red">*)</font></cfif></cf_UIToolTip>
					  </td>
				   <cfelse>
				    <td valign="top" style="#url.style#;padding-top:5px">					 
				     #Description# : <cfif valueobligatory eq "1"><font color="red">*)</font></cfif>
				    </td>
				   </cfif>
			   
			  <cfelse>
			  
				  <cfif tooltip neq "">
				      <td valign="top" style="#url.style#;cursor:pointer;padding-top:5px" title="#Tooltip#">			  					 
				   	  <font color="0080C0">#Description# <cfif valueobligatory eq "1"><font color="red">*)</font></cfif>
					  </td>
				   <cfelse>
				    <td valign="top" style="#url.style#;padding-top:5px">					
				     #Description# : <cfif valueobligatory eq "1"><font color="red">*)</font></cfif>				     
				     <cfset ajaxonload("initTextArea")>				     
				    </td>
				   </cfif>	  
			  
			  </cfif> 
			  			  
			   <td class="labelmedium" style="width:100%">		   			   			   			   
			   
			   
		</cfif>	   		
				   			    			   
		<cfif URL.Mode neq "edit">
		   
		       <cfif ValueClass eq "List">			   
			   		   
				    <cfquery name="GetList" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT T.*, 
					         P.ListCode as Selected
					  FROM   Ref_TopicList T, 
					  <cfif url.topicclass eq "WorkOrder">
					         WorkOrderLineTopic P
					  <cfelse>
					          WorkOrderTopic P
					  </cfif>		 
					  WHERE  T.Code        = '#GetTopics.Code#'
					  AND    P.Topic         = T.Code
					  AND    P.ListCode      = T.ListCode
					  AND    P.WorkOrderId   = '#URL.workorderid#'	
					  <cfif url.topicclass eq "WorkOrder">	  
					  AND    P.WorkOrderLine = '#url.workorderline#'
					  </cfif>
					  AND    P.DateEffective = (SELECT MAX(DateEffective)
					                             <cfif url.topicclass eq "WorkOrder">    
						                        FROM   WorkOrderLineTopic
												 <cfelse>
												FROM   WorkOrderTopic
												 </cfif>
												WHERE  WorkOrderId   = '#URL.workorderid#'		
												<cfif url.topicclass eq "WorkOrder">   
												AND    WorkOrderLine = '#url.workorderline#'
												</cfif>
												<cfif url.selectiondate neq "">
												AND    DateEffective <= #dte#
												</cfif>
												AND    Topic = P.Topic	)
					  ORDER BY T.ListOrder 
					</cfquery>
					
					<cfif GetList.ListValue neq "">
				   
					   #GetList.ListValue#
					   
					<cfelse>
					
					   N/A
					   
					</cfif>  
				
				<cfelse>
										
					 <cfquery name="GetList" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT *
					  <cfif url.topicclass eq "WorkOrder">
					  FROM   WorkOrderLineTopic P
					  <cfelse>
					  FROM   WorkOrderTopic P
					  </cfif>
					  WHERE  P.Topic = '#Code#'						 
					  AND    P.WorkOrderId   = '#URL.workorderid#'		
					  <cfif url.topicclass eq "WorkOrder">  
					  AND    P.WorkOrderLine = '#url.workorderline#'		
					  </cfif>
					  AND    P.DateEffective = (SELECT MAX(DateEffective)
					                             <cfif url.topicclass eq "WorkOrder">    
						                         FROM   WorkOrderLineTopic
												 <cfelse>
												 FROM   WorkOrderTopic
												 </cfif>
												 WHERE  WorkOrderId   = '#URL.workorderid#'		
												 <cfif url.topicclass eq "WorkOrder">   
												 AND    WorkOrderLine = '#url.workorderline#'
												 </cfif>
												 <cfif url.selectiondate neq "">
												 AND    DateEffective <= #dte#
											     </cfif>
												 AND    Topic = P.Topic	)
					  
					    
					</cfquery>
								
					
					<cfif GetList.TopicValue neq "">
					
					   <cfif ValueClass eq "Boolean">
					   
						   <cfif GetList.TopicValue eq "1">Yes<cfelse>No</cfif>
						   
					   <cfelseif ValueClass eq "Date">
					   
					        <cftry>
					   		#dateformat(GetList.TopicValue,CLIENT.DateFormatShow)#			
							<cfcatch></cfcatch>	   	   
							</cftry>
					   
					   <cfelse>
					   
					   		#GetList.TopicValue#
							
					   </cfif>
				   						   
					<cfelse>
					
					   N/A
					   
					</cfif>  
								
				
				</cfif>			    
			
		   <cfelse>
		      
				<cfinclude template="CustomFieldsContent.cfm">   						
			
		</cfif>	
				
		<cfif url.topic eq "">
									   
			   </td>
			   
		  	</tr>	
			
		</cfif>
		
</cfif>	
		    
</cfoutput>	

<cfset ajaxOnLoad("doCalendar")>
  
