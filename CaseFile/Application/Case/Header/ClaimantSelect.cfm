<!---
	
	---------------------------------------------------------------
	This template was deployed by the Promisan Dev CM tool
	---------------------------------------------------------------
	Owner : SysAdmin
	ObservationNo : SysAdmin0013
	Date : 28/03/2012 18:30
	Officer : Prosis Administrator 
	---------------------------------------------------------------
	
---> 

	<cfquery name="Get" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Claim
		WHERE    ClaimId = '#URL.ClaimId#'	
	</cfquery>	
	
	<cfquery name="Type" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ClaimType
		WHERE    Code = '#URL.ClaimType#'	
	</cfquery>	
	
	<cfif Type.Claimant eq "Employee">
	
		<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Person
				WHERE PersonNo = '#get.PersonNo#'	
		</cfquery>
 						
		  <cfset link = "#SESSION.root#/casefile/application/Case/Header/getPerson.cfm?mode=#type.claimant#">	
		  
		  <cfoutput>	
		  		
		  <table width="100%">
		  
		  <tr>
			  
			  <td style="width:20px;padding-left:1px">
		  	
			   <cf_selectlookup
					    box        = "employeebox"
						link       = "#link#"
						button     = "Yes"
						close      = "Yes"						
						icon       = "contract.gif"
						iconheight = "19"
						iconWidth  = "18"
						class      = "employee"
						des1       = "PersonNo">
						
				</td>	
				
				<td width="99%" style="padding-left:3px">
					<cf_securediv bind="url:#link#&personno=#get.PersonNo#&dependentid=#get.Dependentid#&mode=#type.claimant#" id="employeebox">
				</td>
			</tr>	
															
		</table>	
		
		</cfoutput>	
		
	<cfelseif Type.Claimant eq "Dependent">
			
		<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Person
				WHERE PersonNo = '#get.PersonNo#'	
		</cfquery>
 						
		  <cfset link = "#SESSION.root#/casefile/application/Case/Header/getPerson.cfm?mode=#type.claimant#">	
		  
		  <cfoutput>	
		
		  <table width="100%" cellspacing="0" border="0" cellpadding="0">
		  
		  <tr>
			  
			  <td style="padding-left:2px">
		  	
			   <cf_selectlookup
					    box        = "employeebox"
						link       = "#link#"
						button     = "Yes"
						close      = "Yes"						
						icon       = "contract.gif"
						iconheight = "17"
						class      = "employee"
						des1       = "PersonNo">
						
				</td>	
				
				<td width="99%" style="padding-left:3px">
				<cf_securediv bind="url:#link#&personno=#get.PersonNo#&dependentid=#get.Dependentid#&mode=#type.claimant#" id="employeebox">
				</td>
			</tr>	
									
			<tr>
				<td colspan="2" height="25" class="labelmedium"><cf_tl id="Dependent">:</td>
			</tr>
			<tr>	
				<td colspan="2" style="padding-left:2px">
												
				<cf_securediv bind="url:../Header/getDependent.cfm?personno=#get.personno#&dependentid=#get.Dependentid#" id="dependent">
				
				</td>
			</tr>
												
		</table>	
		
		</cfoutput>	
				
	<cfelse>	
	
		<table width="100%">
		  
		<tr>
		 
		  <td width="20">	

			<cfquery name="OrgUnit" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Organization
					WHERE OrgUnit = '#get.OrgUnitClaimant#'	
			</cfquery>
			
			<cfoutput>			
							
			   <img src="#Client.VirtualDir#/Images/contract.gif" alt="Select person" name="img6" 
				  onMouseOver="document.img6.src='#Client.VirtualDir#/Images/button.jpg'" 
				  onMouseOut="document.img6.src='#Client.VirtualDir#/Images/contract.gif'"
				  style="cursor: pointer;" 
				  alt="" 
				  width="24" 
				  height="25" border="0" align="absmiddle" 
				  onClick="selectorgmis('webdialog','orgunitclaimant','orgunitcodecustomer','missioncustomer','orgunitnamecustomer','orgunitclasscustomer','#url.tree#','')">
				  			
				</td>
				 <td width="99%" style="padding-left:2px">	
				<input type="text" name="orgunitnamecustomer" id="orgunitnamecustomer" value="#OrgUnit.orgunitname#" class="regularxl" size="50" maxlength="60" readonly>	
				<input type="hidden" name="orgunitclasscustomer" id="orgunitclasscustomer" value="#OrgUnit.orgunitclass#" class="regularxl" size="15" maxlength="15" readonly> 
			   	<input type="hidden" name="orgunitclaimant" id="orgunitclaimant" value="#OrgUnit.orgunit#">
				<input type="hidden" name="orgunitcodecustomer" id="orgunitcodecustomer" value="#OrgUnit.orgunitCode#">
				<input type="hidden" name="missioncustomer" id="missioncustomer" value="#URL.tree#">	
				</td>
					
		    </cfoutput>	
		
		  </td>
		</tr>
		
		</table>	

	</cfif>
	
