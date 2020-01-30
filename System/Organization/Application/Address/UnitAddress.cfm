<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="URL.scope"  default="backoffice"> 
<cfparam name="url.header" default="1">
<cfparam name="url.html"   default="No">
<cfparam name="url.closeAction" default="">

<cf_dialogstaffing>

<cfif url.closeAction eq "">

	<cf_screentop height="100%" scroll="Yes" html="#url.html#" layout="webapp" banner="gray" jquery="Yes" label="Edit Address">

<cfelse>

	<cf_screentop height="100%" scroll="Yes" html="#url.html#" layout="webapp" banner="gray" jquery="Yes" label="Edit Address" close="#url.closeAction#">

</cfif>

<cfif url.header eq "1">

<table width="100%" align="center">

<tr><td>
	
  <cfif URL.scope eq "Portal">
  
  	<cf_tableround mode="solidcolor" color="f0f0f0">
		<cfinclude template="../UnitView/UnitViewHeader.cfm">
	</cf_tableround>
	
  <cfelse>
    
  	<cfinclude template="../UnitView/UnitViewHeader.cfm">
	
  </cfif>
		
	</td></tr>
	
</table>
	
	<cfoutput>
	
	<cfset root = "#SESSION.root#">
	
		<script language="JavaScript">
		
		function address(persno) {
		   ptoken.location("AddressEntry.cfm?ID=" + persno +"&html=#url.html#&closeAction=#url.closeAction#&systemfunctionid=#url.systemfunctionid#");
		}
		
		function edit(id,id1) {
			ptoken.location("AddressEdit.cfm?ID="+id+"&ID1="+id1+"&header=No&html=#url.html#&closeAction=#url.closeAction#&systemfunctionid=#url.systemfunctionid#");
		}	
		
		</script>
	
	</cfoutput>

</cfif>

<!--- Query returning search results --->

<cfquery name="Search" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   A.*, B.Name, R.Description
FROM     vwOrganizationAddress A 
         INNER JOIN Ref_AddressType R ON A.AddressType = R.Code 
		 LEFT OUTER JOIN System.dbo.Ref_Nation B
  ON     A.Country = B.Code
WHERE    OrgUnit = '#URL.ID#'
<cfif url.scope neq "Backoffice">
AND      Selfservice = 1
</cfif>
ORDER BY R.ListingOrder ASC
</cfquery>

<cfif url.systemfunctionid neq "">

	<!--- we check the access the person has based on the conditions set for accessing this module function and
	see if the access of the person is for > level 1 --->
		
	<cfinvoke component="Service.Access" 
	      method="systemfunctionidaccess"  
		  systemfunctionid="#url.systemfunctionid#" 
		  mission="#org.Mission#"
		  returnvariable="access">		
		
<cfelse>

	<cfinvoke component="Service.Access" 
      method="org"  
	  orgunit="#URL.ID#" 
	  returnvariable="access">
	  
</cfif>	  
	
<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="middle" colspan="6" style="height:45" class="labellarge"><cf_tl id="Contact"> / <cf_tl id="Address"></b></font></td>
    <td align="right">
	
	<cfif url.scope eq "backoffice">
	
	    <cfoutput>	
			  
		      <cfif access eq "EDIT" or access eq "ALL">	
			  	 	<cf_tl id="Add" var="vAdd">
					<input type="button" value="#vAdd#" class="button10g" onClick="address('#URL.ID#')">
			  </cfif> 
			  
		</cfoutput>
		
	</cfif>	
    </td>
   </tr>
   <tr>
   
  <td width="100%" colspan="7">
  
  <table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">

  <TR height="25px" class="linedotted">
    <td width="3%"></td>
    <td width="20%" class="labelmedium"><cf_tl id="Type"></td>
	<cfif url.scope neq "portal">
	<td width="40" class="labelmedium" style="padding-right:10px"><cf_tl id="Color"></td>
	</cfif>
	<TD width="20%" class="labelmedium"><cf_tl id="Contact"></TD>
	<TD width="30%" class="labelmedium"><cfif URL.scope neq "Portal"><cf_tl id="Address"></cfif></TD>
	<TD width="15%" class="labelmedium"><cfif URL.scope neq "Portal"><cf_tl id="City"></cfif></TD>
	<TD width="15%" class="labelmedium"><cfif URL.scope neq "Portal"><cf_tl id="Country"></cfif></TD>	
  </TR>
  	  
	<cfset last = '1'>
	
	<cfif Search.recordcount eq "0">
	
		<tr><td colspan="7" style="height:50px" class="labelmedium" align="center"><cf_tl id="There are no records to show in this view" class="message"></td></tr>
	
	</cfif>
	
	<cfoutput query="Search">
	
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#" class="navigation_row">
	<td align="center" height="20" width="30" style="padding-left:4px;padding-top:1px;padding-right:4px">
						
		<cfif url.scope eq "backoffice" AND (access eq "EDIT" or access eq "ALL")>
		
			<cf_img icon="edit" navigation="yes" onclick="javascript:edit('#url.id#','#addressid#')">
			
		</cfif>
		
	</td>	
	
	<td class="labelmedium">#Description#</td>
	
	<cfif url.scope neq "portal">
	<td>
		<table border="1" bordercolor="gray" height="14" width="14"><tr><td bgcolor="#markercolor#"></td></tr></table>
	</td>
	</cfif>
	
	<TD class="labelmedium">	
	<cfif PersonNo neq "" AND url.scope eq "backoffice">
	<a href="javascript:EditPerson('#PersonNo#')"><font color="0080FF">
	</cfif>
	#Contact#</a>
	</TD>
		
	<td class="labelmedium"><cfif URL.scope neq "Portal">#Address1#</cfif></td>
	<td class="labelmedium"><cfif URL.scope neq "Portal">#City# [#PostalCode#]</cfif></td>
	<td class="labelmedium"><cfif URL.scope neq "Portal">#Name#</cfif></td>
	
	<cfif URL.scope neq "Portal">	
	
		</TR>
	
		<cfif Address2 neq "">
		
		<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
		<td colspan="2"></td>
		<td colspan="5" align="left" class="labelmedium">#Address2#
		</td>
		</cfif>
		
	</cfif>
	
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#" class="navigation_row_child">
	
	    <td></td>
		<td colspan="6" align="left">
		
		<table cellspacing="0" cellpadding="0" border="0">
			
			<cfif TelephoneNo is not "">
			  <tr>
			  <td class="labelsmall" width="60"><cf_tl id="Tel">:</td>
			  <td class="labelmedium"><font color="6688aa"> <b>#TelephoneNo# </font></b></td>
			  </tr>
			</cfif>
			<cfif FaxNo is not "">
			  <tr>
			  <td class="labelsmall"><cf_tl id="Fax">:</td>
			  <td class="labelmedium">#FaxNo#</font></td>
			  </tr>		 
			</cfif>
			<cfif eFaxNo is not "">
			  <tr>
			  <td class="labelsmall"><cf_tl id="eFax">:</td>
			  <td class="labelmedium">#eFaxNo#</font></td>
			  </tr>		 
			</cfif>
			
			<cfif eMailAddress is not "">
			   <tr><td class="labelsmall"><cf_tl id="Mail">:</td>
			       <td class="labelmedium"><a href="mailto:#eMailAddress#">#eMailAddress#</a></td>
			   </tr>
			</cfif>		
		</table>
		
		</td>
		
	</TR>
		
	</cfoutput>

	</TABLE>

</td>
</tr>

</table>