<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Production Lot" 
			  option="Maintain Lot" 
			  banner="yellow"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	L.*,
			(SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = L.OrgUnitVendor) as OrgUnitVendorName,
			(SELECT TreeCustomer FROM Ref_ParameterMission WHERE Mission = L.Mission) as VendorTree
	FROM 	ProductionLot L
	WHERE 	L.Mission = '#url.mission#'
	AND		L.TransactionLot = '#url.lot#'
	ORDER BY L.Mission
</cfquery>

<cf_dialogOrganization>
<cf_calendarScript>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this lot?")) {	
	return true 	
	}	
	return false	
}	

</script>

<!--- edit form --->
<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&mission=#url.mission#&lot=#url.lot#" method="POST" name="dialog">

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD style="width:20%" class="labelit"><cf_tl id="Entity">:</TD>
    <TD class="labelmedium">
  	   <b>#get.Mission#</b>
	   <input type="Hidden" name="mission" id="mission" value="#get.mission#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Lot">:</TD>
    <TD class="labelmedium">
  	   <b><cfif get.TransactionLot neq '0'>#get.TransactionLot#</cfif></b>
	    <input type="Hidden" name="TransactionLot" id="TransactionLot" value="#get.TransactionLot#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Date">:</TD>
    <TD class="labelit">
		<cfset vDate = now()>
		<cfif get.TransactionLotDate neq "">
			<cfset vDate = get.TransactionLotDate>
		</cfif>
		
		<cf_intelliCalendarDate9
			FieldName="TransactionLotDate" 
			Default="#dateformat(vDate, '#CLIENT.DateFormatShow#')#"
			AllowBlank="False"
			Class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Vendor">:</TD>
    <TD class="labelit">
	
  	 
	   <cfinput type="text"  name="referencename1" class="regularxl" value="#get.OrgUnitVendorName#" size="40" maxlength="60" required="Yes" message="please select a valid vendor." readonly>
	   <input type="hidden" name="referenceorgunit" id="referenceorgunit" value="#get.orgunitvendor#">
	   
	   <input type="hidden" name="mission1" id="mission1" class="disabled" size="20" maxlength="20" readonly>		   	   
	   <input type="hidden" name="orgunitcode1" id="orgunitcode1">
  	   <input type="hidden" name="orgunitclass1" id="orgunitclass1">
	   
	     <img src="#SESSION.root#/Images/contract.gif" alt="Select vendor" name="img1" 
		  onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
		  onMouseOut="document.img1.src='#SESSION.root#/Images/contract.gif'"
		  style="cursor: pointer;" alt="" width="17" height="18" border="0" align="absmiddle" 
		  onClick="selectorgsinglemission('dialog','referenceorgunit','orgunitcode1','mission1','referencename1','orgunitclass1','','#get.VendorTree#','')">

    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Reference">:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="Reference" 
		   value="#get.Reference#" 
		   message="please enter a reference" 
		   required="no" 
		   size="30" 
	       maxlength="20" 
		   class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Memo">:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="Memo" 
		   value="#get.memo#" 
		   message="please enter a memo" 
		   required="no" 
		   size="30" 
	       maxlength="80" 
		   class="regularxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td height="6"></td></tr>	
			
	<tr>
		
	<td align="center" colspan="2">	
		<cfquery name="CountRec" 
	      datasource="appsMaterials" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT 	*
	      FROM   	ItemTransaction
	      WHERE  	Mission 		= '#get.Mission#'
		  AND		TransactionLot  = '#get.TransactionLot#'
	    </cfquery>
		<cfif CountRec.recordCount eq 0>
		    <input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
		</cfif>
    	<input class="button10g" type="submit" name="Update" id="Update" value="Save">
	</td>	
	</tr>
	
</TABLE>

</CFFORM>
	
<cf_screenbottom layout="innerbox">
