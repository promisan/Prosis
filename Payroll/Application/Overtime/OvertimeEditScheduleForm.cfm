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

<cf_tl id="Payroll"	var="1">
<cfset vYes= "#lt_text#">

<cf_tl id="Compensation CTO"	var="1">
<cfset vNo= "#lt_text#">

<cfform method="POST" name="overtimeedit">

<table><td height="1"></td></table>

<cfoutput>

		<input type="hidden" name="PersonNo"   value="#URL.ID#">
        <input type="hidden" name="OvertimeId" value="#get.OvertimeId#">
		<input type="hidden" name="status" id="status"   value="#get.status#">
		  
</cfoutput>

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
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
			 <td><font color="FF0000">:<cf_tl id="Denied"></font></td>
			</cfif>
			</tr>
			</table>
		</cfoutput>
		
    </td>
  </tr> 	
    
  <tr>
    <td width="100%">
    
	<table class="formpadding formspacing" width="97%" align="right">
	
	<cfoutput>	
						
			
	<!--- you can edit the date at this point, you have to remove the record --->
				
	<TR class="labelmedium">
    <TD><cf_tl id="Date">:</TD>
    <TD>#dateformat(Get.OvertimePeriodEnd, CLIENT.DateFormatShow)#
	
	<INPUT type="hidden" class="regularxl enterasiab" name="OvertimePeriodEnd" value="#dateformat(Get.OvertimePeriodEnd, CLIENT.DateFormatShow)#" maxLength="30" size="30">
	<INPUT type="hidden" class="regularxl enterasiab" name="Mission" value="#get.Mission#" maxLength="30" size="30">
	</td>			
	</TR>		
	   	
	<TR>
    <TD class="labelmedium"><cf_tl id="Document reference">:</TD>
    <TD>
	    <cfif get.status gte "2">
			 <cfif Get.DocumentReference eq "">--<cfelse>#Get.DocumentReference#</cfif>
		<cfelse>
			<INPUT type="text" class="regularxl enterasiab" name="DocumentReference" value="#Get.DocumentReference#" maxLength="30" size="30">
		</cfif>			
	</TD>
	</TR>
	
	<TR>
	    <td valign="top" style="padding-top:5px" class="labelmedium" style="height:30px"><cf_tl id="Schedule">:</td>
	    <td colspan="1" class="labelmedium" id="schedule">		
			<cfdiv id="divMode" bind="url:getDateSchedule.cfm?status=#get.status#&personno=#url.id#&overtimeid=#get.overtimeid#&mission=#get.mission#&seldate=#dateformat(get.OvertimePeriodEnd,client.dateformatshow)#">					
		</td>
	</TR>		
	
	<TR>
        <td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
        <TD>
		<cfif get.status gte "2">
			 <cfif Get.Remarks eq "">--<cfelse>#Get.Remarks#</cfif>
		<cfelse>
			<textarea class="regular" style="padding:3px;font-size:14px;width:90%" totlength="300"  onkeyup="return ismaxlength(this)"	rows="2" name="Remarks">#Get.Remarks#</textarea> </TD>
		</cfif>	
	</TR>
			
	<tr>
		<td class="labelmedium"><cf_tl id="Attachment">:</td>
		<td><cfdiv bind="url:OvertimeAttachment.cfm?id=#get.overtimeid#" id="att"></td>			
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

<tr><td></td></tr>

<tr><td class="line"></td></tr>  

<cfinvoke component  = "Service.Access" 
      method         = "RoleAccess"				  	
	  role           = "'LeaveClearer'"		
	  returnvariable = "manager">		   
		  
<cfif manager eq "Granted">
	<cfset access = "ALL">
<cfelse>
	<cfset access = "NONE">	
</cfif>	  		
	
 <cfif (Get.Status lte "1" and URL.Mode neq "") or access eq "all">
 
	  <cfoutput>	  
	  
	   <tr>
	  
	   <td height="34" align="center">  
	   
		   <cfif url.mode neq "workflow">
		   
		   		<cf_tl id="Back" var="1">      
			    <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="ptoken.location('EmployeeOvertime.cfm?ID=#url.id#')">
				
		   </cfif>
		   	 
		   <cf_tl id="Delete" var="1">      
		     <input class="button10g" type="button" name="Delete" value="#lt_text#" onclick="check('delete')">
			 
		   <cfif get.status lte "1"> 
			 
			     <cf_tl id="Save" var="1">      
			     <input class="button10g" type="button" name="Submit" value=" #lt_text# "  onclick="check('edit')">	              
			 
		   </cfif>	 
	   
	   </td>	
	   
	  </tr> 	

	 </cfoutput> 
	 
<cfelse>

	  <cfoutput>	
	  
	  <cfif url.mode neq "workflow">
	 	 	  
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