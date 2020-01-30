
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<table width="100%" align="center">

	<tr><td>
		<cfinclude template="../UnitView/UnitViewHeader.cfm">
	</td></tr>
	
</table>

<script language="JavaScript">

function threshold(orgunit) {
    ptoken.location('ThresholdEntry.cfm?ID=' + orgunit);
}

function thresholdedit(id) {
   ptoken.location('ThresholdEdit.cfm?id='+id)
}

</script>

<!--- Query returning search results --->
<cfquery name="Search" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM OrganizationThreshold L
	WHERE L.OrgUnit = '#URL.ID#' 
		
</cfquery>

<table width="95%" align="center" border="0" cellspacing="0">
  <tr><td>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
  <tr>
    <td style="height:30" class="labellarge" style="padding-left:3px"><cf_tl id="Credit Threshold terms"></td>
	<cfoutput>
    <td align="right" height="30" style="padding-right:4px">
	<cfinvoke component="Service.Access"  
	          method="Org"  
			  OrgUnit="#URL.ID#" 
			  returnvariable="access">
    <cfif access eq "EDIT" or access eq "ALL">
		<cf_tl id="Add" var="vAdd">
    	<input type="button" 
		       value="#vAdd#" 
			   class="button10g" 
			   onClick="javascript:threshold('#URL.ID#')">
	</cfif>
    </td>
	</cfoutput>
   </tr>
   <tr>
  <td width="100%" colspan="2">
  
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">	  
		
	<TR class="labelmedium line">
	    <td width="5%" align="center"></td>
	    <td width="10%"><cf_tl id="Type"></td>
		<td width="15%"><cf_tl id="Effective"></td>		
		<TD width="24%"><cf_tl id="Memo"></TD>
		<TD width="13%"><cf_tl id="Officer"></TD>		
		<TD width="13%"><cf_tl id="Recorded"></TD>	
		<td width="20%" align="right"><cf_tl id="Amount"></td>
	</TR>
		
	<cfset last = '1'>
	
	<cfoutput query="Search">
			
	<tr class="labelmedium line navigation_row">
		<td align="center" height="20">
		
		     <cfinvoke component="Service.Access"  method="employee"  personno="#URL.ID#" returnvariable="access">
			 
		     <cfif access eq "EDIT" or access eq "ALL">
			  			    
		             <img src="#SESSION.root#/Images/bank.gif" alt="" name="img0_#currentRow#"
					  onMouseOver="document.img0_#CurrentRow#.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img0_#CurrentRow#.src='#SESSION.root#/Images/bank.gif'"  
					  style="cursor:pointer"
					  width="17" 
					  height="12" 
					  class="navigation_action"
					  onclick="thresholdedit('#thresholdid#')"
					  border="0" 
					  align="absmiddle">
		       
			 </cfif>  
			 
		</td>	
		<td><a href="javascript:thresholdedit('#Thresholdid#')">#ThresholdType#</a></td>
		<td>#dateformat(dateeffective,client.dateformatshow)#</td>		
		<TD>#Memo#</TD>
		<td>#OfficerLastName#</td>
		<TD style="padding-right:4px">#dateformat(created,client.dateformatshow)#</TD>	
		<td style="padding-right:4px" align="right">#currency# #numberformat(AmountThreshold,'__,__.__')#</td>
	
	</tr>
			
	</cfoutput>
	
	</TABLE>
	
	</tr>

</td>

</table>

<cfset ajaxonload("doHighlight")>