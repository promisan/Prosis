
<!--- overtime redistribution --->

<cf_screentop layout="webapp" label="Overtime correction" scroll="Yes">

<cfparam name="url.id"        default="10007">
<cfparam name="url.balanceId" default="586516">

<cf_tl id="No time was recorded" var="vLblError2">

<cfoutput>

<script language="JavaScript">

	function validateSubmission() {
			
		 hr = document.getElementById('time').value															
		 if (hr == '0' || hr == '') { 			
		    alert('#vLblError2#');
			return false										
		 }
		 
	 }
		 
</script>

</cfoutput>

<cf_assignid>

<cfform action="#session.root#/Payroll/Application/Overtime/OvertimeEntrySubmit.cfm?mode=correction&overtimeid=#rowguid#" 
     method="POST" name="OvertimeEntry">
	 
<cfoutput>	 



<table width="99%" align="center">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr          = "0">		
	      <cfset openmode     = "open"> 
		  <cfinclude template = "../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
	<tr><td style="padding-left:20px;padding-right:20px">
	
	<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *	           
	    FROM     PersonLeaveBalance
		WHERE    PersonNo  = '#url.id#' 
		AND      BalanceId = '#url.balanceid#'			
	</cfquery>
	
	<table width="100%" class="formpadding formspacing">
	
	<tr class="line">
	    <td width="100%" colspan="2" align="left" style="padding:4px;padding-top:10px" class="labellarge">
		<cfoutput>		
		    <table><tr><td style="padding-left:10px;padding-right:10px">
		    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Overtime.png" height="44" alt=""  border="0" align="absmiddle">
			</td>
			<td valign="bottom" style="height:45px;font-size:28px;font-weight:200"><cf_tl id="Register Overtime Correction"></td></tr></table>
		</cfoutput>
	    </td>
	</tr> 	
	
	<input type="hidden" name="PersonNo"            value="#url.id#">
	<input type="hidden" name="mission"             value="#get.mission#">
	<input type="hidden" name="OvertimePeriodStart" value="#dateformat(get.DateExpiration,client.dateformatshow)#">
	<input type="hidden" name="OvertimePeriodEnd"   value="#dateformat(get.DateExpiration,client.dateformatshow)#">
	<input type="hidden" name="OvertimeDate"        value="#dateformat(get.DateExpiration,client.dateformatshow)#">
	
	<tr><td></td></tr>
    <tr class="labelmedium"><td style="min-width:200px;width:20%"><cf_tl id="Entity"></td><td>#get.Mission#</td></tr>
	<tr class="labelmedium"><td><cf_tl id="Balance"></td><td>#get.Balance#</td></tr>
	<tr class="labelmedium"><td><cf_tl id="Document date"></td><td>#dateformat(get.DateExpiration,client.dateformatshow)#</td></tr>
	<tr class="labelmedium"><td><cf_tl id="Deduct Time"></td>
	                        <td><cfinput validate="float" type="text" size="4" style="text-align:right" onchange="document.getElementById('pay').value=this.value" class="enterastab regularxl" id="time" name="Time">&nbsp;hr</td>
	</tr>
	<tr class="labelmedium"><td><cf_tl id="Issue for payment"></td>
	                        <td><cfinput validate="float" type="text" size="4" style="text-align:right" class="enterastab regularxl" id="pay" name="Pay">&nbsp;hr</td>
	</tr>
	<tr class="labelmedium"><td><cf_tl id="Document Reference"></td><td><input type="text" name="DocumentReference" size="20" class="enterastab regularxl"></td></tr>
	
	
	
	<tr><td class="labelmedium"><cf_tl id="First review by">:<font color="FF0000">*</font></td>			  
		<td><cfdiv bind="url:#session.root#/Payroll/Application/Overtime/getReviewer.cfm?FieldName=FirstReviewerUserId&Id=#URL.ID#&mission={mission}" id="FirstReviewerUserId"/></td>
  	</tr>	
	
	<tr><td class="labelmedium"><cf_tl id="Second review by">:<font color="FF0000">*</font></td>			  
	    <td>		   
	   	  <cfdiv bind="url:#session.root#/Payroll/Application/Overtime/getReviewer.cfm?FieldName=SecondReviewerUserId&Id=#URL.ID#&mission={mission}" id="SecondReviewerUserId"/>
	    </td>
  	</tr>	
	
	
	<tr class="labelmedium"><td valign="top" style="padding-top:5px"><cf_tl id="Remarks"></td><td>
	<textarea style="padding:3px;font-size:14px;width:100%" cols="50" class="enterastab regular" rows="3" name="Remarks" totlength="300" onkeyup="return ismaxlength(this)"></textarea></td></tr>	
	<cf_filelibraryscript>
	<tr class="labelmedium">
		<td><cf_tl id="Attachment">:</td>
		<td style="padding-right:42px"><cfdiv bind="url:OvertimeAttachment.cfm?id=#rowguid#" id="att"></td>			
	</tr>		
	
			
	</table>
	
	</td></tr>
				
	<tr><td class="line" colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center" height="30">
		
		<cfoutput>
					
			 <cf_tl id="Reset" var="1">  
			 <input class="button10g" type="reset"  name="Reset" value="#lt_text#">
			 <cf_tl id="Save" var="1">      
		     <input class="button10g" type="submit" name="Submit" value="#lt_text#" onclick="return validateSubmission();">
			 
		</cfoutput>	 
	  
	   </td>
	</tr>
	
</table>

</cfoutput>

</cfform>

