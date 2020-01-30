
<cfquery name="Param" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Ref_ParameterMission
   	  WHERE Mission = '#URL.Mission#' 	 
</cfquery>

<cfquery name="Status" 
  datasource="AppsWorkorder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   E.EntityStatus, 
	         E.StatusDescription, 
			 
				 (SELECT count(*)  
	              FROM   Request R
				  WHERE  R.Mission  = '#url.mission#' 	
				  AND    R.Requestid IN (
				                       SELECT  Requestid 
				                       FROM    RequestLine RL
									   WHERE   RL.ServiceItem IN (SELECT Code 
											                      FROM   ServiceItem 
															      WHERE  ServiceDomain = '#url.domain#')
									   AND    Requestid = R.RequestId

									   UNION
									   
									   SELECT  Requestid 
				                       FROM    RequestWorkorderDetail RL
									   WHERE   Amendment = 'Serviceitem'
									   AND     ValueFrom IN (SELECT Code 
											                      FROM   ServiceItem 
															      WHERE  ServiceDomain = '#url.domain#')
									   AND    Requestid = R.RequestId						  
								  	  )		
				   					  					 
				  AND  R.ActionStatus = E.EntityStatus	  		    										 
										 
					<cfif getAdministrator(url.mission) eq "0">
			
						AND  ( 
						
							     <!--- requester if he has access to that request unit as requester --->
							
								 R.OrgUnit IN (SELECT OrgUnit 
						                       FROM   Organization.dbo.OrganizationAuthorization 
											   WHERE  UserAccount = '#SESSION.acc#'
											   AND    Role = 'ServiceRequester'
											 )
											 
								OR 
								
								(
				
								R.RequestId IN (
								
				                SELECT RequestId 
	                       		FROM   RequestLine 
								WHERE  ServiceItem IN (
								                      SELECT ClassParameter
									                  FROM   Organization.dbo.OrganizationAuthorization
											          WHERE  UserAccount = '#SESSION.acc#'
													  AND    Role        = 'WorkOrderProcessor'
													  AND    Mission     = '#url.mission#' 
													 )
								UNION
								
								SELECT RequestId 
	                       		FROM   RequestWorkOrderDetail
								WHERE  Amendment = 'ServiceItem' 
								AND    ValueFrom IN (
								                      SELECT ClassParameter
									                  FROM   Organization.dbo.OrganizationAuthorization
											          WHERE  UserAccount = '#SESSION.acc#'
													  AND    Role        = 'WorkOrderProcessor'
													  AND    Mission     = '#url.mission#'
													 )								
													 
							     )
							   
							  )		
							  
							  )		
							  
					<cfelse>
					
					 	  <!--- no filtering ---> 
										
					</cfif>			 					 
										 
				 ) AS counted
				 
    FROM     Organization.dbo.Ref_EntityStatus E
    WHERE    E.EntityCode = 'WrkRequest'	
    GROUP BY E.EntityStatus, E.StatusDescription
	ORDER BY E.EntityStatus, E.StatusDescription
  </cfquery>
  
<cfif status.recordcount eq "0">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
 				
	<tr><td colspan="2" align="center" height="60" class="labelit">   
	No records	
	</td>	
	</tr>
	
	<cfabort>

<cfelse>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">

	<cfinvoke component = "Service.Access"  
	   method           = "ServiceRequester" 
	   mission          = "#Param.TreeCustomer#"  
	   returnvariable   = "access">		   

    <cfoutput>	 
		  		
	<cfif access eq "EDIT" or access eq "ALL">		
      <tr><td height="20" colspan="2" class="labelmedium">
	  <a href="javascript:addworkorderrequest('#url.mission#','#url.domain#','0','','');javascript:showrequest('#url.mission#','#url.domain#','#status.entitystatus#','')">
	  <font color="0080C0">Add New Request</font>
	  </a>
	  </td>
	  </tr>		
	  <tr><td height="6"></td></tr>											
	</cfif>		
	</cfoutput>
	
	<cfoutput>
	<tr class="hide">
	<td id="treerefresh" 
	   onclick="ColdFusion.navigate('#SESSION.root#/System/Organization/Customer/CustomerSearchRequestTreeRefresh.cfm?mission=#url.mission#&domain=#url.domain#','treerefresh')">xxx</td>
	</tr>		
	</cfoutput>
			
	<tr><td colspan="2" valign="top">   
		
		<cfform>	
			
			<cftree name="root"
			   font="verdana"
			   fontsize="11"		
			   bold="No"   
			   format="html"    
			   required="No">   
		
			<cfoutput query="status">
			
				  <cftreeitem value="#entitystatus#"
				        display="<span style='padding-top:3px;padding-bottom:3px;color: black;' class='labelmedium'>#StatusDescription# (<a id='treestatus_#entityStatus#'><cfif counted gt 0><b></cfif>#counted#</a>)</span>"
						parent="Root"	
						href="javascript:showrequest('#url.mission#','#url.domain#','#entitystatus#','')"	
						img="#SESSION.root#/Images/folder_close.png"
						imgopen="#SESSION.root#/Images/folder_open.png"									
				        expand="No">	
												
						<cfquery name="RequestType" 
						  datasource="AppsWorkorder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						    SELECT   R.Code, 
									 R.Description
						    FROM     Request AS S INNER JOIN
						             Ref_Request AS R ON S.RequestType = R.Code 
							WHERE    S.ServiceDomain = '#url.domain#'												
						    AND      S.ActionStatus  = '#entitystatus#'							
						    GROUP BY R.Code, R.Description
							ORDER BY R.Code, R.Description
						 </cfquery>
  
  						 <cfset st= entitystatus>
				
				         <cfloop query="RequestType">
				
							  <cftreeitem value="#st#_#code#"
							        display="#Description#"
									parent="#st#"	
									img="#SESSION.root#/Images/select.png"		
									href="javascript:showrequest('#url.mission#','#url.domain#','#st#','#code#')"								
							        expand="No">	
						
						 </cfloop>
				
							
			</cfoutput>
			
			</cftree>
							
		</cfform>
		
	</td></tr>

</table>


</cfif>  

