
<cfoutput>

	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	
		<tr><td height="2"></td></tr>
					
		<cfif access eq "edit">	
		
			<cfset link = "#SESSION.root#/procurement/application/requisition/beneficiary/UnitList.cfm?access=#access#||box=bunit||requisitionno=#url.RequisitionNo#">
			
			<tr><td height="20" colspan="6" align="left" class="labelit" style="padding-left:3px">
			
			   <cf_tl id="Record a Beneficiary" var="1">
			
			   <cf_selectlookup
			    class         = "Tree"
			    box           = "bunit"
				title         = "#lt_text#"
				button        = "Yes"
				Icon          = "Contract.gif"
				link          = "#link#"			
				dbtable       = "Purchase.dbo.RequisitionLineOrgUnit"
				des1          = "OrgUnit"
				filter1       = "Mission"
				filter1value  = "#Line.Mission#"
				filter2       = "MandateNo"
				filter2value  = "#Mandate.MandateNo#">
						
			</td>
			</tr> 
			
		</cfif>			
		
		<tr bgcolor="ffffff">
	    <td width="100%" colspan="2">		
			<cfdiv bind="url:#SESSION.root#/procurement/application/requisition/beneficiary/UnitList.cfm?box=bunit&requisitionno=#url.RequisitionNo#&access=#access#" 
			  id="bunit"/>		
		</td>
		</tr>  
			
	
    </table>
      
</cfoutput>