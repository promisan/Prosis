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
<cf_screentop height="100%" html="No" scroll="Yes" jquery="Yes" menuaccess="context">

<HTML><HEAD>
<TITLE>Contract - Entry Form</TITLE>
</HEAD>
<body bgcolor="#FFFFFF" onLoad="window.focus();setTimeout('checking()', 500);">

<cf_dialogPosition>
<cfajaxImport>
<cf_CalendarScript>

<cfoutput>
	
	<script>
		
		var effp = ""
		var endp = ""
		
		function checking(){
		
			eff  =  document.getElementById("DateEffective").value	
			end  =  document.getElementById("DateExpiration").value		
			trg   = document.getElementById("SalaryTrigger").value	
				
			if ((eff != effp || end != endp) && (trg != ""))	{
				effp = eff
				endp = end	
				prior()
			}
			mytimer = setTimeout('checking()', 500);
		}
		
			
		function prior() {					   
		    _cf_loadingtexthtml='';	
			trg   = document.getElementById("SalaryTrigger").value										
		    ptoken.navigate('EntitlementPriorPasstru.cfm?id=#url.id#&ent=&trg='+trg,'exist')							 
		}
		
		function settrigger(val) {
		    _cf_loadingtexthtml='';	
			ptoken.navigate('setSalaryTrigger.cfm?personno=#url.id#&id='+val,'process')		
		}
			
	</script>

</cfoutput>

<cfquery name="Contract" 
datasource="AppsEmployee"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT   TOP 1 *
	    FROM     PersonContract
		WHERE    PersonNo = '#URL.ID#'
		AND      ActionStatus = '1'
		ORDER BY DateExpiration DESC		
</cfquery>

<cfquery name="Trigger" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT   S.SalarySchedule, 
		         (SELECT Description 
				  FROM   SalarySchedule 
				  WHERE  SalarySchedule = S.SalarySchedule) as ScheduleName,		        
				 C.SalaryTrigger, 
				 T.EnableAmount,
				 T.Description
	    FROM     Ref_PayrollTrigger T 
		         INNER jOIN Ref_PayrollComponent C    ON C.SalaryTrigger  = T.SalaryTrigger
				 INNER JOIN SalaryScheduleComponent S ON C.Code           = S.ComponentName
		WHERE    (
		           (T.TriggerGroup  IN ('Entitlement','Insurance') AND TriggerCondition = 'NONE')
		            OR 	
		           T.TriggerGroup IN ('Housing')
				 )  		
		AND      T.EnableContract = 0
		ORDER BY C.SalaryTrigger, S.ListingOrder		
		
</cfquery>

<!--- only show schedules that are relevant for this person ---> 

<cfquery name="Schedules" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT SalarySchedule
    FROM   SalarySchedule
	WHERE  SalarySchedule IN (SELECT SalarySchedule 
						      FROM   Employee.dbo.PersonContract
							  WHERE  PersonNo = '#URL.ID#'
							  AND    ActionStatus != '9')
	UNION 
	
	SELECT SalarySchedule
    FROM   SalarySchedule
	WHERE  SalarySchedule IN (SELECT PostSalarySchedule 
						     FROM   Employee.dbo.PersonContractAdjustment
							 WHERE  PersonNo = '#URL.ID#'
							 AND    ActionStatus != '9')						 
</cfquery>

<cf_assignId>
	
<cfform action="EntitlementEntryTriggerSubmit.cfm?entitlementId=#rowguid#" method="POST" name="EntitlementEntry" 
     onSubmit="return verify(EntitlementEntry.entitlement.value)">

<table cellpadding="0" cellspacing="0" width="99%" align="center" class="formpadding">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr      = "0">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
</table>


<cfquery name="schedule" dbtype="query">
		SELECT   DISTINCT SalarySchedule, ScheduleName
		FROM     Trigger
		<cfif quotedValueList(schedules.SalarySchedule) neq "">
		WHERE    SalarySchedule IN (#quotedValueList(schedules.SalarySchedule)#)
		<cfelse>
		WHERE  1= 0
		</cfif>		
</cfquery>

<cfif trigger.recordcount eq "0">

		<table width="100%">
				<tr>
					<td class="labellarge" style="font-weight:200;color:red; padding-top:25px; font-size:23px;" align="center">[ <cf_tl id="No recordable entitlements available for this person"> ]</td>
				</tr>
		</table>


<cfelseif schedule.recordcount eq "0">

		<table width="100%">
				<tr>
					<td class="labellarge" style="font-weight:200;color:red; padding-top:25px; font-size:23px;" align="center">[ <cf_tl id="No valid contract and/or salary schedule recorded"> ]</td>
				</tr>
		</table>

<cfelse>

		<table width="99%" border="0" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td>
		
		<cfoutput>
			<input type="hidden" name="PersonNo" value="#URL.ID#">
			<input type="hidden" name="IndexNo"  value="#URL.ID1#">
		</cfoutput>
		
		<table width="98%" align="center" border="0"  cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		  <tr>
		    <td width="100%" style="height:40px" align="left" valign="bottom" class="labellarge">
			<table><tr><td>		
			    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Entitlement.png" height="64" alt=""  border="0" align="absmiddle">	        	
			</td>
			<td valign="bottom" class="labellarge" style="font-weight:200;font-size:25px;padding-bottom:5px;padding-left:6px">
			   	<cf_tl id="Register financial entitlement">
			</td>	
			</tr></table>
		    </td>
		  </tr> 	
		  
		  <tr><td height="5"></td></tr>  
		  <tr><td class="line"></td></tr>  
		  <tr><td height="5"></td></tr>
		        
		  <tr>
		  
		    <td width="100%" style="padding-left:10px">
			
		    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
					
			<TR class="labelmedium">
		    <TD style="min-width:200;width:15%"><cf_tl id="Salary schedule">:</TD>
		    <TD style="width:85%">
			
				<table><tr><td>
							
					<cfquery name="schedule" dbtype="query">
						SELECT   DISTINCT SalarySchedule, ScheduleName
						FROM     Trigger
						WHERE    SalarySchedule IN (#quotedValueList(schedules.SalarySchedule)#)
					</cfquery>
						
					<select name="SalarySchedule" id="SalarySchedule" class="enterastab regularxl" style="width:400px">
					    <cfoutput query="schedule">
								<option value="#SalarySchedule#" <cfif contract.SalarySchedule eq SalarySchedule>selected</cfif>>#ScheduleName# (#SalarySchedule#)</option>
						</cfoutput>
					</select>
					
					</td>		
					
				</tr></table>	
				
			</td>	
				 
			</TR>	
			
			<tr class="labelmedium">
			   <td><cf_tl id="Entitlement">:</td>
			   <td><cfdiv bindonload="Yes" bind="url:getSalaryTrigger.cfm?personno=#url.id#&schedule={SalarySchedule}"/></td>			
			</tr>
			
			<tr class="hide"><td colspan="2" id="process"></td></tr>					
				
		    <TR class="labelmedium">
		    <TD width="170"><cf_tl id="Effective">:</TD>
		    <TD>
			
				  <cf_intelliCalendarDate9
					FieldName="DateEffective" 
					Scriptdate="prior"
					Class="regularxl enterastab"
					Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
					AllowBlank = "False">	
				
				</td>
			</tr>
			
			<tr class="labelmedium" id="expiration">	
				<td><cf_tl id="Expiration">:</td>
				<td>  
				
				<cf_intelliCalendarDate9
					FieldName="DateExpiration" 
					Scriptdate="prior"
					Class="regularxl enterastab"
					Default=""
					AllowBlank= "True">	
				
				</td>
				
			</TR>		
				
			<cfquery name="Currency" 
			datasource="AppsLedger"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Currency
			</cfquery>
			
			<cfif trigger.enableAmount eq "1">
			
			<TR id="enableamount" class="labelmedium regular">
			
			<cfelse>
			
			<TR id="enableamount" class="labelmedium hide">
			
			</cfif>
		    <TD><cf_tl id="Amount">:</TD>
		    <TD>
			
				<cfset cur = APPLICATION.BaseCurrency>
						
				<table cellspacing="0" cellpadding="0"><tr class="labelmedium"><td>
			
			  	<select name="Currency" size="1" class="regularxl">
				<cfoutput query="Currency">
				<option value="#Currency#" <cfif cur eq Currency>selected</cfif>>
		    		#Currency#
				</option>
				</cfoutput>
			    </select>
				
				</td>
				
				<td style="padding-left:4px">
				
			    <cfinput type="Text" class="regularxl enterastab" value="0" 
				   name="Amount" message="Please enter a correct amount" validate="float" required="Yes" size="12" maxlength="16" style="text-align: right;padding-right:4px">
				
				</td>
				
				 <TD style="padding-left:10px"><cf_tl id="Entitlement Date">:</TD>
		    	<TD style="padding-left:10px">
			
				  <cf_intelliCalendarDate9
					FieldName="EntitlementDate" 
					Scriptdate="prior"
					Class="regularxl enterastab"
					Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
					AllowBlank = "False">	
				
				</td>
				</tr>
								
								
				</table>
					
			</TD>
			</TR>		
						
		    <TR class="labelmedium">
			    <td><cf_tl id="Reference2">:</TD>
		    	<td><input type="text" name="documentReference" class="regularxl" size="20" maxlength="20"></TD>
			</TR>
					
			<TR id="dependentbox">
			   	<TD class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="Qualifying dependents">:</TD>
			    <TD id="dependentcontent" class="labelmedium">
				
				<!--- populated by ajax --->
				
				</TD>
			</TR>
			
			<cf_filelibraryscript>
			
			<tr class="labelmedium">
				<td><cf_tl id="Attachment">:</td>
				<td><cfdiv bind="url:EntitlementEntryAttachment.cfm?id=#url.id#&entitlementid=#rowguid#" id="att"></td>			
			</tr>	
			
			<TR class="labelmedium">
		        <td valign="top" style="padding-top:5px"><cf_tl id="Remarks">:</td>
		        <td><textarea class="regular" style="width:95%;height:50px" name="Remarks"></textarea> </TD>
			</TR>
			
			<tr><td></td></TR>
				
			<tr><td colspan="2" height="1" class="line"></td></tr> 
			
			<tr><td colspan="2" id="exist" align="center" style="width:80%"></td></tr>
					
		   </table>
		   
		   <tr>
		   <td height="25" colspan="2" align="center" style="padding-top:5px">
			   <input type="button" name="cancel" value="Back" class="button10g" onClick="history.back()">
			   <input class="button10g" type="submit" name="Submit" value=" Save ">  
		   </td>
		   </tr>
		
		</table>
		
		</td>
		</tr>
		
		</table>
	
</cfif>	

</CFFORM>

<script>
	prior()
</script>

