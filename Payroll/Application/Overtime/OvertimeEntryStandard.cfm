<cf_screentop label="record Overtime" height="100%" scroll="Yes" html="No" jquery="Yes" menuaccess="context">

<cf_CalendarScript>
<cf_dialogPosition>

<cf_tl id="No overtime was recorded" var="vLblError1">
<cf_tl id="No overtime was recorded" var="vLblError2">

<cfoutput>

	<script>
	
		function setInitDetailValue() {
			var vTotalDetailMinutes = 0;
			var vTotalDetailHours = 0;
			var vTotalDetailMinutes = 0;

			$('.clsDetailHours').each(function(){
				var vThisVal = parseInt($(this).val());
				if (vThisVal && $.trim(vThisVal) != '') {
					vTotalDetailHours = vTotalDetailHours + vThisVal;
				}
			});

			$('.clsDetailMinutes').each(function(){
				var vThisVal = parseInt($(this).val());
				if (vThisVal && $.trim(vThisVal) != '') {
					vTotalDetailMinutes = vTotalDetailMinutes + vThisVal;
				}
			});

			vTotalMinutesDetail = vTotalDetailHours * 60 + vTotalDetailMinutes;
			_cf_loadingtexthtml=''  
			ptoken.navigate('setTotal.cfm?minutes='+vTotalMinutesDetail,'total')			
			
		}
		
		function salarytrigger() {
			if ($('##payment').is(':checked')) {
			    _cf_loadingtexthtml=''  
			    ptoken.navigate('setOvertime.cfm?personno=#url.id#&payment=1','overtimecontent')				
			} else {
				_cf_loadingtexthtml=''  
			    ptoken.navigate('setOvertime.cfm?personno=#url.id#&payment=0','overtimecontent')				
			}
		}

		function compareDetailHeaderMinutes() {
			var vTotalMinutesHeader = parseInt($('##OvertimeHours').val()) * 60 + parseInt($('##OvertimeMinutes').val());
			var vTotalMinutesDetail = 0;
			var vTotalDetailHours = 0;
			var vTotalDetailMinutes = 0;

			$('.clsDetailHours').each(function(){
				var vThisVal = parseInt($(this).val());
				if (vThisVal && $.trim(vThisVal) != '') {
					vTotalDetailHours = vTotalDetailHours + vThisVal;
				}
			});

			$('.clsDetailMinutes').each(function(){
				var vThisVal = parseInt($(this).val());
				if (vThisVal && $.trim(vThisVal) != '') {
					vTotalDetailMinutes = vTotalDetailMinutes + vThisVal;
				}
			});

			vTotalMinutesDetail = vTotalDetailHours * 60 + vTotalDetailMinutes;

			return (vTotalMinutesHeader == vTotalMinutesDetail);
		}

		function validateSubmission() {
		
		    hr = $('##OvertimeHours').val()			
			mn = $('##OvertimeMinutes').val()		
							
			if (hr == '0') { 			
			    if (mn == '0') {				  
			       alert('#vLblError2#');
				   return false	
				}					
		    }
		 
		 }

	</script>
</cfoutput>

<cfquery name="MissionList" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
	SELECT  DISTINCT P.Mission
	FROM    PersonAssignment PA INNER JOIN
	        Position P ON PA.PositionNo = P.PositionNo
	WHERE   PA.PersonNo = '#url.id#'		
</cfquery>

<!--- determine reviewer defined for this role and orgunit ---> 			  
	 
<cf_assignId>

<cfform action="#session.root#/Payroll/Application/Overtime/OvertimeEntrySubmit.cfm?mode=standard&overtimeid=#rowguid#" 
     method="POST" name="OvertimeEntry">

<table width="99%" align="center">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr          = "0">		
	      <cfset openmode     = "open"> 
		  <cfinclude template = "../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
		
</table>

<cfif MissionList.recordcount eq "0">
	
	<table width="100%" align="center">
	
		<tr><td height="30" align="center" class="labelmedium">No assignment has been found for this Person</td></tr>
				
		<tr><td colspan="2" align="center" height="30">
		
			<cfoutput>
				 <cf_tl id="Back" var="1">    
			     <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="ptoken.location('EmployeeOvertime.cfm?ID=#url.id#')">			
			</cfoutput>	 
	  
	   </td>
	   </tr>
		
	</table>

<cfelse>
	
	<cfoutput>
		<input type="hidden" name="PersonNo" value="#URL.ID#">
	    <input type="hidden" name="IndexNo"  value="#URL.ID1#">
	</cfoutput>
	
	<table width="98%" align="center">
	  <tr class="line">
	    <td width="100%" align="left" style="padding:4px" class="labellarge">
		<cfoutput>		
		    <table><tr><td style="padding-left:10px;padding-right:10px">
		    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Overtime.png" height="44" alt=""  border="0" align="absmiddle">
			</td>
			<td valign="bottom" style="height:45px;font-size:28px;font-weight:200"><cf_tl id="Register Overtime"></td></tr></table>
		</cfoutput>
	    </td>
	  </tr> 	
	  	       
	  <tr>
	    <td width="100%" class="header" style="padding-left:10px;padding-right:10px">
	    <table class="formpadding formspacing" width="95%" align="center">
		
	    <tr><td height="5"></td></tr>

		<cf_verifyOnboard personNo = "#URL.ID#">

		<cfif mission eq "">
		
			<TR>
		    <TD style="width:200px" class="labelmedium"><cf_tl id="Entity">:</TD>
		    <td>
								
				<select name="mission" id="mission" class="regularxl">
				    <cfoutput query="MissionList">
					<option value="#Mission#">#Mission#</option>
					</cfoutput>
				</select>	
			
			</td>
			</tr>
		
		<cfelse>
		
		    <TR>
		    <TD class="labelmedium" height="22"><cf_tl id="Entity">:</TD>
		    <td class="labelmedium">
			   <cfoutput>#Mission#
			   <INPUT type="hidden" name="mission" id="mission" value="#mission#">
			   </cfoutput>
			</td>
			</tr>		
		
		</cfif>	
			
		<cfoutput>						
										
			 <script>
		 
			 	function selectiondate() {		
								 	
					var selectedDate = datePickerController.getSelectedDate('OvertimePeriodEnd');
				    // trigger a function to set the cf9 calendar by running in the ajax td						 
				    _cf_loadingtexthtml="";				    
				    ptoken.navigate('#SESSION.root#/Payroll/Application/Overtime/setCurrencyDate.cfm?thisdate='+selectedDate,'setdate')					  										   
				 }
			
		     </script>	
			 
			</cfoutput> 
				
		<cfinvoke component = "Service.Process.Employee.PersonnelAction"
	    	Method          = "getEOD"
	    	PersonNo        = "#url.id#"
			Mission         = "#mission#"
	    	ReturnVariable  = "EOD">	
		
		<cfset dte = eod>			
			
				
		<TR>
		    <TD style="min-width:100px" class="labelmedium"><cf_tl id="Period covered">:</TD>
		    <TD>	
			
				<table cellspacing="0" cellpadding="0">
				<tr><td>
					
					  <cf_intelliCalendarDate9
							FieldName="OvertimePeriodStart" 
							class="regularxl"
							Default="#Dateformat(now()-7, CLIENT.DateFormatShow)#"						
							DateValidStart="#dateformat(dte,'YYYYMMDD')#"	
							DateValidEnd="#dateformat(now()+7,'YYYYMMDD')#"
							AllowBlank="No">							
						
				    </td>
					
					<td style="padding-left:4px;padding-right:4px">-</td>
					<td>
					
					  <cf_intelliCalendarDate9
							FieldName="OvertimePeriodEnd" 
							class="regularxl"
							Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
							DateValidStart="#dateformat(dte,'YYYYMMDD')#"
							DateValidEnd="#dateformat(now()+4,'YYYYMMDD')#"
							manual="false"	
							scriptdate="selectiondate"
							AllowBlank="No">	
						
					</td>
					<td id="setdate"></td>
					</tr>
					
			   	</table>
				
			</TD>
		</TR>
				
		<TR>
		    <td class="labelmedium" style="height:30px"><cf_tl id="Mode">:</TD>
		    <td class="labelmedium">		
				<cfdiv id="divMode" bind="url:getOvertimeMode.cfm?mission={mission}">					
			</td>
		</TR>
		
		<tr>						
		    <td valign="top" style="padding-top:6px" class="labelmedium"><cf_tl id="Overtime">(HH:MM):</TD>
		    <td valign="top">
			  <cfdiv id="overtimecontent" bind="url:setOvertime.cfm?payment=0&personno=#url.id#">	
			</td>				
		</tr>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Reference">:</TD>
	    <TD>
		<INPUT type="text" class="regularxl" name="DocumentReference" class="regularxl" maxLength="30" size="30">		
		</TD>
		</TR>
		
		<TR class="hide" id="currencydate">
	    <TD></TD>
	    <TD>				 
		<input type="hidden" id="OvertimeDate" name="OvertimeDate" value="<cfoutput>#Dateformat(now()-7, CLIENT.DateFormatShow)#</cfoutput>">					
		</TD>
		</TR>
		
		<tr><td class="labelmedium"><cf_tl id="First review by">:<font color="FF0000">*</font></td>			  
		    <td>		   
		   	  <cfdiv bind="url:#session.root#/Payroll/Application/Overtime/getReviewer.cfm?FieldName=FirstReviewerUserId&Id=#URL.ID#&mission={mission}" id="FirstReviewerUserId"/>
		    </td>
  	    </tr>	
		
		<tr><td class="labelmedium"><cf_tl id="Second review by">:<font color="FF0000">*</font></td>			  
		    <td>		   
		   	  <cfdiv bind="url:#session.root#/Payroll/Application/Overtime/getReviewer.cfm?FieldName=SecondReviewerUserId&Id=#URL.ID#&mission={mission}" id="SecondReviewerUserId"/>
		    </td>
  	    </tr>	
														
		<cf_embedHeaderFields entitycode="EntOvertime" entityid="#rowguid#" style="height:34px">
					   
		<TR>
	        <td class="labelmedium" width="140" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
	        <TD style="padding-right:0px"><textarea style="padding:3px;font-size:14px;width:100%" cols="50" class="regular" rows="3" name="Remarks" totlength="300" onkeyup="return ismaxlength(this)"></textarea> </TD>
		</TR>
		
		<cf_filelibraryscript>
			
			<tr>
				<td class="labelmedium"><cf_tl id="Attachment">:</td>
				<td style="padding-right:42px"><cfdiv bind="url:OvertimeAttachment.cfm?id=#rowguid#" id="att"></td>			
			</tr>		
						
		<tr><td class="line" colspan="2"></td></tr>
	
		<tr><td colspan="2" align="center" height="30">
		
		<cfoutput>
		
			 <cf_tl id="Back" var="1">    
		     <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="ptoken.location('EmployeeOvertime.cfm?ID=#url.id#')">
			 <cf_tl id="Reset" var="1">  
			 <input class="button10g" type="reset"  name="Reset" value="#lt_text#">
			 <cf_tl id="Save" var="1">      
		     <input class="button10g" type="submit" name="Submit" value="#lt_text#" onclick="return validateSubmission();">
			 
		</cfoutput>	 
	  
	   </td>
	   </tr>
	   </table>
	
	</table>
	
</cfif>	

</CFFORM>

<cfset ajaxonload("doCalendar")>