
<cfparam name="url.wf" default="0">

<cf_screentop height="100%" scroll="Yes" html="No" menuaccess="context" jquery="Yes">	

<cf_dialogPosition>
<cf_calendarScript>

<!--- define the mission --->
	
<cfquery name="LastContract" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    TOP 1 *
		FROM      PersonContract PA 
		WHERE     PA.PersonNo = '#URL.ID#' 
		AND       PA.ActionStatus IN ('0', '1') 		
		ORDER BY  PA.DateEffective DESC
</cfquery>	

<cfoutput>

<script>

	_cf_loadingtexthtml='';	
	
	function verify(myvalue) { 
	
		setweekschedule()
		
		if (myvalue == "") { 
			alert("You did not define a salary scale")
			return false
			document.getElementById('contractselect').click()				
		}					
	}	
	
	function setweekschedule() {	
	    
		 count = 0
		 ds = ""
		 se = document.getElementsByName("selecthour")		 
		 while (se[count]) {
		 	if (se[count].checked == true)	{
				ds = ds+'-'+se[count].value
		 }
		 count++
		 } 			
		 try {		
		 document.getElementById("dayhour").value = ds } catch(e) {}
		 
	}
		
	function weekschedule(id,mis,eff) {

			if (ProsisUI.existsWindow('myschedule')) {
				ProsisUI.restoreWindow('myschedule');
			} else {
				try {
					ProsisUI.closeWindow('myschedule')
				} catch(e) {
					ProsisUI.createWindow('myschedule', 'Week schedule', '',{x:60,y:60,height:530,width:890,closable:false,minimize:true,maximize:false,modal:false,resizable:false,center:false});
					ptoken.navigate('#SESSION.root#/attendance/application/workschedule/ScheduleView.cfm?id=#url.id#&contractid='+id+'&mission='+mis,'myschedule')
				}
			}
	}

	function clearWSSelection() {
		$('.clsWSHrSlot input[type=checkbox]').prop('checked', false);
		$('.clsWSHrSlot').css('background-color', '');
	}
	
	function selectWS9To5() {
		clearWSSelection();
		$('.clsWSHrSlot95 input[type=checkbox]').prop('checked', true);
		$('.clsWSHrSlot95').css('background-color', '##ffffcf');
	}
	
	function applyscale(scaleno,grd,stp,cur) {	    		  
	    ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/setScale.cfm?scaleno='+scaleno+'&grade='+grd+'&step='+stp+'&currency='+cur+'&personno=#url.id#&contracttype=#LastContract.contracttype#','process')	  				
	}	

</script>

</cfoutput>

<cf_divscroll>

<cfform action="#SESSION.root#/staffing/Application/Employee/Contract/ContractEditSubmit.cfm" 
        method="POST" 
		name="ContractEntry" 
		onSubmit="return verify(ContractEntry.salaryschedule.value)">

<cfoutput>
	<input type="hidden" name="PersonNo"        value="#URL.ID#">
	
	<input type="hidden" name="ContractCurrent" value="00000000-0000-0000-0000-000000000000">
	<cfif url.wf eq "0">
		<cf_assignId>			
	<cfelse>
	   <cfset rowguid = url.id1>		
	</cfif>
	<input type="hidden" name="ContractId"      value="#rowguid#">	
	<input type="hidden" name="dayhour"         id="dayhour">	
</cfoutput>

<table width="97%" align="center" class="formpadding formspacing">

  <cfif url.wf eq "0">	

     <tr>
		<td height="10">	
		  <cfset ctr      = "0">		
		  <cfset openmode = "close"> 
		  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
		</td>
     </tr>	
	  
	 <tr class="line">
	    <td width="100%" style="padding-left:15px;font-size:21px;font-weight:270" align="left" class="labelmedium">
		<cfoutput>
			<cf_tl id="Initial Appointment"> / <cf_tl id="Re-appointment">
		</cfoutput>
	    </td>
	 </tr> 	
	  
  <cfelse>
  
  	<tr><td height="5"></td></tr>	  
  
  </cfif>
    
  <tr class="hide"><td id="process"></td></tr>
  
  <tr>
    <td width="100%" class="header">
    <table border="0" width="97%" align="center" class="formpadding">
			
	<cfquery name="Last" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    TOP 1 P.Mission
		FROM      PersonAssignment PA INNER JOIN
	              [Position] P ON PA.PositionNo = P.PositionNo
		WHERE     PA.PersonNo = '#URL.ID#' 
		AND       PA.AssignmentStatus IN ('0', '1') 
		AND       PA.AssignmentClass = 'Regular'
		ORDER BY  PA.DateEffective DESC
	</cfquery>
		
	<cfquery name="MissionList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMission
		WHERE  Mission IN (SELECT Mission 
		                   FROM   Organization.dbo.Ref_MissionModule 
						   WHERE  SystemModule = 'Staffing')

		<!--- access --->						   	
		
		<cfif getAdministrator("*") eq "0">
				
		AND   Mission IN (SELECT Mission 
		                  FROM   Organization.dbo.OrganizationAuthorization 
						  WHERE  UserAccount = '#SESSION.acc#'
						  AND    Role IN ('ContractManager','HROfficer')
						 ) 
		</cfif>
						   
		<!--- hanno remove, 16/2/2018 : you can record another contract record now
		 if a current contract is pending, do not allow the creation of a new one 		   
		AND    Mission NOT IN (SELECT Mission 
		                       FROM   Organization.dbo.Ref_Mission 
							   WHERE  MissionOwner IN ( SELECT M.MissionOwner 
								                        FROM   PersonContract C, Organization.dbo.Ref_Mission M
													    WHERE  C.Mission      = M.Mission
													    AND    C.PersonNo     = '#URL.ID#'							   
													    AND    C.ActionStatus = '0' 
													   )
							  )		
							  
		--->							  			   
		                       				   
	</cfquery>
	
	<cfif MissionList.recordcount eq "0">	
	
		<tr>
		  <td class="labelmedium"><font color="FF0000">It is not allowed to record a contract until a prior pending contract has been cleared.<a href="javascript:history.go(-1)"><font color="0080FF">[back]</font></a></td>
		</tr>
		<cfabort>
	
	</cfif>
		
	<cfset trackpositionno     = "">	
	<cfset trackpositionname   = "">
	<cfset functiondescription = "">
	<cfset functionno          = "">
	<cfset candidateid         = "">
	
	<cfif url.wf eq "0">	
	 
		<tr>
		<td class="labelmedium" width="200"><cf_tl id="Entity">:</td>
			<td>
							
			 <select name="mission" id="mission" class="regularxxl">
			
				<cfoutput query="MissionList">
				 <option value="#Mission#" <cfif mission eq Last.mission>selected</cfif>>#Mission#
				</cfoutput>		
				
			</select>
			
			</td>
		</tr>	
			
	<cfelse>
	
		<cfquery name="Object" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   OrganizationObject
			WHERE  ObjectId   = '#url.objectid#'		
		</cfquery>
		
		<cfif Object.EntityCode eq "VacCandidate">
		
			<!--- linkage to track that initiates this --->
			
			<cfquery name="Candidate" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Vacancy.dbo.DocumentCandidate
				WHERE  DocumentNo = '#Object.ObjectKeyValue1#'		
				AND    PersonNo   = '#Object.ObjectKeyValue2#'
			</cfquery>
			
			<cfif Candidate.recordcount eq "1">
			
				<input type="hidden" name="CandidateId"      value="<cfoutput>#candidate.CandidateId#</cfoutput>">	
								
			</cfif>				
		
		</cfif>
		
		<cfif url.positionno neq "">
	
			<cfquery name="Position" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Position
				WHERE  PositionNo   = '#url.positionno#'		
			</cfquery>
		
			<cfset trackpositionno    = Position.PositionNo>
			<cfset trackpositionname   = "#Position.PositionParentId# - #trim(Position.PostType)# #Position.PostGrade#">
			<cfset functiondescription = "#Position.FunctionDescription#">
			<cfset functionno          = "#Position.FunctionNo#">			
				
		</cfif>	
	
		<input type="hidden" name="mission" id="mission" value="<cfoutput>#Object.Mission#</cfoutput>">	
	
	</cfif>
				
	<cfquery name="Param" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Parameter	
	</cfquery>
	
	<cf_verifyOperational 
         datasource= "appsSystem"
         module    = "Payroll" 
		 Warning   = "No">
		 
	<cfif operational eq "0"> 
	
		<tr>
		<td class="labelmedium" width="200"><cf_tl id="Payroll Location">:</b></td>
			<td>			
			<cfdiv bind="url:#SESSION.root#/staffing/Application/Employee/Contract/ContractEntryLocation.cfm?mission={mission}" id="loc">			
			</td>
		</tr>
	
	</cfif>	
	
	<tr>
		<TD class="labelmedium" height="20"><cf_tl id="Action">:</TD>
	
			<cfquery name="Action" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Ref_Action
				WHERE ActionSource = 'Contract'	
				AND   CustomForm = 'Insert'
				ORDER BY ListingOrder ASC
			</cfquery>
			
			<td>
										
				<select name="ActionCode" class="regularxxl" style="width:99%" onchange="ptoken.navigate('getReason.cfm?actioncode='+this.value,'groupfield')">					    
					<cfoutput query="Action">
						<option value="#ActionCode#">#Description#</option>
					</cfoutput>		
				</select>		
								
			</td>					
	</tr>	
	
	<tr>
		 
	    <td class="labelmedium" style="height:31px"><cf_tl id="Reason">:</TD>
								
		<td id="groupfield" name="groupfield">	
			 <cfset url.actioncode = Action.ActionCode>
			 <cfinclude template="getReason.cfm">			 			 
		 </td>
							
	</tr>					
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Contract No">:</TD>   	
    <TD id="pano" style="height:30px" class="labelmedium">
    	  <cfdiv bind="url:#SESSION.root#/staffing/Application/Employee/Contract/assignPANo.cfm?wf=#url.wf#&mission={mission}">	 
	</TD>	
	</TR>
	
	
	<cfoutput>
		
		     <script>
				function expiration_selectdate(argObj) {							
				  // trigger a function to set the cf9 calendar by running in the ajax td						 
				  ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/ContractEditExpirationScript.cfm?lastcontractid=#lastcontract.contractid#&contractid=#rowguid#&personno=#url.id#&mission='+document.getElementById('mission').value,'DateExpiration_trigger')					  						
				} 
			</script>	
			
		</cfoutput>	
	
    <TR>
    <TD class="labelmedium" width="170"><cf_tl id="Effective date">:</TD>
    <TD>
	
	    <cfif lastContract.dateExpiration neq "" and lastContract.dateExpiration gte now()-10>		
		   		
			<cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Default="#Dateformat(lastContract.dateExpiration+1, CLIENT.DateFormatShow)#"
				AllowBlank="False"				
				Manual="false"			<!--- do not allow to overlap and create amendments --->
				script="expiration_selectdate"	
				class="regularxxl">					
						
			<cfset url.eff = Dateformat(lastContract.dateExpiration+1, CLIENT.DateFormatShow)>
		
		<cfelse>
	
		 	<cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="False"
				script="expiration_selectdate"	
				class="regularxxl">	
			
			<cfset url.eff = Dateformat(now(), CLIENT.DateFormatShow)>
		
		</cfif>
		
	</TD>
	</TR>	
		
	<TR>
	    <TD class="labelmedium"><cf_tl id="Expiration date">:</TD>
    <TD>
	
	   <cfif lastContract.dateExpiration neq "" and lastContract.dateExpiration gte now()-10>	

		  <cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			Default="#Dateformat(lastContract.dateExpiration+1, CLIENT.DateFormatShow)#"
			AllowBlank="True"
			script="expiration_selectdate"	
			class="regularxxl">	
		
		<cfelse>

		  <cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			Default=""
			script="expiration_selectdate"	
			AllowBlank="True"
			class="regularxxl">	
		
		</cfif>		
		
		<script>
			expiration_selectdate() 
		</script>		
			
	</TD>
	</TR>	
		
	<cfif url.wf eq "0">
	
		<tr id="positionbox" class="hide">
	    <td class="labelmedium"><cf_tl id="Position">:</TD>   	
		<td>
			<table width="80%">
				<tr> 
				<td class="hide"><input type="text" id="PositionNo" name="PositionNo" style="background-color: f4f4f4;" class="regularxxl" size="20" maxlength="20" readonly></td>
				<td style="width:10px"><input type="text" id="Position" name="Position" style="background-color: f1f1f1;" class="regularxxl" size="50" maxlength="100" readonly></td>
				<td style="padding-left:1px">
															  
					  		<cfset link = "#SESSION.root#/Staffing/Application/Employee/Contract/getPosition.cfm?contract=1">
							
					  		<cf_selectlookup
							    box          = "positioncontent"
								title        = "Position Search"
								icon         = "search.png"
								link		 = "#link#"
								des1		 = "PositionNo"
								filter1      = "Mission"
								filter1Value = "{mission}"
								button       = "No"
								style        = "width:28;height:25"
								close        = "Yes"			
								datasource	 = "AppsEmployee"		
								class        = "PositionSingle">	
								
					</td>
					
					<td class="hide" id="positioncontent"></td>
				
				</tr>
				<tr><td colspan="3" style="padding-left:4px" id="assignmentbox"></td></tr>			
			</table>
		</td>		
		</tr>
	
	<cfelse>
	
		<!--- coming from a workflow embedding for arrival --->
				
		<tr id="positionbox">
	    <td class="labelmedium"><cf_tl id="Position">:</TD>   	
		<td>
			<table width="80%">
				<tr> 
				<td class="hide"><input type="text" id="PositionNo" value="<cfoutput>#trackpositionno#</cfoutput>" name="PositionNo" style="background-color: f4f4f4;" class="regularxxl" size="20" maxlength="20" readonly></td>
				<td style="width:10px"><input type="text" id="Position" value="<cfoutput>#trackpositionname#</cfoutput>" name="Position" style="background-color: f1f1f1;" class="regularxxl" size="50" maxlength="100" readonly></td>
				<td style="padding-left:1px">
															  
					  		<cfset link = "#SESSION.root#/Staffing/Application/Employee/Contract/getPosition.cfm?contract=1">
							
					  		<cf_selectlookup
							    box          = "positioncontent"
								title        = "Position Search"
								icon         = "search.png"
								link		 = "#link#"
								des1		 = "PositionNo"
								filter1      = "Mission"
								filter1Value = "{mission}"
								button       = "No"
								style        = "width:28;height:25"
								close        = "Yes"			
								datasource	 = "AppsEmployee"		
								class        = "PositionSingle">	
								
					</td>
					
					<td class="hide" id="positioncontent"></td>
				
				</tr>
				<tr><td colspan="3" style="padding-left:4px" id="assignmentbox"></td></tr>			
			</table>
		</td>		
		</tr>
		
	</cfif>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Contract type">:</TD>   	
    <TD>
		
	    <cfdiv bind="url:#SESSION.root#/staffing/Application/Employee/Contract/ContractField.cfm?id=#url.id#&field=contracttype&mission={mission}&default=#LastContract.contracttype#" 
		 id="fldcontracttype">
		 			
	</TD>	
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Appointment Status">:</TD>   	
    <TD>
		<cfdiv bind="url:#SESSION.root#/staffing/Application/Employee/Contract/ContractField.cfm?field=apptstatus&mission={mission}&default=#LastContract.AppointmentStatus#&contracttype=#LastContract.contracttype#" id="fldappstatus"></TD>	
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Appointment Title">:</TD>   	
    <TD>
	
		<cfoutput>
			<table>
			<tr><td class="hide">
			    <input type="text" id="ContractFunctionNo" name="ContractFunctionNo" style="background-color: f4f4f4;" value="#FunctionNo#" class="regularxl" size="20" maxlength="20" readonly>
				</td>
				<td><input type="text" id="ContractFunctionDescription" name="ContractFunctionDescription" style="background-color: f4f4f4;" value="#FunctionDescription#" class="regularxl" size="50" maxlength="100"></td>
				<td style="padding-left:1px">
				<cfset link = "#SESSION.root#/Staffing/Application/Employee/Contract/getFunction.cfm?contract=1">
							
		  		<cf_selectlookup
				    box          = "functioncontent"
					title        = "Function Search"
					icon         = "search.png"
					link		 = "#link#"
					des1		 = "FunctionNo"
					filter1      = "Mission"
					filter1Value = "{mission}"
					button       = "No"
					style        = "width:28;height:25"
					close        = "Yes"			
					datasource	 = "AppsEmployee"		
					class        = "Function">	
				</td>	
				<td class="hide" id="functioncontent"></td>	
			</tr>
			</table>
		</cfoutput>
	
	</TD>	
	</TR>
				
	<cfif LastContract.recordcount eq "0">
	
		 <cfset url.eff  = dateformat(now(), CLIENT.DateFormatShow)>	
	
	<cfelse>
	
		<cfquery name="FirstContractWithinCurrentGrade" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT Min (DateExpiration) as Suggested
			    FROM   PersonContract
				WHERE  PersonNo   = '#URL.ID#'
				AND    ContractLevel =  '#LastContract.ContractLevel#'
				AND    ContractStep  =  '#LastContract.ContractStep#'
				AND    ActionStatus  =  '1'
				AND    ContractId    != '#LastContract.ContractId#'
				AND    Mission       = '#LastContract.Mission#'
		</cfquery>	
			
		<cfif FirstContractWithinCurrentGrade.Suggested neq "">						  
			    <cfset url.eff  = dateformat(FirstContractWithinCurrentGrade.Suggested, CLIENT.DateFormatShow)>						  
		<cfelse>
			    <cfset url.eff  = dateformat(LastContract.StepIncreaseDate, CLIENT.DateFormatShow)>						  						 
		</cfif>		
		
	</cfif>	
		
	<cfif Operational eq "0"> 
	
		<cfquery name="PostGrade" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Ref_PostGrade
			WHERE    PostGradeContract = 1
			ORDER BY PostOrder
		</cfquery>
					
		<tr>		
		  	<TD class="labelmedium"><cf_tl id="Grade">:</TD>
			<td>
				<table>
				<tr class="labelmedium">
				<td><cfdiv bind="url:#SESSION.root#/staffing/Application/Employee/Contract/ContractField.cfm?field=contractlevel&mission={mission}&default=#LastContract.contractlevel#" 
	        		 id="fldcontractlevel">				
				</td> 
				<td style="padding-left:5px" class="labelmedium"><cf_tl id="Step">:</TD>
			    <td id="fldcontractstep" style="padding-left:5px">			
					<cfdiv bind="url:#SESSION.root#/staffing/Application/Employee/Contract/ContractField.cfm?field=contractstep&grade=#LastContract.contractlevel#&default=#LastContract.contractstep#">										 					
				</td>
				</tr>
				</table>
			</td>
		</tr>
		
		<tr id="nextincrement">
		<TD class="labelmedium"><cf_tl id="Step Increase">:</TD>
		<TD class="labelmedium" id="increment">			
		      <cfset url.lastcontractid = lastcontract.contractid>		   
			  <cfinclude template="ContractEditFormIncrement.cfm">					  
		</TD>
		</tr>

	<cfelse>
					
		<cfoutput>				
		<tr>			
	  	<TD class="labelmedium"><a id="contractselect" href="javascript:selectscale('#url.id#','#lastcontract.contractType#','#url.id1#')"><cf_tl id="Grade">:</TD>
		    <TD><input type="text" name="contractlevel" id="contractlevel" value="#lastcontract.contractlevel#" size="20" maxlength="20" readonly class="regularxxl" style="background-color: f4f4f4;"></TD> 
		</tr>
		<tr>
		<TD class="labelmedium"><a href="javascript:selectscale('#url.id#','#lastcontract.contractType#','#url.id1#')"><cf_tl id="Step">:</a></TD>
			<TD><input type="text" id="contractstep" name="contractstep" value="#lastcontract.contractstep#" style="background-color: f4f4f4;" class="regularxxl" size="4" maxlength="4" readonly></TD> 							
		</tr>
		</cfoutput>
					
		<tr id="nextincrement">
		<TD class="labelmedium"><cf_tl id="Next Step Increase">:</TD>
	    <TD id="increment">		
		  <cfset url.lastcontractid = lastcontract.contractid>
		  <cfset url.entry			= "new">	
		  <cfinclude template="ContractEditFormIncrement.cfm">						  						
	    </TD>
		</tr>
		
		<cfquery name="getLocation" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_PayrollLocation
			WHERE LocationCode = '#lastcontract.servicelocation#'			
		</cfquery>
		
		<cfoutput>
				
		<tr><TD class="labelmedium"><cf_tl id="Location">:</TD>
		    <TD>
			<input type="text" id="servicelocation"     name="servicelocation"     value="#lastcontract.servicelocation#" style="background-color: f4f4f4;" class="regularxxl" size="4"  maxlength="4"  readonly>
			<input type="text" id="servicelocationname" name="servicelocationname" value="#getlocation.Description#"      style="background-color: f4f4f4;" class="regularxxl" size="20" maxlength="20" readonly>
			</TD> 
		</tr>
		<tr><TD class="labelmedium"><cf_tl id="Schedule">:</TD>
		    <TD><input type="text" id="salaryschedule" name="salaryschedule" value="#lastcontract.salaryschedule#" style="background-color: f4f4f4;" class="regularxxl" size="20" maxlength="20" readonly></TD> 
		</tr>
		
		</cfoutput>
			
		<!--- manual salary : ajax ensure the currency is based on the Payroll schedule --->
		<tr class="<cfif url.wf eq '1'>hide</cfif>">
		<TD class="labelmedium" style="padding-right:7px">
		<table>
		<tr>
		<td class="labelmedium2"><cf_tl id="Negotiated Salary"><cfoutput>#application.basecurrency#</cfoutput></td>
		<td><input type="hidden" readonly style="padding-left:3px; border:0px;" size="2" maxlength="4" value="<cfoutput>#application.basecurrency#</cfoutput>" style="background-color: f4f4f4;" class="regularxxl" id="currency" name="currency"> :</TD>
		</tr></table>
		</td>
	    <TD> 			   
			<cfinput type="Text" class="regularxl" style="text-align: center;background-color: white;" name="ContractSalaryAmount" message="Please enter a valid number" validate="float" required="No" size="10" maxlength="10">
		</TD>
		</TR>				
			
	</cfif>
				
	
			
	<TR>
	    <TD class="labelmedium" style="height:30px"><cf_tl id="Review Panel">:</TD>
	    <TD class="labelmedium">	
			<INPUT type="radio" class="radiol" name="ReviewPanel" value="1"> Yes
			<INPUT type="radio" class="radiol" name="ReviewPanel" value="0" checked> No		
		</TD>
	</TR>
	
	<cfquery name="Param" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Parameter 		
	</cfquery>
	
	<cfoutput>
	<script>
	
		function applyhours(val) {			    
			document.getElementById('salarybaseperiod').value = (#Param.HoursInDay# * 5) * val/100		
		}
	
	</script>
	</cfoutput>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Modality">:</TD>
    <TD class="labelmedium">
	  
	    <table>
			<tr class="labelmedium2">
			<td><INPUT type="radio" class="radiol" onclick="applyhours(this.value)" name="ContractTime" value="100" checked></td><td style="padding-left:4px"><cf_tl id="Fulltime"></td>
			<td style="padding-left:6px"><INPUT type="radio" onclick="applyhours(this.value)" class="radiol" name="ContractTime" value="90" <cfif LastContract.ContractTime eq 90>checked</cfif>></td><td style="padding-left:4px">90%</td>
			<td style="padding-left:6px"><INPUT type="radio" onclick="applyhours(this.value)" class="radiol" name="ContractTime" value="80" <cfif LastContract.ContractTime eq 80>checked</cfif>></td><td style="padding-left:4px">80%</td>
			<td style="padding-left:6px"><INPUT type="radio" onclick="applyhours(this.value)" class="radiol" name="ContractTime" value="70" <cfif LastContract.ContractTime eq 70>checked</cfif>></td><td style="padding-left:4px">70%</td>
			<td style="padding-left:6px"><INPUT type="radio" onclick="applyhours(this.value)" class="radiol" name="ContractTime" value="60" <cfif LastContract.ContractTime eq 60>checked</cfif>></td><td style="padding-left:4px">60%</td>
			<td style="padding-left:6px"><INPUT type="radio" onclick="applyhours(this.value)" class="radiol" name="ContractTime" value="50" <cfif LastContract.ContractTime eq 50>checked</cfif>></td><td style="padding-left:4px">50%</td>		
			<td style="padding-left:6px"><INPUT type="radio" onclick="applyhours(this.value)" class="radiol" name="ContractTime" value="40" <cfif LastContract.ContractTime eq 40>checked</cfif>></td><td style="padding-left:4px">40%</td>		
			<td style="padding-left:6px"><INPUT type="radio" onclick="applyhours(this.value)" class="radiol" name="ContractTime" value="20" <cfif LastContract.ContractTime eq 20>checked</cfif>></td><td style="padding-left:4px">20%</td>					
			
			</tr>
		</table>
			
	</TD>
	</TR>
	
	<tr>	
	
    <TD class="labelmedium"><cf_tl id="Weekly hours">:</TD>
    <TD class="labelmedium">
	
		<table>
		<tr>
		<td>					
		
		<cfif LastContract.SalaryBasePeriod neq "">
		
			<cfset hours = Param.HoursInDay * 5>
				
		<cfelse>
		
			<cfset hours = LastContract.SalaryBasePeriod>
			
			<cfif hours eq "">
			   <cfset hours = Param.HoursInDay * 5>
			</cfif>
		
		</cfif>
	
		<cfinput type = "Text" 
		   class      = "regularxl"
		   style      = "text-align: center;padding-top:2px" 
		   value      = "#hours#"
		   name       = "SalaryBasePeriod"
		   id         = "salarybaseperiod"
		   message    = "Please enter a valid number" 
		   validate   = "float"
		   required   = "No" 
		   size       = "3" 
		   maxlength  = "10"> 
		   
		   </td>	   
		   
		   <td style="padding-left:9px;">		

					<input type="checkbox"
					  id="weekselect" 
					  name="weekselect" 
					  value="1"
					  onclick="if (this.checked) {document.getElementById('weekbutton').className='regular';document.getElementById('weeklabel').className='hide';document.getElementById('week').click()} else {document.getElementById('weekbutton').className='hide';document.getElementById('weeklabel').className='labelmedium'}">
			</td>
					
			<td style="padding-left:6px" id="weeklabel" class="labelmedium"><cf_tl id="workschedule"></td>
			<td id="weekbutton" style="padding-left:7px" class="hide">
			
				<cfoutput>
				
					<input class="button10g" 
						onclick="weekschedule('#rowguid#',document.getElementById('mission').value,document.getElementById('DateEffective').value)"
						style="height:22px;width:180px" 
						type="button" 
						id="week" 
						value="Set week schedule">	
						
				</cfoutput>							
								
			</td>			   
		   
		   </tr>
		   
		   </table>	   
		   
	</TD>	
		
	</TR>	
	
	<!--- ------------------ --->
	<!--- Leave entitlements --->
	<!--- ------------------ --->
		
	<cfquery name="Leave" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Ref_LeaveType
			WHERE    LeaveAccrual = '3'
	</cfquery>		
	
	<cfif Leave.recordcount gte "1">	
		<cfinclude template="ContractEntryFormLeave.cfm">			
	</cfif>
	
	<!--- ------------------ --->
	<!--- Payroll entitlements --->
	<!--- ------------------ --->
					 
	<cfif Operational eq "1" or Param.DependentEntitlement eq "1"> 
	
	<tr><td height="3"></td></tr>
	<tr><td valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Financial Entitlements"></td>	
		<td>		
		<cfdiv bind="url:#SESSION.root#/staffing/Application/Employee/Contract/getFinancialEntitlement.cfm?id=#url.id#&contracttype=#LastContract.contracttype#&salarySchedule=#lastcontract.SalarySchedule#" id="boxentitlement">			
		</td>	
	</tr>
	
	</cfif>
		   
	<TR>
        <td valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Remarks">:</td>
        <TD>		
		<textarea id="Remarks" name="Remarks" class="regular" style="font-size:13px;padding:3px;width:95%;height:58px" totLength="600" onkeypress="return ismaxlength(this);"></textarea> </TD>
	</TR>
	
	<tr><td height="4"></td></tr>
		
</table>

</td></tr>
	
<tr><td height="1" colspan="2" class="line"></td></tr>
	
		<tr><td colspan="2" style="padding:6px">
		
			<table width="100%" ccellspacing="0" ccellpadding="0" bgcolor="FFFFFF" class="formpadding">
			<tr>
			<td align="center">
			<cfoutput>
			   <cfif url.wf eq "0">
				  <cf_tl id="Cancel" var="1">
			      <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="history.back()">
			   </cfif>
				<cf_tl id="Reset" var="1">   
			   <input class="button10g" type="reset"  name="Reset" value="#lt_text#">
				<cf_tl id="Save" var="1">   
			   <input class="button10g" type="submit" name="Submit" value="#lt_text#">
			</cfoutput>   
			</td>
			</tr>
			</table>
	
	</td></tr>

</table>

</CFFORM>

</cf_divscroll>

