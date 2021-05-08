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
	
<table width="96%" align="center">
  <tr>
    <td valign="middle" colspan="6" style="height:45" class="labellarge"><cf_tl id="Contact"> / <cf_tl id="Address"></td>
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
  
  <table border="0" width="100%" class="navigation_table">
	
	  <TR height="25px" class="line labelmedium2 fixrow">
	    <td width="3%"></td>
	    <td width="20%"><cf_tl id="Type"></td>
		<cfif url.scope neq "portal">
		<td width="40" style="padding-right:10px"><cf_tl id="Color"></td>
		</cfif>
		<TD width="20%"><cf_tl id="Contact"></TD>
		<TD width="30%"><cfif URL.scope neq "Portal"><cf_tl id="Address"></cfif></TD>
		<TD width="15%"><cfif URL.scope neq "Portal"><cf_tl id="City"></cfif></TD>
		<TD width="15%"><cfif URL.scope neq "Portal"><cf_tl id="Country"></cfif></TD>	
		<TD style="width:100px"><cfif URL.scope neq "Portal"><cf_tl id="Created"></cfif></TD>	
	  </TR>
  	  
	<cfset last = '1'>
	
	<cfif Search.recordcount eq "0">
	
		<tr><td colspan="7" style="height:50px" class="labelmedium" align="center"><cf_tl id="There are no records to show in this view" class="message"></td></tr>
	
	</cfif>
	
		<cfoutput query="Search">
		
		<TR class="labelmedium2 navigation_row" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
		<td align="center" height="20" width="30" style="padding-left:4px;padding-top:1px;padding-right:4px">
							
			<cfif url.scope eq "backoffice" AND (access eq "EDIT" or access eq "ALL")>
			
				<cf_img icon="open" navigation="yes" onclick="javascript:edit('#url.id#','#addressid#')">
				
			</cfif>
			
		</td>	
		
		<td>#Description#</td>
		
		<cfif url.scope neq "portal">
		<td>
			<table border="1" bordercolor="gray" height="14" width="14"><tr><td bgcolor="#markercolor#"></td></tr></table>
		</td>
		</cfif>
		
		<TD>	
		<cfif PersonNo neq "" AND url.scope eq "backoffice">
		<a href="javascript:EditPerson('#PersonNo#')">
		</cfif>
		#Contact#</a>
		</TD>
			
		<td><cfif URL.scope neq "Portal">#Address1#</cfif></td>
		<td><cfif URL.scope neq "Portal">#City# [#PostalCode#]</cfif></td>
		<td><cfif URL.scope neq "Portal">#Name#</cfif></td>
		<td style="padding-right:3px">
			<cfif URL.scope neq "Portal">
				<cfif operational eq "0">
					<font color="FF0000">
					</cfif>
					#dateformat(Created,client.dateformatshow)#				
			</cfif>
		</td>
		
		<cfif URL.scope neq "Portal">	
		
			</TR>
		
			<cfif Address2 neq "">			
			<TR class="labelmedium2" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#">
			<td colspan="2"></td>
			<td colspan="6" align="left">#Address2#</td>
			</cfif>
			
		</cfif>
		
		<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F4F4F4'))#" class="navigation_row_child">
		
		    <td></td>
			<td colspan="7" align="left">
			
			<table>
				
				<cfif TelephoneNo is not "">
				  <tr class="labelmedium2">
				  <td width="60"><cf_tl id="Tel">:</td>
				  <td><font color="6688aa">#TelephoneNo#</font></td>
				  </tr>
				</cfif>
				<cfif FaxNo is not "">
				  <tr class="labelmedium2">
				  <td><cf_tl id="Fax">:</td>
				  <td>#FaxNo#</td>
				  </tr>		 
				</cfif>
				<cfif eFaxNo is not "">
				  <tr class="labelmedium2">
				  <td><cf_tl id="eFax">:</td>
				  <td>#eFaxNo#</td>
				  </tr>		 
				</cfif>
				
				<cfif eMailAddress is not "">
				   <tr class="labelmedium2"><td><cf_tl id="Mail">:</td>
				       <td><a href="mailto:#eMailAddress#">#eMailAddress#</a></td>
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