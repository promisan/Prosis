<cf_compression>

<cfparam name="URL.ID1" default="">

<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ItemMaster
	WHERE Code = '#URL.ID#'
</cfquery>

<cfset url.mission = get.mission>

<cfquery name="Parameters" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#url.mission#'
</cfquery>


<cfquery name="Vendors" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM ItemMasterVendor 
	WHERE Code = '#URL.ID#'
	AND OrgUnitVendor IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission= '#parameters.treevendor#')
</cfquery>

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission= '#parameters.treevendor#'
</cfquery>


<cfif url.mission neq "">

<cfoutput>
<cfif parameters.treevendor eq "" or check.recordcount eq "0">
<table width="100%"><tr><td align="center">
<font color="0080C0"><b>Attention:</b> No vendor tree or vendor nodes defined for #url.mission#</font>
</td></tr></table>
<cfabort>
</cfif>
</cfoutput>

<cfquery name="VendorList" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Organization
	WHERE Mission= '#parameters.treevendor#' 
	AND OrgUnit NOT IN (SELECT OrgUnitVendor 
	                    FROM Purchase.dbo.ItemMasterVendor 
						WHERE Code = '#URL.ID#')
        ORDER By HierarchyCode
</cfquery>


	<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
	   
	  <tr>
	    <td width="100%">
	    <table width="100%" border="0" cellpadding="0" cellspacing="0">
				   
		<cfset p = 0>
		
		<cfloop query="Vendors">
				
		<cfif URL.ID1 eq Vendors.OrgUnitVendor>
		
				<cfset p = 1>
		  		<TR onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">	
				   <td colspan="3">
				   <cfoutput>
  				    <input type="hidden" name="OldCode" id="OldCode" value="#URL.ID1#">
				   </cfoutput>			
				   
				    <select name="VendorCode" id="VendorCode">
			        	   <cfloop query="VendorList">
						<cfif parentOrgUnit eq "">
							<cfset vParent="">
						<cfelse>
							<cfset vParent="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;">
						</cfif>

						<cfif URL.ID1 eq OrgUnit>
						    	 <option value="#OrgUnit#" selected>#vparent# #OrgUnitCode# #OrgUnitName#</option>
						<cfelse>
							 <option value="#OrgUnit#">#vparent# #OrgUnitCode# #OrgUnitName#</option>
						</cfif>
					   </cfloop>
			   	   </select>							 
				   <input type="submit" value="Update" class="button7"></td>				   
				</TR>

		<cfelse>
			<cfoutput>
			<cfquery name="Details" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM Organization
				where OrgUnit='#Vendors.OrgUnitVendor#'
			</cfquery>			
			
			<TR onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
			<td width="70" height="18">#Details.OrgUnitCode#</td>
			<td width="70%">#Details.OrgUnitName#</td>
			
			<td align="right" style="padding-top:3px;">
				<cf_img icon="delete" onclick="ColdFusion.navigate('VendorEntryPurge.cfm?mission=#url.mission#&ID=#URL.ID#&ID1=#Vendors.OrgUnitVendor#','contentbox1');">
			</td>			
			</TR>
			
			</cfoutput>
			
      </cfif>
	  
	  </cfloop>
	   
	  	 
	  <cfif url.id1 eq "">
	  
	  		<TR>	
			   <td colspan="3" height="30">
							   
			    <select name="VendorCode" id="VendorCode" style="width:415px;font:10px">
				   <cfoutput>
		        	   <cfloop query="VendorList">
					<cfif parentOrgUnit eq "">
						<cfset vParent="">
					<cfelse>
						<cfset vParent="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;">
					</cfif>					

				    	 <option value="#OrgUnit#">#vParent# #OrgUnitCode# #OrgUnitName#</option>
				   </cfloop>
				   </cfoutput>

		   	   </select>
				   
			   <cfoutput>
			   
				   <input type="button" value="Save" style="height:19" class="button10s" 
				   onclick="ColdFusion.navigate('VendorEntrySubmit.cfm?mission=#url.mission#&id=#url.id#&vendorcode='+VendorCode.value,'contentbox1')">
				   
			   </cfoutput>
				   
		</TR>
	</cfif>
		
	
	</TABLE>
	</TD>
	</TR>
	</TABLE>

</cfif>	
