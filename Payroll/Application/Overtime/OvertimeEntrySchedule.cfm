<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cf_screentop label="Record overtime" height="100%" scroll="Yes" html="No" jquery="Yes" menuaccess="context">

<cf_CalendarScript>
<cf_dialogPosition>

<cf_tl id="No overtime was recorded" var="vLblError1">
<cf_tl id="No overtime was recorded" var="vLblError2">

<cfoutput>

	<script>						

		function validateSubmission() {
		
		    hr = $('##OvertimeHours').val()			
			mn = $('##OvertimeMinutes').val()		
							
			if (hr == '0') { 			
			    if (mn == '0') {				  
			//       alert('#vLblError2#');
			//	   return false	
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

<cfform action="#session.root#/Payroll/Application/Overtime/OvertimeEntrySubmit.cfm?mode=schedule&overtimeid=#rowguid#&mode=schedule" method="POST" name="OvertimeEntry">

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
	
		<tr><td height="30" align="center" class="labelmedium2">No assignment has been found for this Person</font></td></tr>
				
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
	</cfoutput>
	
	<table width="98%" align="center">
	  <tr>
	    <td width="100%" align="left" style="padding:4px" class="labellarge">
		<cfoutput>		
		    <table>
			<tr>
			<td style="padding-left:10px;padding-right:10px">
		    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Overtime.png" height="44" alt=""  border="0" align="absmiddle">
			</td>
			<td valign="bottom" style="height:45px;font-size:28px;font-weight:200"><cf_tl id="Register Overtime"></td>
			</tr>
			</table>
		</cfoutput>
	    </td>
	  </tr> 	
	  
	  <tr class="hide"><td id="process"></td></tr>
	  	       
	  <tr class="line">
	    <td width="100%" class="header" style="padding-left:10px;padding-right:10px">
	    <table class="formpadding formspacing" width="95%" align="center">
		
	    <tr><td height="5"></td></tr>
		
		<cfoutput>	
		
		<cf_verifyOnboard personNo = "#URL.ID#">
										
		 <script>
		 
		 	function selectiondate() {		
								 	
				var selectedDate = datePickerController.getSelectedDate('OvertimePeriodEnd');
			    // trigger a function to set the cf9 calendar by running in the ajax td									 
			    _cf_loadingtexthtml="";				    
			    ptoken.navigate('#SESSION.root#/Payroll/Application/Overtime/getDateSchedule.cfm?personno=#url.id#&overtimeid=#rowguid#&mission='+document.getElementById('mission').value+'&thisdate='+selectedDate,'schedule')					  										   
			 }
			
	     </script>		
		
		<cfif mission eq "">
		
			<TR class="line">
		    <TD style="width:200px" class="labelmedium2"><cf_tl id="Entity">:</TD>
		    <td>
			
				<table>
				<tr>
				<td>				
				<select name="mission" id="mission" class="regularxxl" onchange="javascript:selectiondate()">
				    <cfloop query="MissionList">
					<option value="#Mission#">#Mission#</option>
					</cfloop>
				</select>	
				
				</td>
				
				<TD style="padding-left:10px;min-width:100px" class="labelmedium2"><cf_tl id="Date">:</TD>
				
			    <TD>				
					
						  <cf_intelliCalendarDate9
							FieldName="OvertimePeriodEnd" 						
							class="regularxxl"
							Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
							DateValidStart="#dateformat(now()-360,'YYYYMMDD')#"
							DateValidEnd="#dateformat(now()+4,'YYYYMMDD')#"
							manual="false"	
							scriptdate="selectiondate"
							AllowBlank="No">								
										
				</TD>
				
				</tr>
				
				</table>
			
			</td>
		
		<cfelse>
		
		    <TR class="line">
		    <TD class="labelmedium2" height="22"><cf_tl id="Entity">:</TD>
		    <td class="labelmedium2">
			  <table>
				  <tr class="labelmedium2">
					  <td style="font-size:20px">
					   #Mission#
					   <INPUT type="hidden" name="mission" id="mission" value="#mission#">			   
					  </td>		
					  
					  <TD style="padding-left:20px;min-width:100px" class="labelmedium"><cf_tl id="Date">:</TD>
			
					  <TD>				
							
							  <cf_intelliCalendarDate9
								FieldName="OvertimePeriodEnd" 						
								class="regularxxl"
								Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
								DateValidStart="#dateformat(now()-360,'YYYYMMDD')#"
								DateValidEnd="#dateformat(now()+4,'YYYYMMDD')#"
								manual="false"	
								scriptdate="selectiondate"
								AllowBlank="No">										
												
					   </TD>			
					  	  			  
				  </tr>
			  </table>
			</td>
			
			</tr>
		
		
		</cfif>	
						 
		</cfoutput> 
								
		<TR>
		    <td valign="top" style="padding-top:5px" class="labelmedium" style="height:30px"><cf_tl id="Schedule">:</td>
		    <td colspan="1" class="labelmedium2" id="schedule">		
				<cf_securediv id="divMode" bind="url:getDateSchedule.cfm?personno=#url.id#&mission={mission}&seldate={OvertimePeriodEnd}&overtimeid=#rowguid#">					
			</td>
		</TR>
				
		<TR>
	    <TD class="labelmedium2"><cf_tl id="Reference">:</TD>
	    <TD colspan="1">
		<INPUT type="text" class="regularxl" name="DocumentReference" class="regularxxl" maxLength="30" size="30">		
		</TD>
		</TR>
						
		<tr><td class="labelmedium2"><cf_tl id="Review by">:<font color="FF0000">*</font></td>			  
		    <td colspan="1">		
			  
		   	  <cf_securediv bind="url:#session.root#/Payroll/Application/Overtime/getReviewer.cfm?FieldName=FirstReviewerUserId&Id=#URL.ID#&mission={mission}" id="FirstReviewerUserId">
		    </td>
  	    </tr>	
		
		<tr><td class="labelmedium"><cf_tl id="Second review by">:<font color="FF0000">*</font></td>			  
		    <td>		   
		   	  <cf_securediv bind="url:#session.root#/Payroll/Application/Overtime/getReviewer.cfm?FieldName=SecondReviewerUserId&Id=#URL.ID#&mission={mission}" id="SecondReviewerUserId">
		    </td>
  	    </tr>	
							   
		<TR>
	        <td class="labelmedium2" width="140" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
	        <TD colspan="1" style="padding-right:0px"><textarea style="padding:3px;font-size:14px;width:100%" cols="50" class="regular" rows="3" name="Remarks" totlength="300" onkeyup="return ismaxlength(this)"></textarea> </TD>
		</TR>
		
		<cf_filelibraryscript>
			
			<tr>
				<td class="labelmedium"><cf_tl id="Attachment">:</td>
				<td colspan="1" style="padding-right:42px"><cf_securediv bind="url:OvertimeAttachment.cfm?id=#rowguid#" id="att"></td>			
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