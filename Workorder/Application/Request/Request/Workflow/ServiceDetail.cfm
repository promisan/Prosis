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

<!--- ------------------------------------------------- --->
<!--- PURPOSE : worflow workorder dialog to be embedded --->
<!--- -assign the request to a user and a service id--- --->
<!--- ------------------------------------------------- --->

<cfquery name="get"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Request
	WHERE    RequestId = '#Object.ObjectKeyValue4#'	
</cfquery>		

<cfquery name="getLine"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     RequestLine
	WHERE    RequestId = '#Object.ObjectKeyValue4#'	
</cfquery>		

<cfif getLine.recordcount eq "0">
		
		<cfquery name="getLine" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT ValueFrom as Serviceitem
			FROM   RequestWorkorderDetail
			WHERE  Amendment = 'ServiceItem'
			AND    Requestid   = '#Object.ObjectKeyValue4#'						
		</cfquery>
	
</cfif> 

<cfset url.mission     = get.Mission>
<cfset url.serviceitem = getLine.ServiceItem>

<cfquery name="ServiceItem"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     ServiceItem
	WHERE    Code = '#getLine.ServiceItem#'	
</cfquery>	

<cfquery name="getAction"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_RequestWorkflow
	WHERE    RequestType = '#get.RequestType#'	
	AND      ServiceDomain = '#get.ServiceDomain#'
	AND      RequestAction = '#get.RequestAction#' 
</cfquery>	

<cfquery name="Domain"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_ServiceItemDomain
	WHERE    Code = '#ServiceItem.ServiceDomain#'	
</cfquery>					

<table width="96%" align="center" class="formpadding">
<tr><td height="10"></td></tr>
<tr><td colspan="2" height="40" class="labelit">Provide additional information before you may apply this request to the service.</td></tr>

<cfquery name="customer"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Customer
		WHERE    Customerid IN (SELECT CustomerId 
		                        FROM   Workorder 
								WHERE  Mission = '#url.Mission#' 
								AND    ServiceItem = '#url.ServiceItem#')
		AND      OrgUnit = '#get.OrgUnit#'						
	    ORDER BY CustomerName	
	</cfquery>		
	
<cfif customer.recordcount eq "0">


<cfquery name="org"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Organization.dbo.Organization
		WHERE    OrgUnit = '#get.OrgUnit#'		
	</cfquery>		

<tr><td height="20" colspan="2" class="labelmedium"><b><font color="FF0000">Problem, the assigned unit <cfoutput>#org.OrgunitName#</cfoutput> does not have an active service order for this service. Operation not allow.</td></tr>

<cfelse>

<tr><td height="20" colspan="2" class="labellarge"><b>Additional Information</td></tr>
<tr><td height="5"></td></tr>

<tr>
  <td width="100" height="30" class="labelmedium">Customer:</td>
  
  <td>	
	
	<select name="CustomerId" id="CustomerId" class="regularxl">
	<cfoutput query="Customer">
		<option value="#Customerid#" <cfif customerid eq get.CustomerId>selected</cfif>>#CustomerName#</option>
	</cfoutput>	
	</select>
      
  </td>

</tr>

<tr>
	<td height="30" class="labelmedium">Beneficiary/Assigned to:</td>
	<td>
										
		<cfset link = "../../Workorder/Application/Request/Request/Create/DocumentFormPerson.cfm?requestid=#object.objectkeyvalue4#">	
		
		<table cellspacing="0" cellpadding="0" width="96%">
			<tr>
			<td width="20">
				
			   <cf_selectlookup
			    box        = "employee"
				link       = "#link#"
				button     = "Yes"
				close      = "Yes"						
				icon       = "contract.gif"
				class      = "employee"
				des1       = "PersonNo">
					
			</td>	
			<td width="2"></td>				
			<td width="99%"><cfdiv bind="url:#link#" id="employee"/></td>
			</tr>
		</table>
		
	</td>
</tr>	
	
<cfoutput>

	<tr>
	
	  <td height="30" width="100" class="labelmedium">#Domain.Description#:</td>
	  
	  <td>	  
		  
	    <cfif getaction.pointerreference eq "2" and getaction.ServiceDomainClass neq "">
		
		<!--- only valid lines to be selected --->
		
		<cfquery name="Lines"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   DISTINCT WL.Reference
			FROM     WorkorderLine WL, Workorder W
			WHERE    W.WorkorderId         = WL.WorkOrderId
			AND      W.ServiceItem         = '#getLine.serviceitem#'
			AND      W.Mission             = '#get.Mission#'
			AND      WL.ServiceDomainClass = '#getaction.ServiceDomainClass#'
			AND      WL.DateEffective < getDate()
			AND      (WL.DateExpiration is NULL OR WL.DateExpiration >= getdate() )
			
			AND      WL.Operational        = 1
			
			AND      WL.Reference NOT IN (
			
			                <!--- service line is not pat of an open workflow --->
			
							SELECT DISTINCT WL.Reference
							FROM      RequestWorkOrder AS RWO INNER JOIN
							          WorkOrderLine AS WL ON RWO.WorkOrderId = WL.WorkOrderId AND RWO.WorkOrderLine = WL.WorkOrderLine INNER JOIN
							          Request AS R ON RWO.RequestId = R.RequestId INNER JOIN
							          Organization.dbo.OrganizationObject AS O ON R.RequestId = O.ObjectKeyValue4 INNER JOIN
							          Organization.dbo.OrganizationObjectAction AS OA ON O.ObjectId = OA.ObjectId
							WHERE     OA.ActionStatus = '0' 
							AND       WL.ServiceDomain      = '#get.ServiceDomain#'
							AND       WL.ServiceDomainClass = '#getaction.ServiceDomainClass#'
							<!--- but we exclude cancelled requests --->
							AND       R.ActionStatus <> '9'		
							AND       O.Operational = 1			
			
			)		
			
		    ORDER BY WL.Reference
			
		</cfquery>			
				
		<select name="DomainReference" id="DomainReference" style="width:200px" class="regularxl">
		
			<cfloop query="Lines">
			
				<cfif Domain.displayformat eq "">
					<cfset val = reference>
				<cfelse>
				    <cf_stringtoformat value="#reference#" format="#Domain.DisplayFormat#">						
				</cfif>		
				<option value="#Reference#" <cfif reference eq get.DomainReference>selected</cfif>>#val#</option>
					
			</cfloop>	
		
		</select>
		
		<!--- dropdown --->
		
		<cfelse>
			 		    
		<cfinput type = "Text"
	       name       = "DomainReference"
	       required   = "false"           
	       size       = "20"
		   class      = "regularxl"
		   message    = "You must define a service reference for this item #Domain.Description#"
		   value      = "#get.domainreference#"
	       maxlength  = "20">
		  		   
		</cfif>   
		      
	  </td>
	
	</tr>	
	
	<cfset url.mode = "edit">		
	<cfinclude template="ServiceDetailCustom.cfm">
	
	<tr><td colspan="2" class="line"></td></tr>
	
</cfoutput>

</cfif>

<input type="hidden" name="savecustom" id="savecustom" value="WorkOrder/Application/Request/Request/Workflow/ServiceDetailSubmit.cfm">

</table>
