

<cfparam name="url.val" default="">
<cfparam name="url.domain" default="customer">
<cfparam name="url.mission" default="">

<cfquery name="Param" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Ref_ParameterMission
   	  WHERE Mission = '#URL.Mission#' 	 
</cfquery> 

<!--- close the listing --->

<script language="JavaScript">
 	document.getElementById('boxlistcustomer').className = "hide"
</script>		  
		  
<cfif url.domain eq "Customer">  

	<cfquery name="getAllAccess" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT *
           FROM   Organization.dbo.OrganizationAuthorization
		   WHERE  UserAccount = '#SESSION.acc#'
		   AND    Mission     = '#url.mission#'
		   AND    Role IN ('WorkOrderProcessor')
		   AND    AccessLevel IN ('2')
	</cfquery>   
		
	
	 <cfquery name="Customer" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				
			SELECT TOP 500 *, 
			       O.OrgUnitCode, 
				   O.DateEffective, 
				   O.DateExpiration, 
				   (SELECT count(*) 
				    FROM  WorkOrder 
					WHERE CustomerId = C.CustomerId
					AND   ActionStatus <= '3') as hasWorkOrder
				   
			FROM   Customer C LEFT OUTER JOIN Organization.dbo.Organization O ON O.OrgUnit = C.OrgUnit
			
			<cfif url.mission neq "">
			WHERE  C.Mission = '#url.mission#'
			<cfelse>
			WHERE  1 = 1			
			</cfif>
				
		    <cfif getAdministrator(url.mission) eq "0" and getAllAccess.recordcount eq "0">	
			
				<cfif url.dsn eq "AppsWorkorder">
				
				
				AND (
				
				     C.OrgUnit is NULL OR C.OrgUnit = '' 

				     OR		
					 
					 <!--- processor --->			 
					
				     CustomerId IN (
					                SELECT CustomerId 
					                FROM   WorkOrder.dbo.WorkOrder
									WHERE  ServiceItem IN (
									                       SELECT ClassParameter
									                       FROM   Organization.dbo.OrganizationAuthorization
														   WHERE  UserAccount = '#SESSION.acc#'
														   AND    Mission     = '#url.mission#'
														   AND    Role IN ('WorkOrderProcessor')
														   AND    AccessLevel IN ('1','2')
														  )	
					 
					               )	
								   
					OR 
					
					<!--- limit to requester here --->
					
					C.OrgUnit IN (
					                SELECT OrgUnit 
					                FROM   Organization.dbo.Organization
									WHERE  Mission = '#param.treecustomer#'
									AND    (
									        OrgUnit IN (
									                    SELECT OrgUnit
									                    FROM   Organization.dbo.OrganizationAuthorization
														WHERE  UserAccount = '#SESSION.acc#'
														AND    Mission     = '#param.treecustomer#'
														AND    Role = 'ServiceRequester'
													  )	
											OR
											
											Mission IN 	(
									                    SELECT DISTINCT Mission
									                    FROM   Organization.dbo.OrganizationAuthorization
														WHERE  UserAccount = '#SESSION.acc#'
														AND    Role = 'ServiceRequester'
														<!--- global access --->
														AND    (OrgUnit = '0' or OrgUnit is NULL)
													  )		  
					 		               )	
										   
								)		   			
								   			    
					)			   
				</cfif>
			
			</cfif>
					
			AND   ( CustomerName LIKE '%#url.val#%' or Reference LIKE '%#url.val#%' or eMailAddress LIKE '%#url.val#%')		
			
			ORDER BY CustomerName			
			
	</cfquery>
	
		

	<cfoutput>
	
	<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
	
	<!--- access for a workorder processor with access = ALL --->
		
	<cfinvoke component = "Service.Access"  
	   method           = "workorderprocessor" 
	   mission          = "#url.mission#" 	  
	   returnvariable   = "access">
	
	<cfif access eq "ALL">
	
		<tr>
			<td class="labelmedium" style="height:30;padding-left:10px">
			<a href="javascript:showcustomer('','edit','#url.dsn#','#url.mission#')"><cf_tl id="Add Customer"></a>
		    </td>
		</tr>
		
		<tr><td class="linedotted"></td></tr>		
		<tr><td colspan="2" style="padding-left:10px" height="1" width="100%" id="newentry"></td></tr>	
			
	</cfif>
			
	<cfloop query="Customer">
	
	<cfif DateExpiration neq "" and DateExpiration lt now() and hasWorkOrder eq "0">
	
		<!--- do not show --->
	
	<cfelse>
	
		<tr class="navigation_row">
		
			<td class="navigation_action"
			   style="padding-left:10px"   width="100%" id="box#customerid#" onclick="_cf_loadingtexthtml='';Prosis.busy('yes');ColdFusion.navigate('CustomerEdit.cfm?systemfunctionid=#url.systemfunctionid#&customerid=#CustomerId#&dsn=#url.dsn#','detail')">
		
			<table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr class="cellcontent">
				<td rowspan="2" width="20"><img src="#SESSION.root#/images/pointer.gif" height="9" alt="" border="0"></td>
				<td style="cursor:pointer" class="cellcontent">
				<cfif hasWorkOrder gte 1>		
				<font color="0080C0">
				<!--- standard --->	
				#CustomerName# <cfif OrgUnit neq "">[*]</cfif>[#hasWorkOrder#]
				<cfelse>
				<font color="gray">#CustomerName# <cfif OrgUnit neq "">[*]</cfif></font>			
				</cfif>
				</td>
				</td>
				</tr>			
			</table>
			
			</td>
			
		</tr>
		
	</cfif>
		
	</cfloop>
	
	</table>
	
	</cfoutput>	

<cfelseif url.domain eq "Person">

	<cfquery name="Person" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT P.PersonNo,
			               P.IndexNo, 
						   P.FirstName, 
						   P.LastName, 
						   count(WL.WorkOrderLine) as Lines
			
			FROM    Workorder W, 
			        Employee.dbo.Person P, 
					WorkorderLine WL,
					Customer C 
					
			WHERE  W.WorkorderId = WL.WorkorderId					
			AND    C.CustomerId = W.CustomerId
			
			<cfif url.mission neq "">			
			AND    W.Mission = '#url.mission#'
			</cfif>
			AND    P.PersonNo = WL.PersonNo
			<!--- active line --->
			
			<cfif url.mode eq "Active">
			
			AND    (WL.DateExpiration is NULL or WL.DateExpiration >= getdate())
			AND    WL.Operational = 1
			
			<cfelseif url.mode eq "Expired">
			
			AND    WL.DateExpiration < getdate()
			AND    WL.Operational = 1
			
			<cfelseif url.mode eq "Disabled">
			
			AND    WL.Operational = 0 
			
			<cfelse>
			
			</cfif>
						
			AND    WL.ServiceDomain is NOT NULL
			
			<cfif getAdministrator(url.mission) eq "0">
			
				<cfif url.dsn eq "AppsWorkorder">
				
				AND (
				
						<!--- is a processor for this service item --->
						 
						W.ServiceItem IN (
						                SELECT ClassParameter
						                FROM   Organization.dbo.OrganizationAuthorization
									    WHERE  UserAccount = '#SESSION.acc#'
										AND    Mission     = '#url.mission#'
									    AND    Role        IN ('WorkOrderProcessor','WorkOrderFunder')
										AND    AccessLevel IN ('1','2')
									   )	
									   
						OR
																		
						(
						
						    <!--- is a requester for this service item --->
							
						    W.ServiceItem IN (
						                SELECT ClassParameter
						                FROM   Organization.dbo.OrganizationAuthorization
									    WHERE  UserAccount = '#SESSION.acc#'
										AND    Mission     = '#param.treecustomer#'
									    AND    Role        = 'ServiceRequester'
									   )	
							AND
							
							<!--- is a requester for the unit of the workorder to limit
							the people to be shown here  --->
							
							(							
						        C.OrgUnit IN (
							 			SELECT OrgUnit
						                FROM   Organization.dbo.OrganizationAuthorization
									    WHERE  UserAccount = '#SESSION.acc#'
									    AND    Role = 'ServiceRequester'
										AND    Mission = '#param.treeCustomer#'										
									   )	

								<!--- ------------------------------------- --->	   
								<!--- pending to include also global access --->
								<!--- ------------------------------------- --->
								
							)		   
						  
						  
						)  			   
					 )							   
						    
								   
				</cfif>
			
			</cfif>
								
			AND   ( P.FullName LIKE '%#url.val#%' OR P.IndexNo LIKE '%#url.val#%')		
			
			GROUP BY P.PersonNo, P.IndexNo, P.FirstName, P.LastName
			ORDER BY P.LastName, P.FirstName			
			
	</cfquery>
	
	
	<cfoutput>
		
	<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
	
	<cfif person.recordcount eq "0">
	
	<tr><td class="labelmedium" align="center"><font size="2"><cf_tl id="No records found">.</font></td></tr>
	
	<cfelse>
	
		<cfset l  = len(url.val)>
	
		<cfloop query="Person">		
		
			<tr class="navigation_row"
			     id="row#currentrow#">

				<td height="18" width="20" style="padding-left:10px;padding-top:2px">
				
				<cf_img icon="select" navigation="yes"
				    onclick="showdomain('#url.mission#','#url.domain#','#personno#','view','#url.dsn#','#url.mode#')">
				
				</td>
				
				<cfset mt = findNoCase(url.val, lastname)>	
				
				<cfif mt gt "0" and l gt "0">
					<cfset txt = mid(lastname,mt,l)>					 
					<cfset lname = replaceNoCase(lastname, txt, "<b><u><font color='0080FF'>#txt#</font><u></b>","all")>
				<cfelse>
				   <cfset lname = lastname>
				</cfif>	
				
				<cfset mt = findNoCase(url.val, firstname)>	
					
				<cfif mt gt "0" and l gt "0">
					<cfset txt = mid(firstname,mt,l)>					 
					<cfset fname = replaceNoCase(firstname, txt, "<b><u><font color='0080FF'>#txt#</font><u></b>","all")>
				<cfelse>
				    <cfset fname = firstname>
				</cfif>	
				
				<td class="labelit" onclick="showdomain('#url.mission#','#url.domain#','#personno#','view','#url.dsn#','#url.mode#')">#lname#, #fname#</td>
				<td class="labelit">#Indexno#</td>
				<td align="right" class="labelit" style="padding-right:3px;padding-left:2px"><cfif lines gt "1">#lines#</cfif></td>
			</tr>	
							
		</cfloop>
	
	</cfif>
	
	</table>
			
	</cfoutput>	

<cfelse>

	<cfquery name="DeactivateIsValid" 
				datasource="#url.dsn#"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     TOP 1 *
				FROM       Ref_ServiceItemDomain R INNER JOIN
			               ServiceItem S ON R.Code = S.ServiceDomain INNER JOIN
			               ServiceItemMission W ON S.Code = W.ServiceItem
				WHERE      R.AllowConcurrent = '0' AND W.Mission = '#url.mission#'    
	</cfquery>		

	<cfquery name="Domain" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 500 WL.Reference, WOS.Description, count(*) as Lines
			
			FROM   Workorder W, 
			       WorkorderLine WL,
				   Customer C,
				   WorkOrderService WOS
			
			WHERE  W.WorkorderId = WL.WorkorderId
			AND    C.CustomerId = W.CustomerId
			AND	   WL.ServiceDomain = WOS.ServiceDomain
			AND	   WL.Reference = WOS.Reference
			
			<cfif url.mission neq "">
			
			AND    W.Mission = '#url.mission#'
			</cfif>
			
			<cfif url.mode eq "Active">
			
			<cfif DeactivateIsValid.recordcount gte "1">
			AND    (WL.DateExpiration is NULL or WL.DateExpiration >= getdate())
			</cfif>
			AND    WL.Operational = 1
			
			<cfelseif url.mode eq "Expired">
			
			AND    WL.DateExpiration < getdate()
			AND    WL.Operational = 1
			
			<cfelseif url.mode eq "Disabled">
			
			AND    WL.Operational = 0 
			
			<cfelse>
			
			</cfif>
						
			<cfif getAdministrator(url.mission) eq "0">
			
				<cfif url.dsn eq "AppsWorkorder">
				
				AND (
				
						<!--- is a processor for this service item --->
						 
						W.ServiceItem IN (
						                SELECT ClassParameter
						                FROM   Organization.dbo.OrganizationAuthorization
									    WHERE  UserAccount = '#SESSION.acc#'
										AND    Mission     = '#url.mission#'
									    AND    Role IN ('WorkOrderProcessor','WorkOrderFunder')
										<!--- to prevent they see access that also show other deparments --->
										AND    AccessLevel IN ('1','2')
									   )	
									   
						OR
												
						(
						
						    <!--- is a requester for this service item --->
							
						    W.ServiceItem IN (
						                SELECT ClassParameter
						                FROM   Organization.dbo.OrganizationAuthorization
									    WHERE  UserAccount = '#SESSION.acc#'
										AND    Mission     = '#param.treecustomer#'
									    AND    Role        = 'ServiceRequester'
									   )	
							AND
							
							<!--- is a requester for the unit of the workorder to limit
							the people to be shown here  --->
							
							(							
						        C.OrgUnit IN (
							 			SELECT OrgUnit
						                FROM   Organization.dbo.OrganizationAuthorization
									    WHERE  UserAccount = '#SESSION.acc#'
									    AND    Role = 'ServiceRequester'										
										AND    Mission = '#param.treeCustomer#'										
									   )
									   	

								<!--- ------------------------------------- --->	   
								<!--- pending to include also global access --->
								<!--- ------------------------------------- --->
								
							)		   
						  
						  
						)  			   
					 )							   
						    
								   
				</cfif>
			
			</cfif>
					
			
			AND    W.ServiceItem IN (SELECT Code
			                         FROM   Serviceitem 
									 WHERE  ServiceDomain = '#URL.Domain#')		 
					
			AND   ( WL.Reference LIKE '%#url.val#%' )		
									
			GROUP BY WL.Reference, WOS.Description
			ORDER BY WL.Reference, WOS.Description		
						
	</cfquery>
			
	<cfquery name="Format" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ServiceItemDomain
			WHERE  Code = '#URL.Domain#'			
	</cfquery>

	<cfoutput>
		
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfset l  = len(url.val)>
		
	<cfloop query="Domain">
	
	<tr class="navigation_row navigation_action">
	<td height="18" width="100%" id="box#currentrow#" style="padding-left:10px" >
	
		<table width="100%" cellspacing="0" cellpadding="0" onclick="showdomain('#url.mission#','#url.domain#','#reference#','view','#url.dsn#','#url.mode#')">
			
			<tr id="row#currentrow#">
			
			<td style="padding-top:3px" width="20"><cf_img icon="select"></td>
			
			<td>	
												
				<cfset mt = findNoCase(url.val, reference)>	
				
				<cfif Format.displayformat eq "">
					<cfset val = reference & ": " & description>
				<cfelse>				
				    <cf_stringtoformat value="#reference#" format="#Format.DisplayFormat#">						
				</cfif>
				
				<cfset mt = findNoCase(url.val, val)>	
					
				<cfif mt gt "0" and l gt "0">
					<cfset txt = mid(val,mt,l)>					 
					<cfset ref = replaceNoCase(val, txt, "<b><u><font color='0080FF'>#txt#</font></b></u>","all")>
				<cfelse>
				   <cfset ref = val>
				</cfif>	
				<table><tr><td style="height:20px;cursor:pointer" class="labelmedium">#ref#</td><td style="padding-left:4px"><cfif lines gt "1">[#lines#]</cfif></td></tr></table>
								
							
			</td>
			</td>
			</tr>			
		</table>
		
	</tr>
	</cfloop>
	</table>
			
	</cfoutput>

</cfif>

<cfset AjaxOnLoad("doHighlight")>	

