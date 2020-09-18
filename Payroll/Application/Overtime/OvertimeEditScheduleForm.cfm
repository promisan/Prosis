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

<cfform method="POST" name="overtimeedit">

<table><td height="1"></td></table>

<cfoutput>

	<input type="hidden" name="PersonNo"   value="#URL.ID#">
    <input type="hidden" name="OvertimeId" value="#get.OvertimeId#">
	<input type="hidden" name="status" id="status"   value="#get.status#">
		  
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
    
	<table class="formpadding formspacing" width="97%" align="right">
	
	<cfoutput>							
			
	<!--- you can edit the date at this point, you have to remove the record --->
				
	<TR class="labelmedium">
    <TD><cf_tl id="Schedule date">:</TD>
    <TD style="font-size:20px">#dateformat(Get.OvertimePeriodEnd, CLIENT.DateFormatShow)#	
	<INPUT type="hidden" class="regularxl enterasiab" name="OvertimePeriodEnd" value="#dateformat(Get.OvertimePeriodEnd, CLIENT.DateFormatShow)#" maxLength="30" size="30">
	<INPUT type="hidden" class="regularxl enterasiab" name="Mission" value="#get.Mission#" maxLength="30" size="30">
	</td>			
	</TR>		
	   	
	<TR>
    <TD class="labelmedium"><cf_tl id="Document reference">:</TD>
    <TD>
	    <cfif get.status gte "3" and access neq "all">
			 <cfif Get.DocumentReference eq "">--<cfelse>#Get.DocumentReference#</cfif>
		<cfelse>
			<INPUT type="text" class="regularxl enterasiab" name="DocumentReference" value="#Get.DocumentReference#" maxLength="30" size="30">
		</cfif>			
	</TD>
	</TR>
	
	<TR>
	    <td valign="top" style="padding-top:5px" class="labelmedium" style="height:30px"><cf_tl id="Schedule">:</td>
	    <td class="labelmedium" id="schedule">		
			<cf_securediv id="divMode" bind="url:getDateSchedule.cfm?status=#get.status#&personno=#url.id#&overtimeid=#get.overtimeid#&mission=#get.mission#&seldate=#dateformat(get.OvertimePeriodEnd,client.dateformatshow)#">					
		</td>
	</TR>		
	
	<TR>
        <td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
        <td>
		<cfif get.status gte "3" and access neq "all">
			 <cfif Get.Remarks eq "">--<cfelse>#Get.Remarks#</cfif>
		<cfelse>
			<textarea class="regular" style="padding:3px;font-size:14px;width:90%" totlength="300"  onkeyup="return ismaxlength(this)" rows="2" name="Remarks">#Get.Remarks#</textarea>
		</cfif>	
		</td>
	</TR>
			
	<tr>
		<td class="labelmedium"><cf_tl id="Attachment">:</td>
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

<tr><td></td></tr>

<tr><td class="line"></td></tr>  	 


 <cfif Get.Status lte "3" or access eq "ALL">
 
	  <cfoutput>	  
	  
	   <tr id="submissionline" class="hide">
	  
	   <td height="34" align="center">  	  
	   
		   <cfif url.refer neq "workflow">		   
		   		<cf_tl id="Back" var="1">      
			    <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="ptoken.location('EmployeeOvertime.cfm?ID=#url.id#')">				
		   </cfif>
		   
		   <cfif access eq "ALL" or get.Status lte "1">
		   	 
		   <cf_tl id="Delete" var="1">      
		     <input class="button10g" type="button" name="Delete" value="#lt_text#" onclick="check('delete')">
			 
		   </cfif>
			 			 
		   <cfif get.status lte "2" or access eq "ALL"> 			 
			     <cf_tl id="Save" var="1">      
			     <input class="button10g" type="button" name="Submit" value=" #lt_text# "  onclick="check('edit')">	              			 
		   </cfif>	 
	   
	   </td>	
	   
	  </tr> 	

	 </cfoutput> 
	 
<cfelse>

	  <cfoutput>	
	 	  
	  <cfif url.refer neq "workflow">
	 	 	  
		   <tr id="submissionline">		  
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