

<cfparam name="URL.refer"  default="">
<cfif url.refer eq "undefined">
	<cfset url.refer = "">
</cfif>

<cfparam name="URL.scope"  default="backoffice">
<cfif url.scope eq "undefined">
	<cfset url.scope = "backoffice">
</cfif>

<cfparam name="URL.daymode"  default="0">
<cfparam name="url.action"   default="0">

<cfif url.refer eq "workflow">
    <cf_screentop height="100%" html="Yes" jquery="Yes" Label="Process Leave" option="Process leave request" layout="webapp" banner="yellow" menuaccess="context">	 
<cfelse>
	<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No" title="Leave" menuaccess="context">
</cfif>  

<cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Parameter 		
</cfquery>

 <cfif Param.LeaveFieldsEnforce eq "1">
  	<cfset enf = "Yes">
 <cfelse>
   <cfset enf = "No">
 </cfif>

<cfquery name="GetPL" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *,(SELECT TOP 1 ObjectKeyValue4 
			   FROM   Organization.dbo.OrganizationObject 
			   WHERE  (Objectid   = L.LeaveId OR ObjectKeyValue4 = L.LeaveId)
			   AND    EntityCode = 'EntLVE' 
			   AND    Operational = 1) as WorkflowId	
	FROM    PersonLeave L
	WHERE   Leaveid = '#URL.ID1#' 
</cfquery>

<cfquery name="LeaveType" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">		 
	 SELECT LeaveReviewer
	 FROM   Ref_LeaveType
	 WHERE  LeaveType = '#GetPL.LeaveType#'		 
</cfquery>

<cfparam name="url.id" default="#GetPL.PersonNo#">

<cf_calendarScript>

<cfoutput>

<script>

		function leaveedit(id,mode) {
		    ptoken.location("EmployeeLeaveEdit.cfm?ID=#URL.ID#&ID1=" + id + "&daymode=" + mode);
		}

		function geteffectivedate(fld) {				   		 
		    setexpirationdate('dateexpiration',fld.dd+'/'+fld.mm+'/'+fld.yyyy,'1')
  		 	syncDatesEff(fld);
		}
		
		function getexpirationdate(fld) {				   		 
		    setexpirationdate('dateexpiration',fld.dd+'/'+fld.mm+'/'+fld.yyyy,'0')
  		 	syncDatesEff(fld);
		}
		
		function setexpirationdate(fld,val,mde) {
		   fldval = document.getElementById(fld).value				  
		   ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/setExpirationDate.cfm?id=#url.id#&mde='+mde+'&fld='+fld+'&val='+fldval+'&selected='+val,fld+'_trigger')		  		  		  
		}
		
		function syncDates(fld)	{
     		var deff = $('##dateeffective').val();
			if (fld == '') 
				var dexp = $('##dateexpiration').val();
			else {
				if (fld.dd.toString().length==1)
					fld.dd = '0'+fld.dd;
				if (fld.mm.toString().length==1)
					fld.mm = '0'+fld.mm;
				var dexp = fld.dd + '/' + fld.mm + '/' + fld.yyyy;
			}	
			
			if (deff==dexp) 
				$('##_Expiration').hide();
			else
				$('##_Expiration').show();				
			
		}
				
		function setmydate(fld,val) {		 
		    setexpirationdate('dateexpiration',val)			   	   		 
		}

	function getinformation(per) {
		    tpe = document.getElementById('leavetype').value
			cls = document.getElementById('leavetypeclass').value
			try {	
			lst = document.getElementById('grouplistcode').value
			} catch(e) { lst = '' }		
			eff = document.getElementById('dateeffective').value	
			efm = document.getElementById('dateeffectivefull').value								
			exp = document.getElementById('dateexpiration').value						
			exm = document.getElementById('dateexpirationfull').value							
			_cf_loadingtexthtml='';			
			ColdFusion.navigate('#session.root#/attendance/application/leaveRequest/getBalance.cfm?leaveid=#url.id1#&id='+per+'&leavetype='+tpe+'&leavetypeclass='+cls+'&grouplistcode='+lst+'&effective='+eff+'&effectivefull='+efm+'&expiration='+exp+'&expirationfull='+exm,'balance')		
	}
	
	$(function() {
			syncDates('');			
    	});	
		
		function syncDatesEff(fld) {
			if (fld.dd.toString().length==1)
				fld.dd = '0'+fld.dd;
			if (fld.mm.toString().length==1)
				fld.mm = '0'+fld.mm;

			var deff = fld.dd + '/' + fld.mm + '/' + fld.yyyy;
			var dexp = $('##dateexpiration').val();
			
			if (deff==dexp) 
				$('##_Expiration').hide();
			else
				$('##_Expiration').show();							
		}		
		
	function getreason(per,tpe,code,sel) {   
	       
		    _cf_loadingtexthtml='';			
			ptoken.navigate('#session.root#/Staffing/Application/Employee/Leave/getReason.cfm?ID=' + per + '&leavetype=' + tpe + '&leaveclass=' + code + '&selected=' + sel,'reason');			
		 
		}		

</script>

</cfoutput>

<cf_divscroll>

<cfform action="EmployeeLeaveEditSubmit.cfm?scope=#url.scope#" method="POST" name="leave">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

	<tr colspan="2" class="hide"><td id="result"></td></td></tr> 	
	
	<cfif url.action eq "0">
	
		<cfif url.scope eq "backoffice">
		
			<tr><td style="padding-top:3px"><cfinclude template="../PersonViewHeaderToggle.cfm"></td></tr>
		
		<cfelse>
		
			<tr><td style="padding-top:3px">
	    		<cfset openmode = "close">
				<cfinclude template="../PersonViewHeaderToggle.cfm">
			</td></tr>
		
		</cfif>
		
	<cfelseif url.scope eq "attendance">	
	
		<tr>
			<td style="padding-top:3px">
			<cfset openmode = "close">
				<cfinclude template="../PersonViewHeaderToggle.cfm">
			</td>
		</tr>
		
	</cfif>
	
	<cfinvoke component  = "Service.Access" 
	      method         = "contract"
		  personno       = "#URL.ID#"	
		  role           = "'ContractManager'"		
		  returnvariable = "access">	
		  
	<cfinvoke component  = "Service.Access" 
	      method         = "RoleAccess"				  	
		  role           = "'LeaveClearer'"		
		  returnvariable = "manager">		   
		  
	<cfif manager eq "Granted">
		<cfset access = "ALL">
	</cfif>	  		
	
	<cfif url.action eq "1">
		    <cfset mode = "view">
	<cfelseif getPL.transactiontype eq "External" and getAdministrator("#getPL.Mission#") eq "0" and access neq "ALL">
	        <!--- external records are outside --->
		    <cfset mode = "view">
	<cfelseif ((getAdministrator("#getPL.Mission#") eq "1" or access eq "ALL") and GetPL.Status lte "3")>
	        <cfset mode = "edit">  
	<cfelseif (access eq "EDIT" or Access eq "ALL") and GetPL.Status lte "1">	 
	        <cfset mode = "edit">  
	<cfelseif url.action eq "1">
		    <cfset mode = "view">
	<cfelseif GetPL.Status eq "0">
	    <cfset mode = "edit">
	<cfelse>
		<cfset mode = "view">	
	</cfif>
	
	<cfoutput>
		<input type="hidden" name="LeaveId"  value="#URL.ID1#" class="regular">
		<input type="hidden" name="PersonNo" value="#URL.ID#"  class="regular">
		<input type="hidden" name="Source"   value="Manual"    class="regular">
	</cfoutput>
	
	<tr><td>

		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		  <cfif url.action eq "0">
		   			
			  <tr class="line">
			    <td width="100%" align="center" style="font-weight:200;padding-left:10px;font-size:26px;height:40px" class="labelit">
			    	<cf_tl id="Leave record">					
										
					<cfif GetPL.Status eq "8" or GetPL.Status eq "9">
														
					   <font color="FF0000">
					   :<cfif GetPl.Status eq "8"><cf_tl id="Cancelled"><cfelse><cf_tl id="Denied"></cfif>
					   </font>
					   
					<cfelseif GetPL.Status eq "2">
														
					   <font color="green">
					   :<cf_tl id="Completed">
					   </font>
					 
					
					</cfif>					
			    </td>
			  </tr> 	
			  
		  </cfif>
		  
		   <cfif url.action eq "1" and GetPL.Status eq "0">
			
				<tr>
				
				<td colspan="3" align="left" style="padding-left:8px">
					
						<cf_tl id="Cancel" var="1">
						<cfoutput>
							<input class="button10g"  style="width:110" type="submit" name="Delete" value="<cfoutput>#lt_text#</cfoutput>">
						</cfoutput>
							
				</td></tr>
				
				<tr><td height="2"></td></tr>				
				<TR><td class="line" colspan="2"></td></TR>		
				
		  </cfif>
		   
		  <tr>
		    <td width="100%">
			
			    <table border="0" cellpadding="0" cellspacing="0" width="98%" align="center" class="formpadding formspacing">
				    
				<cfquery name="Type" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_LeaveType
					ORDER BY ListingOrder
			   </cfquery>
						 			   
			    <tr><td height="4"></td></tr>
			    
			    <tr class="labelmedium">
			    <td width="100" style="padding-left:10px" ><cf_tl id="Type of leave">:</td>
			    <td width="70%" style="padding-top:5px">
					
				 <cfif mode eq "edit">
				 
					 <cfquery name="Type" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_LeaveType 
						WHERE    EntityClass IN  (SELECT EntityClass
						                          FROM   Organization.dbo.Ref_EntityClass 
												  WHERE  EntityCode = 'EntLve')
						<cfif quotedvalueList(getPL.Mission) neq "">						
						AND      LeaveType   IN  (SELECT LeaveType 
						                          FROM   Ref_LeaveTypeMission 
											      WHERE  Mission IN (#quotedvalueList(getPL.Mission)#))
						</cfif>		
						
						<cfif url.scope eq "portal">
						AND     UserEntry = '1'
						<cfelseif access neq "EDIT" and access neq "ALL">
						AND      LeaveParent IN  ('SickLeave','AnnualLeave','CTO')
						</cfif>				
												
						ORDER BY ListingOrder, 
						         Description
								 
				    </cfquery>
					
					<cfif getPL.TransactionType eq "External">
												 
						<cfquery name="Type" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   Ref_LeaveType
								WHERE  LeaveType = '#GetPL.LeaveType#'
						</cfquery>
						
					    <cfoutput>#Type.description# <cfif GetPL.Status eq "0">Pending<cfelseif GetPL.Status eq "2"><cf_tl id="Cleared"></cfif>
							<input type="hidden" id="leavetype" name="leavetype" value="#GetPL.LeaveType#">
						</cfoutput>										
					
					<cfelse>
				 						
						<cfoutput>
																					
						 <select id="leavetype" name="leavetype" class="regularxl"
						   onchange="ptoken.navigate('#session.root#/attendance/application/leaveRequest/RequestTypeClass.cfm?source=#getPL.TransactionType#&id=#GetPL.PersonNo#&leavetype='+this.value,'typeclass')">
	
						     <cfloop query = "Type">
							     <option value="#LeaveType#" <cfif type.LeaveType eq GetPL.LeaveType>selected</cfif>>&nbsp;#Description#&nbsp;&nbsp;</option>
						     </cfloop>
						 
						 </select>
						 
						</cfoutput>
					
					</cfif>		
					
				 
				 <cfelse>
				 
				    <cfquery name="Type" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_LeaveType
						WHERE  LeaveType = '#GetPL.LeaveType#'
					</cfquery>
					
				    <cfoutput>#Type.description#</cfoutput> : <cfif GetPL.Status eq "9"> <font color="FF0000"><cf_tl id="Denied"></font> <cfelseif GetPL.Status eq "8"> <font color="gray"><cf_tl id="Cancelled"></font><cfelse> <cfoutput><font color="gray"><cf_tl id="In process"></font></cfoutput></cfif>
				 
				 </cfif>
			     </td>
				 
				<td align="right" style="padding-right:3px;min-width:300" rowspan="7" valign="top" id="balance"></td>
				
			    </tr>  
							
				<cfquery name="List" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_LeaveTypeClass								
						WHERE    LeaveType   = '#GetPL.leavetype#'		
						AND      Operational = 1
						ORDER BY ListingOrder
				</cfquery>
				
				<cfif List.recordcount gte "1">
				
					<tr class="labelmedium" id="rowaction">
					<TD style="padding-left:10px"><cf_tl id="Class">:</TD>	
										
					 <cfif mode eq "edit">
					 													
						<td style="padding-left:0px;padding-right:0px;">	
						
							<table><tr><td style="border:1px solid silver">
						
							<cfdiv id="typeclass">
					
							    <table>
								
								<tr class="labelmedium">
								<td style="padding-left:3px">
											
									<select class="regularxl" name="leavetypeclass" id="leavetypeclass"
									   style="font:10px;color:black;border:0px" onchange="<cfoutput>getreason('#url.id#','#getPL.leavetype#',this.value,'#getPL.grouplistcode#')</cfoutput>">
										<cfoutput query="List">
									        <option value="#Code#" <cfif GetPL.LeaveTypeClass eq Code>selected</cfif>>#Description#</option>				
										</cfoutput>	
									</select>
								
								</td>
								
								<td id="reason" style="padding-left:3px">
								
									<cfset url.leavetype  = getPL.leavetype>
									<cfset url.leaveclass = getPL.leavetypeClass>
									<cfset url.selected   = getPL.grouplistcode>				
									<cfinclude template="getReason.cfm">
								
								</td>
								
								</tr>
								</table>
							
							</cfdiv>
							
							</td></tr></table>
							
						</td>	
						
					<cfelse>
					
						<td>
					
						<cfquery name="Class" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_LeaveTypeClass								
							WHERE    LeaveType    = '#GetPL.leavetype#'		
							AND      Code         = '#getPL.LeaveTypeClass#'			
					   </cfquery>
				   
				       <cfoutput>#Class.Description#</cfoutput>
					   
					   <cfquery name="getReason" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT    *
							    FROM     Ref_PersonGroupList
								WHERE    GroupCode     = '#getPL.groupCode#'
								AND      GroupListCode = '#getPL.groupListCode#'						
					   </cfquery>
							
					   <cfoutput>#getReason.Description#</cfoutput>
					   
					   </td>
					
					</cfif>	
												
					</tr>
				
				<cfelse>
				
					<input type="hidden" id="leavetypeclass" name="leavetypeclass" value="">
				
				</cfif>
				
				<cfif getPL.DateEffective eq getPl.DateExpiration and url.daymode eq "0">		
				
								
					<TR class="labelmedium">
				    <TD style="padding-left:10px"><cf_tl id="Date">:<cf_space spaces="45"></TD>
				    <TD height="20">
					
					    <table cellspacing="0" cellpadding="0">
										
						<tr class="labelmedium">
						
						<cfif mode eq "edit">
						
							<td style="font-size:16px">
						
							<cfoutput>#Dateformat(GetPL.DateEffective, CLIENT.DateFormatShow)#
							&nbsp;
							<input type="hidden" id="dateeffective" name="dateeffective" value="#Dateformat(GetPL.DateEffective, CLIENT.DateFormatShow)#">
							</cfoutput>
							
							</td>
						
							<!--- disabled for now to be adjusted Hanno 
				  
							<cf_intelliCalendarDate9
								FieldName="dateeffective" 
								class="regularxl"
								scriptdate="geteffectivedate"
								Default="#Dateformat(GetPL.DateEffective, CLIENT.DateFormatShow)#"
								AllowBlank="False">	
							
							<cfajaxproxy bind="javascript:setmydate('dateexpiration',{dateeffective})"> 	
							
							--->
							<cfoutput>
							<td class="labelmedium" style="font-size:16px;padding-left:3px;padding-right:8px"><a href="javascript:leaveedit('#getPL.Leaveid#','1')">[<cf_tl id="Extend">]</a></td>
							</cfoutput>
						
							
						<cfelse>
						
							<td style="font-size:16px">
						
							<cfoutput>#Dateformat(GetPL.DateEffective, CLIENT.DateFormatShow)#</cfoutput>
							
							</td>
						
						</cfif>	
												
						<cfoutput>
												
						<td style="width:20px"></td>
						
						<!--- provision to interpret the part-time day also from the other field --->
						
						<cfset part = "">
						
						<cfif getPL.DateEffectiveFull eq "0">
							<cfset part = "PM">
						<cfelse>
							<cfset part = "AM">							
						</cfif>
						
						
						<cfif mode eq "edit"> 
												
							<td class="labelmedium">
							   <table>
							   <tr class="labelmedium" name="portion">
							   	   <td><input type="radio" class="radiol" name="DateEffectiveHour" id="dateeffectivehour" <cfif GetPL.DateEffectiveHour eq "0">checked</cfif> onclick="document.getElementById('dateeffectivefull').value='1';getinformation('#getPL.PersonNo#')" value="0"></td>
								   <td style="padding-left:5px"><cf_tl id="Full day"></td>				   
								   <td style="padding-left:10px"><input type="radio" class="radiol" name="DateEffectiveHour" id="dateeffectivehour"  <cfif GetPL.DateEffectiveHour eq "6" or part eq "AM">checked</cfif> onclick="document.getElementById('dateeffectivefull').value='0';getinformation('#getPL.PersonNo#')" value="6"></td>
								   <td style="padding-left:5px"><cf_tl id="First part"></td>
								   <td style="padding-left:10px"><input type="radio" class="radiol" name="DateEffectiveHour" id="dateeffectivehour"  <cfif GetPL.DateEffectiveHour eq "12" or part eq "PM">checked</cfif> onclick="document.getElementById('dateeffectivefull').value='0';getinformation('#getPL.PersonNo#')" value="12"></td>
								   <td style="padding-left:5px"><cf_tl id="Second part"></td>				 
							   </tr>
							   </table>
							</td>
							
						<cfelse>
						
							<td class="labelmedium">
							   <table>
							   <tr class="labelmedium" name="portion">
							   	   <td><input type="radio" class="radiol" name="DateEffectiveHour" disabled id="dateeffectivehour" <cfif GetPL.DateEffectiveHour eq "0">checked</cfif> value="0"></td>
								   <td style="padding-left:5px"><cf_tl id="Full day"></td>				   
								   <td style="padding-left:10px"><input type="radio" class="radiol" disabled name="DateEffectiveHour" id="dateeffectivehour"  <cfif GetPL.DateEffectiveHour eq "6" or part eq "AM">checked</cfif> value="6"></td>
								   <td style="padding-left:5px"><cf_tl id="First part"></td>
								   <td style="padding-left:10px"><input type="radio" class="radiol" disabled name="DateEffectiveHour" id="dateeffectivehour"  <cfif GetPL.DateEffectiveHour eq "12" or part eq "PM">checked</cfif> alue="12"></td>
								   <td style="padding-left:5px"><cf_tl id="Second part"></td>				 
							   </tr>
							   </table>
							</td>						
						
						</cfif>	
						
						
						<input type="hidden"  id="dateeffectivefull"  name="dateeffectivefull"  value="#GetPL.DateEffectiveFull#">
						<input type="hidden"  id="dateexpiration"     name="dateexpiration"     value="#Dateformat(GetPL.DateExpiration, CLIENT.DateFormatShow)#">
						<input type="hidden"  id="dateexpirationfull" name="dateexpirationfull" value="1">
						
						</cfoutput>
									
					   </TR>
					   
					   </table>
					   
					 </td>
					 </tr>  							
				
				<cfelse>
				
					<cfoutput>
			  
				    <TR class="labelmedium">
				    <TD style="padding-left:10px"><cf_tl id="Starts from">:<cf_space spaces="45"></TD>
				    <TD height="20">
					
						<table cellspacing="0" cellpadding="0">
											
							<tr class="labelmedium"><td>
							
							<cfif mode eq "edit">
					  
								<cf_intelliCalendarDate9
									FieldName="dateeffective" 
									class="regularxl"
									scriptdate="geteffectivedate"
									Default="#Dateformat(GetPL.DateEffective, CLIENT.DateFormatShow)#"
									AllowBlank="False">	
								
								<cfajaxproxy bind="javascript:setmydate('dateexpiration',{dateeffective})"> 	
								
							<cfelse>
							
								#Dateformat(GetPL.DateEffective, CLIENT.DateFormatShow)#
							
							</cfif>	
							
							</td>
							<td>&nbsp;</td>
							
							<input type="hidden" name="dateeffectivefull" id="dateeffectivefull" value="#getPL.DateEffectiveFull#">
																
							
							<td style="padding-right:7px">
								<cfif mode eq "edit">			
									<input type="radio" onclick="document.getElementById('dateeffectivefull').value='1';getinformation('#getPL.PersonNo#')" id="_dateeffectivefull"  name="_DateEffectiveFull" value="1" <cfif GetPL.DateEffectiveFull eq "1">checked</cfif>><cf_tl id="Morning"> 			
								<cfelse>
									<cfif GetPL.DateEffectiveFull eq "1"><cf_tl id="Morning"></cfif>
								</cfif>	
							</td>	
							<td style="padding-right:4px">
								<cfif mode eq "edit">	
						        	<input type="radio" onclick="document.getElementById('dateeffectivefull').value='0';getinformation('#getPL.PersonNo#')" id="_dateeffectivepart" name="_DateEffectiveFull" value="0" <cfif GetPL.DateEffectiveFull eq "0">checked</cfif>><cf_tl id="Afternoon">	
								<cfelse>
									<cfif GetPL.DateEffectiveFull eq "0"><cf_tl id="Afternoon"></cfif>
								</cfif>			
									
							</td>		
						   
					 		</tr>
							
						</table>
				 	
					</TD>
					</TR>				
								
					<TR class="labelmedium">
				    <TD style="padding-left:10px"><cf_tl id="Ends by">:</TD>
				    <TD height="20">
						<table cellspacing="0" cellpadding="0">
				  		<tr class="labelmedium"><td>
						
						<cfif mode eq "edit">
						
							  <cf_intelliCalendarDate9
								FieldName="dateexpiration" 
								class="regularxl"
								scriptdate="getexpirationdate"	
								Default="#Dateformat(GetPL.DateExpiration, CLIENT.DateFormatShow)#"
								AllowBlank="False">	
							
							<cfajaxproxy bind="javascript:setexpirationdate('dateexpiration',{dateexpiration},'0')">
							
						<cfelse>
						
							#Dateformat(GetPL.DateExpiration, CLIENT.DateFormatShow)#
								
						</cfif>
							
						</td>
						<td>&nbsp;</td>
						
						<input type="hidden" name="dateexpirationfull" id="dateexpirationfull" value="#getPL.DateExpirationFull#">
						
						<td style="padding-right:7px">
							<cfif mode eq "edit">
						        <input type="radio" onclick="document.getElementById('dateexpirationfull').value='0';getinformation('#getPL.PersonNo#')" id="_dateexpirationfull" name="_DateExpirationFull" value="0" <cfif GetPL.DateExpirationFull eq "0">checked</cfif>><cf_tl id="Morning">		
							<cfelse>
								<cfif GetPL.DateExpirationFull eq "0"><cf_tl id="Morning"></cfif>
							</cfif>			
						</td>
						
						<td style="padding-right:4px">
						
							<cfif mode eq "edit">
								<input type="radio" onclick="document.getElementById('dateexpirationfull').value='1';getinformation('#getPL.PersonNo#')" id="_dateexpirationfull" name="_DateExpirationFull" value="1" <cfif GetPL.DateExpirationFull eq "1">checked</cfif>><cf_tl id="Afternoon"> 
							<cfelse>
								<cfif GetPL.DateExpirationFull eq "1"><cf_tl id="Afternoon"></cfif>
							</cfif>		
						</td>
				       		  
				 		</tr>
						</table>
					</TD>
					</TR>
					
					</cfoutput>
					
				</cfif>	
				
				<cfif Param.LeaveFieldsEnforce eq "1">
				  	<cfset enf = "Yes">
					<cfset cl  = "regular">
				<cfelse>
				    <cfset enf = "No">
					<cfset cl  = "hide">
				</cfif>
					
				<tr class="labelmedium <cfoutput>#cl#</cfoutput>">
				    <td style="padding-left:10px"><cf_tl id="Contact Location">:<cfif enf eq "Yes"><font color="FF0000">*</font></cfif></td>
				    <td>
					<cfif mode eq "edit">
						<cfinput type="Text" name="contactlocation" 
						      value="#GetPL.contactlocation#" 
							  class="regularxl" 
							  required="#enf#" 
							  message="Enter a contact address" 
							  visible="Yes" 
							  maxlength="100" 
							  style="width:350">
					<cfelse>
						<cfoutput>#GetPL.contactlocation#</cfoutput>
					</cfif>
					</td>
				</tr>
				  
				<tr class="labelmedium <cfoutput>#cl#</cfoutput>">
				    <td style="padding-left:10px"><cf_tl id="Phone No">:<cfif enf eq "Yes"><font color="FF0000">*</font></cfif></td>
				    <td>
					<cfif mode eq "edit">
					<cfinput type="Text" name="contactcallsign" value="#GetPL.contactcallsign#" class="regularxl" required="#enf#" message="Enter a contact number" visible="Yes" maxlength="20" style="width:200">
					<cfelse>
					<cfoutput>#GetPL.contactcallsign#</cfoutput>
					</cfif>
					</td>
				</tr>
											
				<cfif mode eq "view">
				
					<tr class="labelmedium">
					    <td style="padding-left:10px"><cf_tl id="Approval by">:</td>
					    <td>
							<cfquery name="rev1" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT P.FullName	
								FROM   Employee.dbo.PersonLeave as PL
									   INNER JOIN System.dbo.UserNames as UN ON UN.Account = PL.FirstReviewerUserId
									   INNER JOIN Employee.dbo.Person as P ON P.PersonNo = UN.PersonNo
								WHERE  PL.LeaveId =  '#url.id1#'	
							</cfquery>
							<cfoutput> #rev1.FullName# </cfoutput>	
													
						</td>
					</tr>		
					
					<tr class="labelmedium">
					    <td style="padding-left:10px"></td>
					    <td>
							<cfquery name="rev1" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT P.FullName	
								FROM   Employee.dbo.PersonLeave as PL
									   INNER JOIN System.dbo.UserNames as UN ON UN.Account = PL.SecondReviewerUserId
									   INNER JOIN Employee.dbo.Person as P ON P.PersonNo = UN.PersonNo
								WHERE  PL.LeaveId =  '#url.id1#'	
							</cfquery>
							<cfoutput> #rev1.FullName# </cfoutput>	
													
						</td>
					</tr>		
				
				</cfif>
				
				<cfif GetPL.Status neq "9">
				
					<cfquery name="Workflow" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT *
						   FROM   Ref_LeaveType
						   WHERE  LeaveType   = '#GetPL.LeaveType#'  
						   AND    EntityClass IN (SELECT EntityClass
						                          FROM   Organization.dbo.Ref_EntityClassPublish 
												  WHERE  EntityCode = 'EntLve')
					</cfquery> 
				
					<cfif workflow.recordcount gte "1">												
											
							<cfquery name="getAssignment" 
								 datasource="AppsEmployee"
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
									 SELECT   O.*, R.PostOrder
									 FROM     PersonAssignment PA, 
									          Organization.dbo.Organization O,
											  Position P, 
											  Ref_PostGrade R
									 WHERE    P.PositionNo = PA.PositionNo
									 AND      R.PostGrade  = P.PostGrade
									 AND      PA.PersonNo          = '#url.id#'
									 AND      Pa.OrgUnit           = O.OrgUnit
									 AND      PA.DateEffective     < getdate()
									 AND      PA.DateExpiration    > getDate()
									 AND      PA.AssignmentStatus IN ('0','1')
									 AND      PA.AssignmentClass   = 'Regular'
									 AND      PA.AssignmentType    = 'Actual'
									 AND      PA.Incumbency        = '100' 
							</cfquery>	
					
							<cfif mode eq "edit">
											  
							  <!--- I involved the Position and Ref_PostGrade
							   as we need these tables to show the right order 
							   Jorge Mazariegos Jan 27th 2010 --->
							  
							  <cfif LeaveType.LeaveReviewer eq "Staffing">
							  
								  <cfquery name="FirstReviewer" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										
										SELECT   Account,
												 FirstName, 
												 LastName,
												 MIN(PostOrder) as PostOrder
												 
										FROM (		 
									
											    <!--- get users through person with same or higher grade --->
												
												SELECT   DISTINCT 
														 U.Account,
														 U.FirstName, 
														 U.LastName,
														 R.PostOrder
														 
												FROM     PersonAssignment PA, 
												         System.dbo.UserNames U, 
														 Position P, 
														 Ref_PostGrade R
														 
												WHERE    P.PositionNo = PA.PositionNo
												AND      R.PostGrade  = P.PostGrade
												
												AND      PA.OrgUnit IN (SELECT OrgUnit 
														                   FROM   Organization.dbo.Organization 
																		   WHERE  HierarchyRootUnit = '#getAssignment.HierarchyRootUnit#'
																		   AND    Mission           = '#getAssignment.Mission#'
																		   AND    MandateNo         = '#getAssignment.MandateNo#') 
																		   
												AND      PA.PersonNo        = U.Personno		
												AND      PA.DateEffective  <= getdate() 
											    AND      PA.DateExpiration >= getdate()
											    AND      PA.Incumbency > '0'
												<!--- same level or higher than this person --->
												AND      R.PostOrder <= '#getAssignment.PostOrder#'
												
												<!--- planned and approved --->
												AND      PA.AssignmentStatus < '8'
									            AND      PA.AssignmentClass = 'Regular'
											    AND      PA.AssignmentType  = 'Actual'
												
												AND      U.Disabled = 0			
												AND      U.Personno != '#URL.ID#'
															
												UNION
												
	
											
												SELECT   DISTINCT U.Account,
														 U.FirstName, 
														 U.LastName,
														 '1' as PostOrder				 
												FROM     Organization.dbo.OrganizationAuthorization OA, 
												         System.dbo.UserNames U
												WHERE    OA.UserAccount = U.Account
												AND      OA.Role IN
										                   (SELECT    Role
										                    FROM      Organization.dbo.Ref_Entity
										                    WHERE     EntityCode IN ('EntOvertime','EntLVE'))
												 AND     OA.OrgUnit = '#getAssignment.OrgUnit#'
												
												AND      U.Personno != '#URL.ID#'
												
												UNION
									
												<!--- include the designated timekeeper --->
											
												SELECT   DISTINCT U.Account,
														 U.FirstName, 
														 U.LastName,
														 '0' as PostOrder				 
												FROM     Organization.dbo.OrganizationAuthorization OA, 
												         System.dbo.UserNames U
												WHERE    OA.UserAccount = U.Account
												AND      OA.Role = 'Timekeeper'	       
												AND      OA.OrgUnit = '#getAssignment.OrgUnit#'			
												AND      U.Personno != '#URL.ID#'	
												
												) as S
											
											GROUP BY Account,
													 FirstName, 
													 LastName	
								
											ORDER BY MIN(PostOrder)	
										
								  </cfquery>		
								  
								  <cfquery name="SecondReviewer" dbtype="query">
								  	   SELECT *
									   FROM   #FirstReviewer#
								  </cfquery>
							  
							  <cfelseif  LeaveType.Leavereviewer eq "Role">
							  
							  	 	<cfquery name="FirstReviewer" 
										  datasource="AppsEmployee" 
										  username="#SESSION.login#" 
										  password="#SESSION.dbpw#">
								
												SELECT   U.Account,
														 U.FirstName, 
														 U.LastName,
														 '0' as PostOrder				 
												FROM     Organization.dbo.OrganizationAuthorization OA, 
												         System.dbo.UserNames U
												WHERE    OA.UserAccount = U.Account
												AND      OA.Role        = 'Timekeeper'	       
												AND      OA.OrgUnit     = '#getAssignment.OrgUnit#'
												AND      U.AccountType  = 'Individual'
												-- AND      U.Personno != '#URL.ID#' 		
												AND      OA.AccessLevel = '1'
									
												ORDER BY PostOrder	
									</cfquery>
										
									<cfquery name="SecondReviewer" 
										  datasource="AppsEmployee" 
										  username="#SESSION.login#" 
										  password="#SESSION.dbpw#">
								
												SELECT   U.Account,
														 U.FirstName, 
														 U.LastName,
														 '0' as PostOrder				 
												FROM     Organization.dbo.OrganizationAuthorization OA, 
												         System.dbo.UserNames U
												WHERE    OA.UserAccount  = U.Account
												AND      OA.Role         = 'Timekeeper'	       
												AND      OA.OrgUnit      = '#getAssignment.OrgUnit#'
												AND      U.Personno     != '#URL.ID#'	
												AND      U.AccountType   = 'Individual'	
												AND      OA.AccessLevel  = '2'
									
												ORDER BY PostOrder	
									</cfquery>
										
							  </cfif>
								
							 <cfif Type.ReviewerActionCodeOne neq "">			  
							 
							   <tr class="labelmedium <cfif getPL.TransactionType eq 'external'>hide</cfif>">
								  
								  <td valign="top" style="padding-top:5px;padding-left:10px"><cf_tl id="Approval by">:<font color="FF0000">*</font></td>
								  
								  <td>
								  
								  <table cellspacing="0" cellpadding="0">
								  
								  <tr>
								 
								  <td style="padding-right:8px">
								  
								  <cfif FirstReviewer.recordcount gte "1" and (LeaveType.LeaveReviewer eq "Staffing" or LeaveType.Leavereviewer eq "Role")>
								
									  <select class="regularxl" name="FirstReviewerUserId" id="FirstReviewerUserId">
									  
										  <cfoutput query="FirstReviewer">
										 	<option value="#Account#" <cfif account eq getPL.FirstreviewerUserId>selected</cfif>>#FirstName# #LastName# (#Account#)</option>		  
										  </cfoutput>
										  
									  </select>
								  
								  <cfelse>
								  
									    <table cellspacing="0" cellpadding="0">
										<tr>
												
											<cfset link = "#session.root#/Attendance/Application/LeaveRequest/getPerson.cfm?leaveid=#url.id1#&field=FirstReviewerUserId">						
											
											<cfif mode eq "edit">
														
												<td width="20" style="padding-right:4px">
													
												   <cf_selectlookup
													    box        = "super1"
														link       = "#link#"
														button     = "Yes"
														close      = "Yes"						
														icon       = "contract.gif"
														iconheight = "25"
														iconwidth  = "25"
														class      = "user"
														des1       = "Account">
														
												</td>	
												
												<td width="2"></td>		
												
											</cfif>
											
											<!-----rfuentes to show approbals without editting ---->
											<cfif GetPL.Status eq "1" or GetPL.Status eq "0">
												<td width="50%">								    
												<cfdiv bind="url:#link#&Account=" id="super1"/>						
												</td>
											<cfelse>
												<td width="50%" colspan="3">
												<cfquery name="rev1" 
												datasource="AppsEmployee" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT P.FullName	
													FROM   Employee.dbo.PersonLeave as PL
														   INNER JOIN System.dbo.UserNames as UN ON UN.Account = PL.FirstReviewerUserId
														   INNER JOIN Employee.dbo.Person as P ON P.PersonNo = UN.PersonNo
													WHERE  PL.LeaveId =  '#url.id1#'	
												</cfquery>
												<cfoutput> #rev1.FullName# </cfoutput>	
												</td>
											</cfif>
											
										    <td width="50%"></td>			
														
										</tr>
										</table>	
								  			  
								  </cfif>
								  </td>
								  </tr>
								  
								   <cfif Type.ReviewerActionCodeTwo neq "">	
								  
								  <tr class="<cfif getPL.TransactionType eq 'external'>hide</cfif>"><td height="3"></td></tr>
								  
								  <tr class="<cfif getPL.TransactionType eq 'external'>hide</cfif>">
								 				  
								  <td>
								   
								   <cfif SecondReviewer.recordcount gte "1" and (LeaveType.LeaveReviewer eq "Staffing" or LeaveType.Leavereviewer eq "Role")>
								   
									  <select class="regularxl" name="SecondReviewerUserId" id="SecondReviewerUserId">
									      <option value="">[n/a]</option>
										  <cfoutput query="SecondReviewer">
										 	<option value="#Account#" <cfif account eq getPL.SecondReviewerUserId>selected</cfif>>#FirstName# #LastName# (#Account#) </option>		  
										  </cfoutput>					  
									  </select>
									  
									<cfelse>
									
										 <table cellspacing="0" cellpadding="0">
											<tr>
												
												<cfif mode eq "edit">
														
												<cfset link = "#session.root#/Attendance/Application/LeaveRequest/getPerson.cfm?leaveid=#url.id1#&field=SecondReviewerUserId">						
															
												<td width="20" style="padding-right:4px">
													
												   <cf_selectlookup
													    box        = "super2"
														link       = "#link#"
														button     = "Yes"
														close      = "Yes"						
														icon       = "contract.gif"
														iconheight = "25"
														iconwidth  = "25"
														class      = "user"
														des1       = "Account">
														
												</td>	
												
												<td width="2"></td>		
												
												</cfif>
												
												<cfif GetPL.Status eq "1" or GetPL.Status eq "0">
													<td width="50%">								    	
														<cfdiv bind="url:#link#&Account=" id="super2"/>					
													</td>
													<cfelse>
													<td width="50%" colspan="3">
														<cfquery name="rev1" 
														datasource="AppsEmployee" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															SELECT P.FullName	
															FROM Employee.dbo.PersonLeave as PL
															INNER JOIN System.dbo.UserNames as UN
																ON UN.Account = PL.SecondReviewerUserId
															INNER JOIN Employee.dbo.Person as P
																ON P.PersonNo = UN.PersonNo
															WHERE PL.LeaveId =  '#url.id1#'	
														</cfquery>
													<cfoutput> #rev1.FullName# </cfoutput>	
													</td>
												</cfif>
												
											    <td width="50%"></td>			
															
											</tr>							
										 </table>	
													
									</cfif>
													  
								  </td>
								  </tr>
								  
								  </cfif>
								  
								  </table>
								  
								  </td>
							  </tr>		
							  
						   </cfif>	  
						   
						   </cfif>	  
										  
					</cfif>
					
				</cfif>	
				
				<cfif Type.HandoverActionCode neq "">	
						  	
					<tr class="labelmedium">
				    <td style="min-width:200px;padding-left:10px"><cf_tl id="Backup during absense">:</td>
				    <td>
								
								<table cellspacing="0" cellpadding="0">
								<tr>
									
									<cfif mode eq "edit">
										
									    <cfset link = "#SESSION.root#/attendance/Application/LeaveRequest/getPerson.cfm?leaveid=#url.id1#&field=HandoverUserId">						
																			
										<td width="20" style="padding-right:4px">
											
										   <cf_selectlookup
											    box        = "backupselect"
												link       = "#link#"
												button     = "Yes"
												close      = "Yes"						
												icon       = "contract.gif"
												iconheight = "25"
												iconwidth  = "25"
												class      = "user"
												des1       = "Account">
												
										</td>	
																
										<td width="50%">					
											<cfdiv bind="url:#link#&Account=" id="backupselect"/>						
										</td>
									
									<cfelse>
									
									    <td class="labelmedium">
									 		
										<cfquery name="Line" 
										   datasource="AppsEmployee" 
										   username="#SESSION.login#" 
										   password="#SESSION.dbpw#">
											SELECT P.FullName	
											FROM EMployee.dbo.PersonLeave as PL
											INNER JOIN System.dbo.UserNames as UN
												ON UN.Account = PL.HandoverUserId
											INNER JOIN Employee.dbo.Person as P
												ON P.PersonNo = UN.PersonNo
											WHERE PL.LeaveId =  '#url.id1#'	
										</cfquery>
										<cfoutput>#Line.FullName#</cfoutput>
									    </td>
									
									</cfif>
									
								    <td width="50%"></td>			
												
								</tr>
								</table>	
										
					</td>
					</tr>	
					
				</cfif>	
							
				<tr class="labelmedium <cfoutput>#cl#</cfoutput>">
			    <td style="padding-left:10px;padding-top:4px" valign="top"><cf_tl id="Handover Notes">:</td>
			    <td colspan="2">
				
					<cfif mode eq "edit">
					
						<textarea type="text" class="regular" name="HandoverNote" totlength="400"  onkeyup="return ismaxlength(this)" style="padding:3px;font-size:14px;width:99%;height:50"><cfoutput>#GetPL.HandoverNote#</cfoutput></textarea>
						
					<cfelse>
					
						<cfoutput>#GetPL.HandoverNote#</cfoutput>
						
					</cfif>
					
				</td>
				</tr>
					
				<tr class="labelmedium">
			    <td valign="top" style="padding-top:4px;padding-left:10px"><cf_tl id="Remarks">:</td>
			    <td colspan="2">
				
				<cfif mode eq "edit">
				
					<textarea type="text" class="regular" name="Memo" totlength="400" onkeyup="return ismaxlength(this)" style="padding:3px;font-size:14px;width:99%;height:50"><cfoutput>#GetPL.Memo#</cfoutput></textarea>
					
				<cfelse>
				
					<cfoutput><cfif getPL.Memo neq "">#GetPL.Memo#<cfelse>n/a</cfif></cfoutput>
					
				</cfif>
				</td>
			    </tr>
							
				<tr class="labelmedium">
			    <td style="padding-left:10px"><cf_tl id="Last updated by">:</td>
			    <td class="labelmedium" colspan="2">
					<cfoutput><font color="gray">#GetPL.OfficerFirstName# #GetPL.OfficerLastName# #dateformat(GetPL.Created,CLIENT.DateFormatShow)# #timeformat(GetPL.Created,"HH:MM")# : #GetPL.TransactionType#</font></cfoutput>
				</td>
			    </tr>
				
				<cfquery name="Log" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">				
						SELECT    *
						FROM      PersonLeaveLog
						WHERE     LeaveId = '#getPL.LeaveId#'
						ORDER BY  Created DESC				
				</cfquery>
				
				<cfif Log.recordcount gte "1">
				
					<tr class="labelmedium" style="height:15px">
				    <td style="padding-left:10px"><cf_tl id="Earlier updated by">:</td>
				    <td colspan="2">
						<cfoutput query="Log">
						<font color="gray">#currentrow#. #OfficerLastName# <u>#dateformat(Created,CLIENT.DateFormatShow)# #timeformat(Created,"HH:MM")#</u>&nbsp;</font>
						</cfoutput>
					</td>
				    </tr>
				
				</cfif>
					
				<cfoutput>
				<tr>
					<td colspan="3">
					
				<cfif mode eq "Edit">
									
					   <table width="100%" bgcolor="FFFFFF">
					   <tr><td height="1" colspan="2" class="line"></td></tr>
					   <tr>
					   <td height="30" align="center">
					   				   					   
					   <cfif url.action eq "0">							   					   					   
										   		
							<cfif url.scope eq "backoffice">
							
								 <cf_tl id="Back" var="1">	   
							     <input type="button" name="close" value="#lt_text#" class="button10g" onClick="ptoken.location('EmployeeLeave.cfm?ID=#url.id#')">									
								 
							<cfelseif url.scope eq "attendance">	 
							
								<!--- nada --->
							   
							<cfelse>
							
								<!--- portal --->
															   
							    <cf_tl id="Back" var="1">
						   	    <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="ptoken.location('EmployeeLeaveEditGo.cfm?scope=#url.scope#&ID=#url.id#')">
												   
							</cfif> 									
							
							<cfif getAdministrator("*") eq "1" 
							     or GetPL.Status eq "0" 
								 or access eq "All">   
					   							 
								<cf_tl id="Delete" var="1">
							   	<input type="submit" name="delete" value="#lt_text#" class="button10g">
							
							</cfif>
							 
					   </cfif>
					   
					   <cfif getAdministrator("*") eq "1" 
					       or (access eq "All" or access eq "Edit") 
						   or GetPL.Status eq "0"> 
					  			  
						   <cf_tl id="Save" var="1">	   
						   <input type="submit" class="button10g" name="Submit" value="#lt_text#" onclick="Prosis.busy('yes')">
					   
					   </cfif>
						     
					 
					   </td>
					   </tr>
					   </table>
					   
					<cfelse>
					
					   <cfif url.action eq "0" and url.scope neq "attendance">
					  
						   <table width="100%" bgcolor="FFFFFF">
						   <tr><td height="1" colspan="2" class="line"></td></tr>
						   <tr><td align="center" height="30">
						   <cf_tl id="Back" var="1">	   
						   <input type="button" name="close" value="#lt_text#" class="button10g" onClick="ptoken.location('EmployeeLeave.cfm?ID=#url.id#')">
						   </td>
						   </tr>
						   </table>
					   
					   </cfif>					   
					   					   
					</cfif>	  
								
				</td>
				
				</tr>
								
				</cfoutput>
				
								
				<cfif GetPL.TransactionType eq "External">
									
					<cfif GetPL.Workflowid neq "">
					
						<cfquery name="Workflow" 
						   datasource="AppsEmployee" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
							   SELECT *
							   FROM   Ref_LeaveType
							   WHERE  LeaveType   = '#GetPL.LeaveType#'  
							   AND    EntityClass IN (SELECT EntityClass
							                          FROM   Organization.dbo.Ref_EntityClassPublish 
													  WHERE  EntityCode = 'EntLve')
						</cfquery> 
						
						<cfif workflow.recordcount eq "1">
					
							<tr>
							<td colspan="3">
							
							<cfajaximport tags="cfmenu,cfdiv,cfwindow">
						    <cf_ActionListingScript>
						    <cf_FileLibraryScript>
						   
						    <cfset wflnk = "EmployeeLeaveEditWorkflow.cfm">
							
							<cfoutput>						   
						  
						    <input type="hidden" 
						          name="workflowlink_#url.id1#" id="workflowlink_#url.id1#"
						          value="#wflnk#"> 
						 
						     <cfdiv id="#url.id1#">
							 
							   <cfset url.ajaxid = url.id1>
							   <cfinclude template="EmployeeLeaveEditWorkflow.cfm">
							   
							 </cfdiv>
							 
							 </cfoutput>
								
							</td>
							
							</tr>
						
						</cfif>
						
					<cfelse>
					
						<!--- nothing --->	
								
					</cfif>						
									
				
				<cfelseif GetPL.Status eq "0" or GetPL.Status eq "1">
				
					<cfquery name="Workflow" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT *
						   FROM   Ref_LeaveType
						   WHERE  LeaveType   = '#GetPL.LeaveType#'  
						   AND    EntityClass IN (SELECT EntityClass
						                          FROM   Organization.dbo.Ref_EntityClassPublish 
												  WHERE  EntityCode = 'EntLve')
					</cfquery> 
					
					<cfif workflow.recordcount eq "1">
				
						<tr>
						<td colspan="3">
						
						<cfajaximport tags="cfmenu,cfdiv,cfwindow">
					    <cf_ActionListingScript>
					    <cf_FileLibraryScript>
					   
					    <cfset wflnk = "EmployeeLeaveEditWorkflow.cfm">
						
						<cfoutput>					   
					  
					    <input type="hidden" 
					          name="workflowlink_#url.id1#" id="workflowlink_#url.id1#"
					          value="#wflnk#"> 
					 
					     <cfdiv id="#url.id1#">
						 
						   <cfset url.ajaxid = url.id1>
						   <cfinclude template="EmployeeLeaveEditWorkflow.cfm">
						   
						 </cfdiv>
						 
						 </cfoutput>
							
						</td>
						
						</tr>
					
					</cfif>
					
				<cfelseif GetPL.Status eq "2">
				
					<cfquery name="Workflow" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT *
						   FROM   Ref_LeaveType
						   WHERE  LeaveType   = '#GetPL.LeaveType#'  
						   AND    EntityClass IN (SELECT EntityClass
						                          FROM   Organization.dbo.Ref_EntityClassPublish 
												  WHERE  EntityCode = 'EntLve')
					</cfquery> 
										
					<cfif workflow.recordcount eq "1">
				
						<tr>
						<td colspan="3" style="padding-right:15px">
						
						<cfajaximport tags="cfmenu,cfdiv,cfwindow">
						
					    <cf_ActionListingScript>
					    <cf_FileLibraryScript>
					   
					    <cfset wflnk = "EmployeeLeaveEditWorkflow.cfm">
						
						<cfoutput>						
					   
					    <input type="hidden" 
					          name="workflowlink_#url.id1#" id="workflowlink_#url.id1#"
					          value="#wflnk#"> 
					 
					     <cfdiv id="#url.id1#">
						   <cfset url.ajaxid = url.id1>
						   <cfinclude template="EmployeeLeaveEditWorkflow.cfm">
						 </cfdiv>
						 
						 </cfoutput>
							
						</td>
						
						</tr>
					
					</cfif>
							
				<cfelseif GetPL.Status eq "8" or GetPL.Status eq "9">
										
					<cfquery name="Workflow" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT *
						   FROM   Ref_LeaveType
						   WHERE  LeaveType   = '#GetPL.LeaveType#'  
						   AND    EntityClass IN (SELECT EntityClass
						                          FROM   Organization.dbo.Ref_EntityClassPublish 
												  WHERE  EntityCode = 'EntLve')
					</cfquery> 
					
					<cfif workflow.recordcount eq "1">
				
						<tr>
						<td colspan="3" style="padding-right:15px">
												
							<cfajaximport tags="cfmenu,cfdiv,cfwindow">
							
						    <cf_ActionListingScript>
						    <cf_FileLibraryScript>
												   
						    <cfset wflnk = "EmployeeLeaveEditWorkflow.cfm">
							
							<cfoutput>						
						   
							    <input type="hidden" 
							          name="workflowlink_#url.id1#" id="workflowlink_#url.id1#"
							          value="#wflnk#"> 
							 
							     <cfdiv id="#url.id1#">
								 
								   <cfset url.ajaxid = url.id1>
								   <cfinclude template="EmployeeLeaveEditWorkflow.cfm">
								 </cfdiv>
							 
							 </cfoutput>
							
						</td>						
						</tr>
					
					</cfif>
				
				</cfif>
				 
				<tr><td height="4" colspan="1"></td></tr>
						
			</table>
		
		</td>
		
		</tr>
		
		</table>
	
	</td>

	</tr>

</table>	

</CFFORM>

</cf_divscroll>

<cf_screenbottom layout="webapp">

<!---
<cfif mode eq "edit" and (GetPL.Status eq "0" or GetPL.Status eq "1")>
			 			
	<cfoutput>
	<script>
		getinformation('#url.id#')
	</script>
	</cfoutput>

</cfif>
--->
	 
