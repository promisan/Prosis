
<cfoutput>	

	<cfparam name="url.OrgUnit" default="0">
	<cfparam name="get.OrgUnit" default="#url.orgunit#">
					
	<cfquery name="Address" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   A.*, B.Name, R.Description
		FROM     vwOrganizationAddress A 
		         INNER JOIN Ref_AddressType R ON A.AddressType = R.Code 
				 LEFT OUTER JOIN System.dbo.Ref_Nation B
		  ON     A.Country = B.Code
		WHERE    OrgUnit = '#get.orgunit#'
		ORDER BY AddressType DESC
	</cfquery>
						 
	<table border="0" cellpadding="0" cellspacing="0" width="98%" align="center" class="navigation_table formpadding">
	    
		<cfset last = '1'>
		
		<cfif Address.recordcount eq "0">
		
			<tr><td colspan="5" height="30" align="center" class="labelit"><cf_tl id="There are no records to show in this view"></td></tr>
		
		<cfelse>
		
			<TR bgcolor="white" class="line">
			    
			    <td width="15%" class="labelit" style="padding-left:4px"><cf_tl id="Type"></td>								
				<TD width="50%" class="labelit"><cf_tl id="Address"></TD>							
				<TD width="20%" class="labelit"><cf_tl id="Contact"></TD>
				<TD width="15%" class="labelit"><cf_tl id="Phone"></TD>		
				
		   </TR>
		   
	  		
		<cfloop query="Address">
		
			<TR class="linedotted navigation_row">
			
			<td class="labelit" style="height:20px;padding-left:4px">#Description#</td>			
			<td class="labelit">#Address1# <cfif city neq "" and city neq address1>#City#</cfif> <cfif postalcode neq "">[#PostalCode#]</cfif>, #Name#</td>										
			<TD class="labelit">#Contact#</TD>			
			<td class="labelit">#TelephoneNo#</td>			
			
			</TR>
			
			<cfif Address2 neq "">
				<TR>
				<td colspan="1"></td>
				<td class="labelit" colspan="3" align="left">#Address2#
				</td>
			</cfif>
			
			<cfif FaxNo is not "" or eMailAddress is not "">
		
			<TR>
				<td></td>
			
				<td class="labelit" colspan="3" align="left">			
				
				<cfif FaxNo is not "">
				  <cf_tl id="Fax">:<b>#FaxNo#</font>
				</cfif>
				<cfif eMailAddress is not "">
				  &nbsp;<a href="mailto:#eMailAddress#"><font color="0080C0">#eMailAddress#</a></b>
				</cfif>		
				</td>
				
			</TR>
			
			</cfif>
								
		</cfloop>
		
		</cfif>
	
	</TABLE>
	
</cfoutput>	

<cfset ajaxonload("doHighlight")>