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

<cf_tl id="User Access or User Profile amendment" var="1">

<cf_screentop label="#lt_text#" validatesession="no" user="No" height="100%" html="yes" scroll="yes" layout="webapp" banner="gray" jQuery="yes">	 

<cfparam name="SESSION.last"  default="">
<cfparam name="SESSION.first" default="">
<cfset CLIENT.DateFormatShow      = "dd/mm/yyyy">
<cfparam name="url.id"        default="">
<cfparam name="url.showClose" default="1">

<cfquery name="getPortal" 
	datasource="appsSystem"> 
	SELECT   *
	FROM     Ref_ModuleControl
	WHERE    FunctionName  = '#URL.ID#' 
	AND      FunctionClass = 'Selfservice' 
	AND      SystemModule  = 'Selfservice'
</cfquery>

<cfajaximport tags="cfform">

<cfoutput>

<script>
	function submitForm(){
		document.forms['accountForm'].onsubmit()
		if( _CF_error_messages.length == 0 ) {
			
			eOwner = document.getElementById('owner');
			eMission = document.getElementById('Mission');
			eApplication = document.getElementById ('Workgroup');
			
			if (!eOwner || eOwner.value == "") { alert('Please select Owner'); return; }
			if (!eApplication || eApplication.value == "") { alert('Please select application'); return; }
			if (!eMission || eMission.value == "") { alert('Please select entity'); return; }						
		
    	   ptoken.navigate('AccountRequestSubmit.cfm?showClose=#url.showClose#','divSubmit','','','POST','accountForm')
		 }   
	}
	
	function updateMission(){
		wk = document.getElementById('Workgroup');
		ptoken.navigate('AccountRequestMission.cfm?id=#url.id#&application='+wk.value,'mission_div');
	}
</script>

<table cellspacing="0" cellpadding="0" style="width:100%">
	
	<tr>
		<td>		

	<cfform style="width:100%" id="accountForm" name="accountForm" method="post" onsubmit="return false;" >
	
		<table cellpadding="0" align="center" cellspacing="0" border="0" width="99%" height="100%" align="center" class="formspacing formpadding">            	
		
			<tr><td style="padding-left:20px;height:30px" class="labelit">	
				<font color="000000"><cf_tl id="Please fill out and submit this form. You will be contacted as soon as possible" class="message">
			 </td></tr>
					 
			 <tr>
			 <td align="center" id="divSubmit">
			 
				 <table width="90%" align="center" cellpadding="0" class="formpadding formspacing">					
					 <tr>
					 	<td class="labelmedium2" width="30%">
							<cf_tl id="IndexNo">: 
						</td>
						<td></td>
						<td>
						    <table cellspacing="0" cellpadding="0">
							<tr>
							<td>
							<cfinput  
							         name="indexno" 
									 class="regularxxl enterastab" 
									 style="width:80" 
									 maxlength="20" 
									 required="no" 
									 onchange="ptoken.navigate('getIndexNo.cfm?indexno='+this.value,'indexbox');"
									 message="Please enter IndexNo.">
							</td>
							<td width="4"></td>
							<td id="indexbox"></td>
							</table>
						</td>
					 </tr>
				
		             <tr>
					 	<td class="labelmedium2" width="30%">
							<cf_tl id="Last Name">: 
						</td>
						<td class="labelmedium"><font color="FF0000">*</font></td>
						<td>
							<cfinput id="lastname" name="lastname" class="regularxxl enterastab" style="width:250" maxlength="40" required="yes" message="Please enter last name.">
						</td>
					 </tr>
					 
					 <tr>
					 	<td class="labelmedium2" style="padding-right:4px">
							<cf_tl id="First Name">: 
						</td>
						<td><font color="FF0000">*</font></td>
						<td>
							<cfinput id="firstname" name="firstname" class="regularxxl enterastab" style="width:170" maxlength="30" required="yes" message="Please enter first name.">
						</td>
					 </tr>
					 
					  <tr>
					 	<td class="labelmedium2" style="padding-right:4px">
							<cf_tl id="Gender">:
						</td>
						<td></td>
						<td>						   
							<select id="gender" name="Gender" class="regularxxl enterastab">
								<option selected>Male</option>
								<option>Female</option>
							</select>
						</td>
					 </tr>
					 
					 <input type="hidden" name="ldapaccount" value="">
					 
					 <!--- <cfquery name="Param" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  *			
						    FROM    Parameter	   
						</cfquery>
						
					 <cfif Param.LogonMode eq "Prosis">	
					 
					 	 <input type="hidden" name="ldapaccount" value="">
					 
					 <cfelse>					 					  

						 <tr>
						 	<td class="labelmedium" align="right" style="padding-right:4px">
								<cf_tl id="Network Account">: 
								<br>
								<span style="font-size:80%;">
								<cf_tl id="Ex.: Webmail Account, AD Account">
								<br>
								<i><span style="color:##F11F24;">Do <b><u>NOT</u></b> enter any password!</span></i>
								</span>
							</td>
							<td></td>
							<td>
								<cfinput name="ldapAccount" style="width:170" class="regularxl enterastab" width="40" maxlength="50">
							</td>
						 </tr>					 
					 
					</cfif> --->
					 
					<tr>
						<td class="labelmedium2" style="padding-right:4px"> <cf_tl id="Telephone">: </td>
						<td> </td>
						<td>
							<cfinput type="Text"
						       name="telephone"
						       visible="Yes"
						       enabled="Yes"
						       size="20"
						       maxlength="20"
						       class="regularxxl enterastab">
						</td>
					</tr>
					 
					<tr>
						<td class="labelmedium2" style="padding-right:4px;cursor:pointer" title="please enter a valid eMail address">
							<cf_tl id="eMail address">:
						</td>
						<td><font color="FF0000">*</font></td>
						<td>
							<cfinput type="Text"
						       name="eMailAddress"
							   id="emailaddress"
						       message="Please enter a valid eMail address"	      
						       required="Yes"							   
						       visible="Yes"
						       enabled="Yes"
						       size="40"
						       maxlength="100"
						       class="regularxxl enterastab"
							   validate="email">
							   
							   <cfdiv id="mailfailure"></div>
						</td>
					</tr>
					
					<tr><td colspan="3" height="5"></td></tr>
					
					<tr class="line">
						<td align="left" colspan="3" class="labellarge" style="height:40px">
							<font color="0465B5"><cf_tl id="Explain your role or profile problems">
						</td>
					</tr>
					
					<tr><td colspan="3" height="5"></td></tr>
					
					<cfquery name="Workgroup" 
						datasource="AppsSystem">
						    SELECT  *
							FROM    Ref_Application
							WHERE   HostName = '#CGI.HTTP_HOST#'
					</cfquery>
					
					<input type="hidden" name="owner"     id="owner"     value="#Workgroup.Owner#">
					<input type="hidden" name="Workgroup" id="Workgroup" value="#Workgroup.Code#">
					
					<tr id="missionbox" class="regular">
						<td style="padding-right:20px" class="labelmedium2">
							<cf_tl id="Entity">/<cf_tl id="Organization">:
						</td>
						<td><font color="FF0000">*</font></td>
						<td>	
						
							<cfquery name="GetMission" 
								 datasource="AppsOrganization">
									SELECT DISTINCT MM.Mission
									FROM      Ref_MissionModule MM INNER JOIN Ref_Mission M ON MM.Mission = M.Mission
									WHERE     SystemModule IN (
											  	  SELECT SystemModule
												  FROM   System.dbo.Ref_ApplicationModule
												  WHERE  Code = '#Workgroup.Code#'
												)
									AND       M.MissionStatus = '0'
									AND       M.Operational = 1											
									<cfif getPortal.Functioncondition neq "">					
									AND       M.Mission = '#GetPortal.FunctionCondition#'							
									</cfif>
							</cfquery>		
						
							<select name="Mission" id="Mission" class="regularxxl enterastab">		
								<cfloop query="GetMission">
									<option value="#Mission#" <cfif getPortal.Functioncondition eq Mission>selected</cfif>>#Mission#</option>
								</cfloop>
							</select>

						</td>
					</tr>
					
					 
					<tr valign="top">												
						<td colspan="3">
							<textarea id="Memo" class="regularxl" name="Memo" style="padding:4px;font-size:14px;width:98%; border:1px solid ##C0C0C0;" maxlength="500" onkeyup="return ismaxlength(this)" rows="7"></textarea>
						</td>
					</tr>
					
					<tr>
						<td colspan="3" height="5" class="line"></td>
					</tr>
					
					<tr>
						<td colspan="3" align="center">
		                     <input type="button" value="Submit" class="button10g" style="height:27px;font-size:14px;width:170;margin:1px" onclick="submitForm();">
						</td>
					</tr>
										 
				 </table>
			 </td>
			 </tr>			 
		</table>
	</cfform>	
	</td>
	</tr>
</table>					
</cfoutput>
