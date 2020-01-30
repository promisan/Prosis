<cfparam name="url.context" default="backoffice">

<cfoutput>
	
	<cfquery name="Mission" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Ref_ParameterMission		
			WHERE Mission  = '#URL.Mission#' 		
	</cfquery>
	
	<cfquery name="Get" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Customer
			<cfif url.customerid neq "">
			WHERE CustomerId  = '#URL.CustomerId#' 
			<cfelse>
			WHERE 1=0
			</cfif>
	</cfquery>
		
	<cfquery name="Requester" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Organization
			WHERE OrgUnit = '#get.OrgUnit#'						
	</cfquery>
					
	<table cellspacing="0" cellpadding="0">
		<tr class="labelit">
		
		    <cfparam name="url.name" default="">
													
			<cfif Requester.recordcount eq "0" AND LEN(url.name) GTE "6">
			
				<td><cf_tl id="Create">:</td>
				
				<td style="padding-left:3px">			
				<input type="checkbox" name="CreateProfile" id="CreateProfile" value="1">							  
				</td>		
				
				<td align="center" style="padding-left:10px;padding-right:10px">or</td>		
				
				<td style="padding-right:10px"><cf_tl id="Select">:</td>
				
			</cfif>	  		
										
			<td>	  
				
			<input type="text"   name="mission0" id="mission0"    value="#Requester.Mission#"  class="regularxl" size="4"  maxlength="20" readonly> 
			<input type="text"   name="orgunitname0" id="orgunitname0" value="#Requester.orgunitName#" class="regularxl" size="45" maxlength="80" readonly>		
			
			<input type="hidden" name="orgunit0" id="orgunit0" value="#Requester.orgunit#">
			<input type="hidden" name="orgunitcode0" id="orgunitcode0" value="#Requester.orgunitcode#">
			
			</td>
			
			<td style="padding-left:2px">
			
			 <cfinvoke component 	= "Service.Access"  
					  method     	= "workorderprocessor" 
					  mission       = "#url.mission#" 	
					  orgunit       = "#get.orgunit#"  
					  returnvariable = "access">  
				   
			<cfif access eq "ALL" or access eq "EDIT" or url.context eq "Portal">		   
				  <cfset go = "1">
			<cfelse>			
				<cfset go = "0">
			</cfif>
			
			<cfif Requester.OrgUnit eq "" or getAdministrator(url.mission) eq "1" or go eq "1">
			
				<img src="#SESSION.root#/Images/search.png" 
				      alt="Associate Profile Record" 
					  name="img5" 
					  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
					  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
					  style="cursor: pointer;border:1px solid silver;height:25;width:24" 
					  border="0"
					  align="absmiddle" 
					  onclick="selectorgN('#mission.TreeCustomer#','','orgunit','applyorgunit','0','1','modal')">
					  
			</cfif>
				  
			</td>
			
			<td style="padding-left:2px">		
			
			<cf_tl id="Maintain" var="vMaintain">	
											  						  								   
			   <input type="button" style="width:105px" name="drill" id="drill" value="#vMaintain#" class="button10g" onClick="if (document.getElementById('orgunit0').value != '') { viewOrgUnit(document.getElementById('orgunit0').value) }">
			   
			 </td>  
		 			
		
		</tr>
	</table>	
	
</cfoutput>		