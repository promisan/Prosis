
<!---
<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Traveller" 
			  banner="blue"
			  menuClose="no"
			  menuAccess="Yes">
			  --->
			  
<cfquery name="Requisition" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
    FROM 	RequisitionLine	
	WHERE 	RequisitionNo = '#url.RequisitionNo#'	
</cfquery>			  
  
<cfquery name="Get" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
    FROM 	RequisitionLineBeneficiary 
	<cfif url.beneficiaryid eq "">
	WHERE 1=0
	<cfelse>
	WHERE 	BeneficiaryId = '#url.beneficiaryid#'
	</cfif>
</cfquery>


<!--- edit form --->

<cfform action="#session.root#/procurement/application/requisition/travel/beneficiary/BeneficiarySubmit.cfm?requisitionno=#url.requisitionno#&beneficiaryid=#url.beneficiaryid#&access=#url.access#" method="POST" name="beneficiaryform">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <input type="hidden" name="PersonNo" id="PersonNo" value="#get.PersonNo#">
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Last name"> :</TD>
    <TD class="regular">
  	   <table>
	   		<tr>
				<td>
					 <cfinput type="text" 
				       name="lastname" 
					   value="#get.lastname#" 
					   message="please enter a last name" 
					   required="yes" 
					   size="30" 
				       maxlength="40" 
					   class="regularxl">
				</td>
				<td style="padding-left:10px;">
					<cf_tl id="Search person" var="1">
					<img src="#session.root#/images/Search-R.png" style="cursor:pointer; height:30px;" title="#lt_text#" onclick="lookupperson('#Requisition.mission#','parent.opener.selectBeneficiary')">
					<div id="divGetBeneficiary" style="display:none;"></div>
				</td>
			</tr>
	   </table>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="First name"> :</TD>
    <TD class="regular">
  	   
	    <cfinput type="text" 
	       name="firstname" 
		   value="#get.firstname#" 
		   message="please enter a first name" 
		   required="no" 
		   size="30" 
	       maxlength="30" 
		   class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Nationality"> :</TD>
    <TD class="regular">
  	   <cfquery name="GetNation" 
		datasource="appsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT	*
				FROM	System.dbo.Ref_Nation
				WHERE	Operational = '1'
		</cfquery>
		
		<select name="nationality" id="nationality" class="regularxl">
			<option value="">-- <cf_tl id="Nationality"> --</option>
			<cfloop query="getNation">
				<option value="#Code#" <cfif get.nationality eq code>selected</cfif>>#Name#</option>
			</cfloop>
		</select>
	    
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Birth date"> :</TD>
    <TD class="regular">
  	   
	    <cf_intelliCalendarDate9
			FieldName="birthdate"
			class="regularxl"
			Message="Select a valid Birth Date"
			Default="#dateformat(get.birthdate, CLIENT.DateFormatShow)#"
			AllowBlank="false">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Passport"> :</TD>
    <TD class="regular">
  	   
	    <cfinput type="text" 
	       name="reference" 
		   value="#get.reference#" 
		   message="please enter a passport" 
		   required="no" 
		   size="30" 
	       maxlength="20" 
		   class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="6"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td height="6"></td></tr>	
			
	<tr>
		
	<td align="center" colspan="2">	
		<cf_tl id="Save" var="1">
    	<input class="button10g" type="submit" name="Save" id="Save" value="#lt_text#">
	</td>	
	</tr>
	
	</cfoutput>
	
</table>

</cfform>
	
<cfset ajaxonload("doCalendar")> 