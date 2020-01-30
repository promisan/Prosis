<cfoutput>

<cfset url.mode = "Edit">

<cfquery name="Roles" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_AuthorizationRole
	  WHERE  Role IN ('ProcReqReview','ProcReqApprove')	
	  ORDER BY ListingOrder
	</cfquery>
		
	<table width="94%" align="center" border="0" cellspacing="0" cellpadding="0">
		
	<tr><td style="padding-left:10px;padding-top:15px">

	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	
	<cfset list = valueList(Roles.Role)>
	<cfset list = replaceNoCase(list,",",":","ALL")> 
				
	<cfloop query="Roles">								
				
		<tr class="linedotted">
		<td align="left" class="labellarge">
		
		<table width="100%"><tr>
		
		   <td class="labelmedium" width="70" style="height:40px;padding-left:15px"><cf_tl id="Access">:</td>
		   <td class="labellarge">		
		   
		   <cfset list = Role>	
		
		   <cfif url.mode eq "edit">

		   <font color="6688aa">
		   
		   <cfset link = "#SESSION.root#/Procurement/Application/Requisition/Authorization/AuthorizationAccess.cfm?mode=edit&Requisitionno=#url.id#&list=#list#&box=#role#">
				   
		   <cf_selectlookup
			    class    = "User"
			    box      = "#role#"
				title    = "#Description#"
				link     = "#link#"					
				dbtable  = "RequisitionLineAuthorization"
				des1     = "Account">
				
			</cfif>
				
				</td>
				<td colspan="2" align="right" class="labelmedium" style="padding-left:10px"><font color="gray">#RoleMemo#</td>
				
				</tr></table>	
					
		</td>
		</tr>			
											
		<tr class="linedotted">
	    <td width="60%" colspan="2" align="right" style="padding-left:40px;padding-right:20px">		
			<cfdiv bind="url:#SESSION.root#/Procurement/Application/Requisition/Authorization/AuthorizationAccess.cfm?Requisitionno=#url.id#&role=#role#&mode=#url.mode#" id="#role#"/>		
		</td>
		</tr>  
				
	</cfloop>		
	
    </table>
	
	</td></tr>
	
 </table>
      
</cfoutput>