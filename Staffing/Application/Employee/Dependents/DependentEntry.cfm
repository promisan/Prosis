

<cfparam name="url.contractid" default="" >

<cf_tl id="Register family member" var="1">

<cf_screentop height="100%" label="#lt_text#" html="No" scroll="Yes" layout="webapp" banner="gray" line="no" menuaccess="context" option="Personnel Administration">

<!--- close="parent.parent.ColdFusion.Window.destroy('mydependent',true)" --->

<cf_CalendarScript>

<script>

_cf_loadingtexthtml='';

function sh(ln,fld){

     itm1  = 'SalaryTrigger'+ln
 	 fld1 = document.getElementsByName(itm1)
   	 
	 itm2  = 'DateEffective'+ln
	 fld2 = document.getElementsByName(itm2)
			 
	 itm3  = 'DateExpiration'+ln
	 fld3 = document.getElementsByName(itm3)
	 	 
	 itm4  = 'Remarks'+ln
	 fld4 = document.getElementsByName(itm4)
	 
	 itm5  = 'Group'+ln
	 fld5 = document.getElementsByName(itm5)
		 	 	 	 		 	
	 if (fld != false){
		
		 fld1[0].className = "regular";
		 fld2[0].className = "regular";	
		 fld3[0].className = "regular";	
		 fld4[0].className = "regular";
		 fld5[0].className = "regular"; 
 
	 }else{
		
		 fld1[0].className = "hide";	
	     fld2[0].className = "hide";		
		 fld3[0].className = "hide";	
		 fld4[0].className = "hide";
		 fld5[0].className = "hide"; 
		
	 }
  }
  
</script>

<cf_dialogPosition>

<cfquery name="Relationship" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_Relationship
	ORDER BY ListingOrder
</cfquery>

<cfform action="DependentEntrySubmit.cfm?action=#url.action#&contractid=#url.contractid#"
  method="POST" target="process" name="DependentEntry">
	
<cfquery name="Employee" 
     datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
       	SELECT *
        FROM Person
        WHERE PersonNo = '#URL.ID#'
</cfquery>      	

<table width="96%" align="center" class="formpadding">

<tr class="hide"><td>
   <iframe name="process" id="process" width="100%" height="80"></iframe></td>
</tr>

<tr><td>

<cfoutput><input type="hidden" name="PersonNo" value="#URL.ID#" class="regular"></cfoutput>

<table width="100%" align="center">
 
  <tr>
    <td width="100%" class="header">
	
    <table width="97%" align="center" class="formpadding formspacing">
	
    <TR><td height="4"></td></TR>		
	
	 <TR>
	     <TD class="labelmedium" width="120"><cf_tl id="Effective">:</TD>
	     <TD width="85%">

		<cfquery name="PendingContract" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   PC.*, ActionDocumentNo
			 FROM     PersonContract PC,  EmployeeAction PA
			 WHERE    PC.PersonNo    = '#URL.ID#'
			 AND      PC.Contractid  = PA.ActionSourceId 
			 AND      PC.ActionStatus = '0'			
			 and      PC.HistoricContract = '0'		 
		</cfquery>
		
		<cfif PendingContract.recordcount eq "0">		 
							 
			  <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="False"
				Message="Please enter an effective date"
				class="regularxl">	
				
		<cfelse>
				<cfoutput>
				<input type = "hidden" name="DateEffective" id="DateEffective" value="#Dateformat(PendingContract.DateEffective, CLIENT.DateFormatShow)#">
				#Dateformat(PendingContract.DateEffective, CLIENT.DateFormatShow)#	(From current pending appointment)	
				</cfoutput>
				
		</cfif>
								  
		</td>
		</tr>	
					  
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Relationship">:</TD>
    <TD>
	  	<select name="Relationship" size="1" class="regularxl">
		<cfoutput query="Relationship">
		<option value="#Relationship#">
    		#Description#
		</option>
		</cfoutput>
	    </select>
	</TD>
	</TR>	
	
	 <!--- Field: Applicant.IndexNo --->
	 <TR>
	 <TD class="labelmedium"><cfoutput><cf_tl id="Staff PersonNo"></TD>
	 <TD>	
			 	 
		<script language="JavaScript">
		
		function indexblank() {
			document.getElementById("employeeno").value = ""
			}
		
		</script>
	
				  <img src="#SESSION.root#/Images/contract.gif" alt="Select authorised unit" name="img0" 
					  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img0.src='#SESSION.root#/Images/contract.gif'"
					  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
					  onClick="selectperson('webdialog','employeeno','indexno','lastname','firstname','name','','')"
					  onClick="javascript:LocatePerson('webdialog','indexno')">
					  
					  </cfoutput>
		
			<input type="text" id="employeeno" name="employeeno" size="10" maxlength="20" readonly class="regularxl" style="text-align:center">
			
			<cfoutput>
				<img src="#SESSION.root#/images/delete5.gif" alt="" width="12" height="12" border="0" onClick="javascript:indexblank()">
			</cfoutput>
						
			<input type="hidden" id="indexno"    name="indexno" size="10" maxlength="20" readonly>
			<input type="hidden" id="name"       name="name"       size="10" maxlength="20" readonly>
		</TD>
		</TR>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Lastname">:</TD>
    <TD>
		<cfinput type="text" class="regularxl" id="lastname" name="lastname" value="#Employee.LastName#" message="Please enter a lastname" required="Yes" maxLength="40" size="40">		
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Firstname">:</TD>
    <TD>
		<cfinput type="Text" name="firstName"  id="firstname" message="Please enter a firstname" required="Yes" size="30" maxlength="30" class="regularxl">		
	</TD>
	</TR>
	
	  <!--- Field: BirthDate --->
    <TR>
    <TD class="labelmedium"><cf_tl id="Birth date">:</TD>
    <TD class="regular">
	
	  <cf_intelliCalendarDate9
			FieldName="BirthDate" 
			DateValidStart="19200101"
			class="regularxl"
			DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"
			message="Please enter a valid date of birth"
			Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
			AllowBlank="False">	
			
	</TD>
	</TR>
	
    <!--- Field: Gender --->
    <TR>
    <TD class="labelmedium"><cf_tl id="Gender">:</TD>
    <TD class="labelmedium">
	
		<INPUT type="radio" class="radiol" name="Gender" value="M" checked> <cf_tl id="Male">
		<INPUT type="radio" class="radiol" name="Gender" value="F"> <cf_tl id="Female"> 
		
	</TD>
	</TR>	
	
	<cfquery name="Beneficiary" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM Ref_Beneficiary
	</cfquery>	
	
	<TR>
	 <TD class="labelmedium"><cf_tl id="Beneficiary">:</TD>
    <TD>
	
		<table><tr><td>
	  	<select name="Beneficiary" size="1" class="regularxl">					
		<cfoutput query="Beneficiary">
		<option value="#Code#">
    		#Description#
		</option>
		</cfoutput>
	    </select>
		</td>
		
		<td style="padding-left:5px"></td>
			
			<TD style="padding-left:10px" class="labelmedium"><cf_tl id="Lives with staffmember">:</TD>
			
			<td style="padding-left:5px"><input type="radio" checked name="Housing" value="1"></td>			
			<td class="labelmedium" style="padding-left:5px"><cf_tl id="Yes"></td>
			<td style="padding-left:5px"><input type="radio" checked name="Housing" value="0"></td>			
			<td class="labelmedium" style="padding-left:5px"><cf_tl id="No"></td>
			
		</tr>
		</table>
		
	</TD>
	</TR>
	   	
	<tr>
	<TD class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</TD>
	<TD>
	    <textarea name="Remarks" totlength="300" style="font-size:14px;padding:3px;width:100%;height:40"  onkeyup="return ismaxlength(this)" class="regular"></textarea>
   	</TD>
	</tr>
			
	<cfquery name="Parameter" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Parameter	
	</cfquery>
	
	<cf_verifyOperational 
         module    = "Payroll" 
		 Warning   = "No">
		 
	<cfif operational eq "1" or Parameter.DependentEntitlement eq "1">	
	
	<tr><td colspan="2">
	
	<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr class="line labelit">
	
		<td width="15%"><cf_tl id="Entitlement"></td>
		<td width="20%"><cf_space spaces="40"><cf_tl id="Class"></TD>
		<td width="15%"><cf_space spaces="40"><cf_tl id="Group"></TD>
		<td width="15%"><cf_space spaces="38"><cf_tl id="Apply Start"></TD>
		<td width="15%"><cf_space spaces="38"><cf_tl id="Apply End"></TD>
		<td width="35%"><cf_space spaces="50"><cf_tl id="Memo"></TD>
	
	</tr>
	
	<cfloop index="itm" list="Insurance,RateInsurance,Entitlement,Dependent">
	
	<!---	
	<cfloop index="itm" list="Insurance,RateInsurance,Entitlement,Dependent,Housing">
	--->
	
		<cfquery name="Dependent" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT * 
			     FROM   Ref_PayrollTrigger R				 
			  	 WHERE  TriggerGroup = '#itm#'			
				 AND    TriggerCondition = 'Dependent'
				 
				 AND    EXISTS (
						
						<!--- show only components that can be associated to a schedule of the main person to be valid--->
				
						SELECT    'X'
						FROM      SalaryScheduleComponent SL INNER JOIN Ref_PayrollComponent C ON SL.ComponentName = C.Code
					    WHERE     C.SalaryTrigger = R.SalaryTrigger												
						AND       SL.SalarySchedule IN (SELECT  SalarySchedule
					                                    FROM    Employee.dbo.PersonContract
						                                WHERE   PersonNo        = '#url.id#' 
											    		AND     SalarySchedule  = SL.SalarySchedule
													    AND     ActionStatus IN ('0','1')
													 
													    UNION 													 
													 
													    SELECT  PostSalarySchedule
					                                    FROM    Employee.dbo.PersonContractAdjustment
						                                WHERE   PersonNo            = '#url.id#' 
													    AND     PostSalarySchedule  = SL.SalarySchedule
													    AND     ActionStatus IN ('0','1')
	 											       )																
													
						) 
						
				 <!--- 8/23/2017 additional filtering on the location --->		
				 
				 AND   (
	
						EXISTS (
						
							<!--- show only components that are not associated to a location or components associated to a location for which the person
							has a contract recorded --->
					
							SELECT    'X'
							FROM      SalaryScheduleComponentLocation SL INNER JOIN Ref_PayrollComponent C ON SL.ComponentName = C.Code
						    WHERE     C.SalaryTrigger = R.SalaryTrigger												
							AND       SL.SalarySchedule IN (
							
															SELECT   SalarySchedule
								                            FROM     Employee.dbo.PersonContract
								                            WHERE    PersonNo = '#url.id#' 
															AND      ServiceLocation = SL.LocationCode
															AND      SalarySchedule  = SL.SalarySchedule
															AND      ActionStatus IN ('0','1')  
															AND      SalarySchedule is not NULL
															
															UNION 													 
														 
														    SELECT   PostSalarySchedule
						                                    FROM     Employee.dbo.PersonContractAdjustment
							                                WHERE    PersonNo            = '#url.id#' 
														    AND      PostSalarySchedule  = SL.SalarySchedule
															AND      PostServiceLocation = SL.LocationCode
														    AND      ActionStatus IN ('0','1')	
															AND      PostSalarySchedule is not NULL												
															
															)																
														
							) 
						
						OR
						
						<!--- show components that do not have any locations defined, then it is global --->		
						
						NOT EXISTS (
						
							SELECT 'X'
						    FROM    SalaryScheduleComponentLocation SL INNER JOIN Ref_PayrollComponent C ON SL.ComponentName = C.Code
					        WHERE   C.SalaryTrigger = R.SalaryTrigger 
							
							AND     SL.SalarySchedule IN (
							
													SELECT   SalarySchedule
								                    FROM     Employee.dbo.PersonContract
								                    WHERE    PersonNo = '#url.id#' 
													AND      ServiceLocation = SL.LocationCode
													AND      SalarySchedule  = SL.SalarySchedule
													AND      ActionStatus IN ('0','1')  
													AND      SalarySchedule is not NULL
													
													UNION 													 
												 
												    SELECT   PostSalarySchedule
				                                    FROM     Employee.dbo.PersonContractAdjustment
					                                WHERE    PersonNo            = '#url.id#' 
												    AND      PostSalarySchedule  = SL.SalarySchedule
													AND      PostServiceLocation = SL.LocationCode
												    AND      ActionStatus IN ('0','1')	
													AND      PostSalarySchedule is not NULL												
													
									)		
							
							)																	
			           
					   )			 
				 
		</cfquery>
		
		<cfoutput>
				
		<cfif Dependent.recordcount gte "1">
			
			<cfset tag = left(itm,1)>
			<cfset line = "1">
			
			
			<tr><td></td></tr>
				
			<tr>
				
				<TD style="width:10%">
				
					<table cellspacing="0" cellpadding="0">
					<tr><td class="labelmedium">			
						<input type="checkbox" class="radiol" name="#tag#" value="1" onClick="sh('#tag#b',this.checked)">
						</td>
						<td class="labelmedium" style="padding-left:4px;padding-right:8px">
						
						<cfquery name="getLabel" 
					     datasource="AppsPayroll" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
							 SELECT * 
							 FROM   Ref_TriggerGroup
							 WHERE  TriggerGroup = '#itm#'
						 </cfquery>
						 
						 <cfif getLabel.TriggerGroupName neq "">
						 		<cf_tl id="#getLabel.TriggerGroupName#">
						 <cfelse>
						 		<cf_tl id="#itm#">
						 </cfif>
																	
						</td>
					</tr>
					</table>
				
				</td>
					
				<td class="hide" name="SalaryTrigger#tag#b" id="SalaryTrigger#tag#b">	
								
				 	<select name="SalaryTrigger#tag#_#line#" size="1" class="regularxl" style="width:200px">
						<cfloop query="Dependent">
							<option value="#SalaryTrigger#">#Description#</option>
						</cfloop>
				    </select>
				
				</TD>
				
				<TD class="hide" name="Group#tag#b" id="Group#tag#b" style="padding-right:3px">
				
				  <table width="100%">
				  <tr><td style="min-width:310px">
				 
				  <cfdiv bind="url:getEntitlementGroup.cfm?id=#url.id#&dob={BirthDate}&tag=#tag#_#line#&salarytrigger={SalaryTrigger#tag#_#line#}&selected=" bindonload="No">				
					  <cfset url.tag           = "#tag#_#line#">
					  <cfset url.salarytrigger = dependent.SalaryTrigger>					  
					  <cfinclude template="getEntitlementGroup.cfm">							
				  </cfdiv>
				
				  </td>
				  
				  <td align="right" style="padding-left:3px;padding-right:3px;width:80px">
				  <cfif itm eq "insurance">
					  <input type="checkbox" style="cursor:pointer" class="radiol" name="EntitlementSubsidy#tag#_#line#" title="If not CHECKED no subsidy is calculated" checked value="1">
				  </cfif>
				  </td>
				  
				  </tr>
				  </table> 
				
				<!--- define a group based on the selected entitlement of the trigger as defined in the group field --->
				
				</td>
			     
			    <TD class="hide" name="DateEffective#tag#b" id="DateEffective#tag#b">
				
					  <cf_intelliCalendarDate9
						FieldName="DateEffective#tag#_#line#" 
						Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
						AllowBlank="False"
						Class="regularxl">	
						
			  	</TD>
					
				<TD class="hide" name="DateExpiration#tag#b" id="DateExpiration#tag#b">
				
					  <cf_intelliCalendarDate9
						FieldName="DateExpiration#tag#_#line#" 
						Default=""
						AllowBlank="True"
						Class="regularxl">		
					
				</TD>
				<TD class="hide" name="Remarks#tag#b" id="Remarks#tag#b">
			    	<input type="text" name="Remarks#tag#_#line#" size="20" style="width:99%" maxlength="30" class="regularxl"> 
				</TD>
					
			</tr>
			
			<tr class="line"><td colspan="6"></td></tr>
		
		</cfif>
			
		</cfoutput>		
	
	</cfloop>		
	</table>
	</td></tr>
	
	</cfif>
	
		
	<tr><td height="1" colspan="2" height="51" align="center">
	<cfoutput>
		<cf_tl id="Cancel" var="1">
		<input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="parent.parent.ProsisUI.closeWindow('mydependent',true)">		
 		<cf_tl id="Save" var="1">
		<input class="button10g" type="submit" name="Submit"  value=" #lt_text# ">
   </cfoutput>
	
	</td></tr>
    
	</TABLE>

</table>

</CFFORM>

<cf_screenbottom layout="webapp">