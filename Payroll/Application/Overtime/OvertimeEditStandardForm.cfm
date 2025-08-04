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
<cfquery name="Trigger" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_PayrollTrigger
	WHERE  TriggerGroup = 'Overtime'
</cfquery>

<cfquery name="Get" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonOvertime
	WHERE  OvertimeId = '#URL.ID1#'
</cfquery>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     OrganizationObject
	WHERE    ObjectKeyValue4 = '#get.Overtimeid#'	
</cfquery>

<cfinvoke component  = "Service.Access" 
      method         = "RoleAccess"				  	
	  role           = "'LeaveClearer'"		
	  returnvariable = "manager">		   

<cfif get.status gte "5"> <!--- status is 5 or 9 --->
	<cfset access = "NONE">		  
<cfelseif manager eq "Granted">
	<cfset access = "ALL">
<cfelse>
	<cfset access = "NONE">	
</cfif>

<cf_tl id="Payroll"	var="1">
<cfset vYes= "#lt_text#">

<cf_tl id="Compensation CTO"	var="1">
<cfset vNo= "#lt_text#">

<cfform method="POST" name="overtimeedit">


<cfoutput>

	<input type="hidden" name="PersonNo"           value="#URL.ID#">
    <input type="hidden" name="OvertimeId"         value="#get.OvertimeId#">
	<input type="hidden" name="status" id="status" value="#get.status#">
		  
</cfoutput>

<table width="96%" align="center">
  <tr>
    <td width="100%" height="40" align="left" style="padding-left:4px" valign="middle" class="labellarge">
	
	<cfoutput>		
		    <table><tr><td style="padding-left:10px">
		    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Overtime.png" height="48" alt=""  border="0" align="absmiddle">
			</td>
			<td valign="bottom" style="font-weight:200;height:40px;font-size:28px;padding-left:10px">
		    	<cfif get.status eq "0">
		    	<cf_tl id="Overtime record">
				<cfelseif get.status eq "1">
				<cf_tl id="Process overtime">		
				<cfelse>
				<cf_tl id="Overtime record">		
				</cfif>
			</td>
			<cfif get.Status eq "9">
			 <td style="padding-left:3px"><font color="FF0000">:<cf_tl id="Denied"></font></td>
			<cfelseif get.Status eq "1">
			 <td style="padding-left:3px"><font color="blue">:<cf_tl id="Submitted"></font></td> 
			<cfelseif get.Status eq "2">
			 <td style="padding-left:3px"><font color="blue">:<cf_tl id="Cleared"></font></td> 
			<cfelseif get.Status eq "3">
			 <td style="padding-left:3px"><font color="green">:<cf_tl id="Cleared"></font></td>
			<cfelseif get.Status eq "5">
			 <td style="padding-left:3px"><font color="green">:<cf_tl id="Paid"></font></td> 
			</cfif>			
			
			</tr>
			</table>
		</cfoutput>
		
    </td>
  </tr> 	
   	
  <tr>
    <td width="100%">
    
	<table class="formpadding" width="97%" align="right">
	
   	
	<cfoutput>	
										
			 <script>
		 
			 	function selectiondate() {		
								 	
					var selectedDate = datePickerController.getSelectedDate('OvertimePeriodEnd');
				    // trigger a function to set the cf9 calendar by running in the ajax td						 
				    _cf_loadingtexthtml="";
				    //ptoken.navigate('#SESSION.root#/Payroll/Application/Overtime/setCurrencyDate.cfm','setdate')					  						
				    ptoken.navigate('#SESSION.root#/Payroll/Application/Overtime/setCurrencyDate.cfm?personno=#url.id#&thisdate='+selectedDate,'setdate')
				   
				 }
			
		     </script>	
				
	<TR class="labelmedium fixlengthlist">
    <TD><cf_tl id="Period covered">:</TD>
    <TD>	
	<table cellspacing="0" cellpadding="0">
	<tr class="labelmedium"><td>
	
			<cfif get.status gte "3" and access neq "all">
				#Dateformat(Get.OvertimePeriodStart, CLIENT.DateFormatShow)#
			<cfelse>
				  <cf_intelliCalendarDate9
					FieldName    = "OvertimePeriodStart" 
					Class        = "regularxxl enterastab"
					DateValidEnd = "#dateformat(now()+1,'YYYYMMDD')#"
					Default      = "#Dateformat(Get.OvertimePeriodStart, CLIENT.DateFormatShow)#"
					AllowBlank   = "No">	
			</cfif>		
			
	    </td>
		<td>-</td>
		<td>
			<cfif get.status gte "3">
				   #Dateformat(Get.OvertimePeriodEnd, CLIENT.DateFormatShow)#
			<cfelse>
			
				  <cf_intelliCalendarDate9
					FieldName="OvertimePeriodEnd" 
					class="regularxxl enterastab"
					DateValidEnd="#dateformat(now()+20,'YYYYMMDD')#"
					Default="#Dateformat(Get.OvertimePeriodEnd, CLIENT.DateFormatShow)#"
					scriptdate   = "selectiondate"
					Manual       = "false"
					AllowBlank="No">	
					
			 </cfif>	
		</td>
		<td id="setdate"></td>
		</tr>
   	</table>
		
	</TD>
	</TR>		
	   	
	<TR class="labelmedium  fixlengthlist">
    <TD><cf_tl id="Document reference">:</TD>
    <TD>
	<cfif get.status gte "3" and access neq "all">
			 <cfif Get.DocumentReference eq "">--<cfelse>#Get.DocumentReference#</cfif>
		<cfelse>
			<INPUT type="text" class="regularxxl enterasiab" name="DocumentReference" value="#Get.DocumentReference#" maxLength="30" size="30">
		</cfif>	
		
	</TD>
	</TR>

	<cf_embedHeaderFields entitycode="EntOvertime" entityid="#get.Overtimeid#" style="height:26px">

    <TR class="labelmedium  fixlengthlist">
    <TD><cf_tl id="Mode">:</TD>
    <TD>
		
		  <cfquery name="Param" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   * 
			    FROM     Ref_ParameterMission
				WHERE    Mission = '#Object.mission#'	
		  </cfquery>
	
		<cfif get.status gte "3">
		
		    <cfif Get.OvertimePayment eq "1">#vYes#<cfelse>#vNo#</cfif>
								
		<cfelse>
		
			<cf_securediv id="divMode" bind="url:getOvertimeMode.cfm?mission=#Object.Mission#&selected=#Get.OvertimePayment#">
		
	    </cfif>	
		
	</TD>
	</TR>		

	<cfif get.status gte "3">
	
		<TR class="labelmedium" id="currencydate">
   		<TD width="120"></TD>
	    <TD width="80%">

		<!--- #Dateformat(Get.OvertimeDate, CLIENT.DateFormatShow)# ---->
		<div id="overTimeDateMY" class="regularxl"><cfoutput>#Dateformat(Get.OvertimePeriodEnd, 'MM-YYYY')#</cfoutput></div>
		
		</TD>
		</TR>
		
	<cfelse>
		
		<input type="hidden" id="OvertimeDate" name="OvertimeDate" value="#Dateformat(now()-7, CLIENT.DateFormatShow)#">
		
	</cfif>
	
	<cfif get.TransactionType eq "Correction">
	
		<cfquery name="Time" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM 	PersonOvertimeDetail
			WHERE 	OvertimeId = '#get.overtimeId#'
			AND 	PersonNo = '#get.PersonNo#'
			AND     BillingPayment = '0'
		</cfquery>
		
		<tr class="labelmedium  fixlengthlist">
		  <td><cf_tl id="Deduct Time"></td>
		  <td style="font-size:16px">		 
		  <cfif get.status gte "3" and access neq "all">
		  #numberformat(time.overtimehours,"()")#
		  <cfelse>
		  <input type="text" size="4" style="text-align:right" class="enterastab regularxxl" value="#time.overtimehours#">		  
		  </cfif>
		  hr</td>
		</tr>
		
		<cfquery name="Pay" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM 	PersonOvertimeDetail
			WHERE 	OvertimeId = '#get.overtimeId#'
			AND 	PersonNo = '#get.PersonNo#'
			AND     BillingPayment = '1'
		</cfquery>
		<tr class="labelmedium">
		<td><cf_tl id="Issue for payment"></td>
		<td style="font-size:16px">		
		<cfif get.status gte "3" and access neq "all">
		   #pay.overtimehours#
		<cfelse>
		  <input type="text" size="4" value="#pay.overtimehours#" style="text-align:right" class="enterastab regularxxl" name="Pay">
		</cfif>
		hr</td>
		</tr>
		
	<cfelse>
		
	<tr class="labelmedium  fixlengthlist">						
	    <TD valign="top" style="padding-top:4px"><cf_tl id="Overtime">(HH:MM):</TD>
	    <TD valign="top">
		  <cfif get.status gte "2">
		  <cf_securediv id="overtimecontent" bind="url:setOvertime.cfm?payment=#get.overtimepayment#&personno=#url.id#&overtimeid=#url.id1#&accessmode=view">	
		  <cfelse>
		  <cf_securediv id="overtimecontent" bind="url:setOvertime.cfm?payment=#get.overtimepayment#&personno=#url.id#&overtimeid=#url.id1#&accessmode=edit">	
		  </cfif>
		</td>
				
	</TR>	
	
	</cfif>
	
	<TR class="labelmedium  fixlengthlist">
        <td valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
        <TD>
		<cfif get.status gte "3" and access neq "all">
			 <cfif Get.Remarks eq "">--<cfelse>#Get.Remarks#</cfif>
		<cfelse>
			<textarea class="regular" style="padding:3px;font-size:14px;width:90%" totlength="300"  onkeyup="return ismaxlength(this)"	rows="2" name="Remarks">#Get.Remarks#</textarea> </TD>
		</cfif>	
	</TR>
			
	<tr class="labelmedium  fixlengthlist">
		<td><cf_tl id="Attachment">:</td>
		<td><cf_securediv bind="url:OvertimeAttachment.cfm?id=#get.overtimeid#" id="att"></td>			
	</tr>	
					
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#URL.ID#' 
	</cfquery>
	
	 <cfquery name="OnBoard" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   P.*
		 FROM     PersonAssignment PA, Position P
		 WHERE    PersonNo = '#URL.ID#'
		 AND      PA.PositionNo = P.PositionNo
		 AND      PA.DateEffective < getdate()
		 AND      PA.DateExpiration > getDate()
		 AND      PA.AssignmentStatus IN ('0','1')
		 AND      PA.AssignmentClass = 'Regular'
		 AND      PA.AssignmentType = 'Actual'
		 AND      PA.Incumbency = '100' 
		 ORDER BY PA.DateExpiration DESC
	</cfquery>	
	
		<input type="hidden" 
		   name="workflowlink_<cfoutput>#Get.OvertimeId#</cfoutput>" 
		   id="workflowlink_<cfoutput>#Get.OvertimeId#</cfoutput>" 	   
		   value="OvertimeWorkflow.cfm">	
		   
		<input type="hidden" 
		   name="workflowcondition_<cfoutput>#Get.OvertimeId#</cfoutput>" 
		   id="workflowcondition_<cfoutput>#Get.OvertimeId#</cfoutput>" 
		   value="?id=#url.id#&ajaxid=#get.overtimeid#">
	   
	 </cfoutput>    	
	   	
    </TABLE>

</td></tr>

<tr><td class="line"></td></tr>  
	
 <cfif Get.Status lte "3" or access eq "ALL">	
 
	  <cfoutput>	  
	  
	   <tr>
	  
	   <td height="34" align="center">  
	   
		   <cfif url.refer neq "workflow">
		   
		   		<cf_tl id="Back" var="1">      
			    <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="ptoken.location('EmployeeOvertime.cfm?ID=#url.id#')">
				
		   </cfif>
		   
		   <cfif access eq "ALL" or get.Status lte "1">
		   	 
		   <cf_tl id="Delete" var="1">      
		     <input class="button10g" type="button" name="Delete" value="#lt_text#" onclick="check('delete')">
			 
		   </cfif>	
		   	 
					 
		   <cfif get.status lte "2" or access eq "all"> 
		   	 
		   <cf_tl id="Save" var="1">      
		     <input class="button10g" type="button" name="Submit" value=" #lt_text# "  onclick="check('edit')">	              
			 
		   </cfif>	 
	   
	   </td>	
	   
	  </tr> 	

	 </cfoutput> 
	 
<cfelse>

	  <cfoutput>	
	  
	  <cfif url.refer neq "workflow">
	 	 	  
		   <tr>
		  
		   <td height="34" align="center">  
		   
		     <cf_tl id="Back" var="1">      
		     <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="ptoken.location('EmployeeOvertime.cfm?ID=#url.id#')">	           
		   
		   </td>	
		   
		  </tr> 	
	  
	  </cfif>

	 </cfoutput> 

</cfif>
<tr><td class="line"></td></tr>

</table>

</CFFORM>

<cfset AjaxOnLoad('doCalendar')>