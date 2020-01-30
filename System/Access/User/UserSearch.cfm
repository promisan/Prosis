
<cf_screentop html="No">

<cfajaximport tags="cfform">

<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0"> 
<cfset menu         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 

<p align="center"></p>
<p>&nbsp;</p>

<script>
  function user() {
   document.getElementById('MissionAccess').disabled = false
   document.getElementById('HostAccess').disabled    = false
   document.getElementById('fmission').className     = "regular"
   document.getElementById('fhost').className        = "regular"
   document.getElementById('fdate').className        = "regular"
  }
  
  function usergroup() {
   document.getElementById('MissionAccess').disabled = true
   document.getElementById('HostAccess').disabled    = true
   document.getElementById('fmission').className     = "hide"
   document.getElementById('fhost').className        = "hide"
   document.getElementById('fdate').className        = "hide"
  }
</script>

<!--- Search form --->

<cfparam name="URL.Form" default="">
<cfparam name="URL.ID"   default="">
<cfparam name="URL.ID1"  default="">
<cfparam name="URL.ID4"  default="default">

<cf_tl id="Contains" var="1">
<cfset vContains=#lt_text#>

<cf_tl id="beginsWith" var="1">
<cfset vBeginsWith=#lt_text#>

<table width="80%" align="center"><tr><td align="center" width="70%">

<CFFORM action="UserSearchCriteria.cfm?idmenu=#url.idmenu#&Form=#URL.Form#&ID=#URL.Id#&ID1=#URL.ID1#&ID4=#URL.Form#" method="post">

		<cfoutput>
				
		<table width="630" align="center" align="center">
		<tr>
		  <td style="padding-top:7px;font-size:32px;padding-left:40px;font-weight:200" class="labelmedium">
		  User (-group) search criteria</td>
		</tr>
			
		<tr><td width="90%" style="padding-left:10px">
			
		<table width="90%" align="center" class="formpadding formspacing">
		
			<tr class="line"><td colspan="2"></td></tr>
			
			<tr><td height="10"></td></tr>	
			
			<cfset session.userselect[0] = "">
																									
			<cfparam name="session.userselect[1]" default="">	  			
												
			<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="U.Account">		
			<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
			<TR>
			<TD class="labelmedium"><cf_tl id="Account">:</TD>
			<TD>
			<SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl enterastab">
				
					<OPTION value="CONTAINS"><cfoutput>#vContains#</cfoutput> 
					<OPTION value="BEGINS_WITH">begins with
					<OPTION value="ENDS_WITH">ends with
					<OPTION value="EQUAL">is
					<OPTION value="NOT_EQUAL">is not
					<OPTION value="SMALLER_THAN">before
					<OPTION value="GREATER_THAN">after
				
				</SELECT>
				
			<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" value="#session.userselect[1]#" class="regularxl enterastab"> 
			
			</TD>
			</TR>				
			
			<cfparam name="session.userselect[3]" default="">
					
			<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="U.LastName,U.FirstName,U.IndexNo">
			
			<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
			<TR>
			<TD class="labelmedium"><cf_tl id="Name">/<cf_tl id="Index">:</TD>
			<TD><SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl enterastab">
				
					<OPTION value="CONTAINS"><cfoutput>#vContains#</cfoutput>
					<OPTION value="BEGINS_WITH">begins with
					<OPTION value="ENDS_WITH">ends with
					<OPTION value="EQUAL">is
					<OPTION value="NOT_EQUAL">is not
					<OPTION value="SMALLER_THAN">before
					<OPTION value="GREATER_THAN">after
				
				</SELECT>
				
			<INPUT type="text" name="Crit3_Value" id="Crit2_Value" value="#session.userselect[3]#" size="20" class="regularxl enterastab"> 
			
			</TD>
			</TR>
			
			<cfparam name="session.userselect[4]" default="">
			
			<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="U.AccountGroup">		
			<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
			<TR>
			<TD class="labelmedium"><cf_tl id="Account Class">:</TD>
			<TD><SELECT name="Crit4_Operator" id="Crit4_Operator" class="regularxl enterastab">
				
					<OPTION value="CONTAINS"><cfoutput>#vContains#</cfoutput>
					<OPTION value="BEGINS_WITH">begins with
					<OPTION value="ENDS_WITH">ends with
					<OPTION value="EQUAL">is
					<OPTION value="NOT_EQUAL">is not
					<OPTION value="SMALLER_THAN">before
					<OPTION value="GREATER_THAN">after
				
				</SELECT>
				
			<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="20" class="regularxl enterastab" value="#session.userselect[4]#">
			
			</TD>
			</TR>	
			
			<TR>
			<TD class="labelmedium"><cf_UIToolTip  tooltip="Account can be mananged by the tree role manager of this entity"><cf_tl id="Managing entity">:</cf_UIToolTip></TD>
			<TD>
			
			<cfparam name="session.userselect[5]" default="">
			
			<INPUT type="hidden" name="Crit5_FieldName" id="Crit5_FieldName" value="U.AccountMission">		
			<INPUT type="hidden" name="Crit5_FieldType" id="Crit5_FieldType" value="CHAR">
			<INPUT type="hidden" name="Crit5_Operator" id="Crit5_Operator" value="EQUAL">
							
			<cfquery name="OwnerMission" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT   DISTINCT MissionOwner, AccountMission
				FROM     UserNames U LEFT OUTER JOIN Organization.dbo.Ref_Mission M	ON U.AccountMission = M.Mission
				WHERE    AccountMission > ''
				ORDER BY MissionOwner, AccountMission
			</cfquery>
					
			  <cfselect name="Crit5_Value"
		          group="MissionOwner"
		          queryposition="below"
				  style="width:150px"
		          query="OwnerMission"
		          value="AccountMission"
		          display="AccountMission"
				  selected="#session.userselect[5]#"
		          visible="Yes"
		          enabled="Yes"
		          class="regularxl enterastab">		
				 <option value="">Any</option>
			</cfselect> 		
			
			</TD>
			</TR>				
			
			
			<cfparam name="session.userselect[2]" default="">	
			
			<TR>
			<TD width="200" class="labelmedium"><cf_tl id="Account Class">:</TD>
			<TD>
			    <table>
					<tr>
					<td style="padding-left:0px"><input onclick="user()" type="radio" class="radiol enterastab" <cfif session.userselect[2] neq "Group">checked</cfif> name="AccountType" id="AccountType" value="Individual"></td>
					<td class="labelmedium" style="padding-left:3px">User</td>
					<td style="padding-left:3px"><input onclick="usergroup()" type="radio" class="radiol enterastab" <cfif session.userselect[2] eq "Group">checked</cfif> name="AccountType" id="AccountType" value="Group"></td>
					<td class="labelmedium" style="padding-left:3px">User group</td>
					<!---
					<td style="padding-left:3px"><input type="radio" class="radiol enterastab" name="AccountType" id="AccountType" value="" <cfif session.userselect[2] eq "">checked</cfif>></td>
					<td class="labelmedium" style="padding-left:3px">Both</td>
					--->
					</tr>
				</table>
			</TD>
			</TR>	
						
			<TR>
			<TD class="labelmedium"><cf_tl id="Account Status">:</TD>
			<TD class="labelmedium">
			     <table>
					<tr>
					<td style="padding-left:0px"><input type="radio" class="radiol enterastab" name="Status" id="Status" value="0" checked></td>
					<td class="labelmedium" style="padding-left:3px">Active</td>
					<td style="padding-left:3px"><input type="radio" class="radiol enterastab" name="Status" id="Status" value="1"></td>
					<td class="labelmedium" style="padding-left:3px">Disabled</td>
				    <td style="padding-left:3px"><input type="radio" class="radiol enterastab" name="Status" id="Status" value=""></td>
					<td class="labelmedium" style="padding-left:3px">All</td>
					</tr>
				</table>
			</TD>
			</TR>	
			
			<cfparam name="session.userselect[12]" default="">	
			
			<TR>
			<TD class="labelmedium"><cf_tl id="Employee Status">:</TD>
			<TD class="labelmedium">
			     <table>
					<tr>
					<td style="padding-left:0px"><input type="radio" class="radiol enterastab" name="isEmployee" id="isEmployee" value="0" <cfif session.userselect[12] eq "0">checked></cfif>></td>
					<td class="labelmedium" style="padding-left:3px">Not associated</td>
					<td style="padding-left:3px"><input type="radio" class="radiol enterastab" name="isEmployee" id="isEmployee" value="1" <cfif session.userselect[12] eq "1">checked></cfif>></td>
					<td class="labelmedium" style="padding-left:3px">Employee</td>
				    <td style="padding-left:3px"><input type="radio" class="radiol enterastab" name="isEmployee" id="isEmployee" value="" <cfif session.userselect[12] eq "">checked></cfif>></td>
					<td class="labelmedium" style="padding-left:3px">Both</td>
					</tr>
				</table>
			</TD>
			</TR>	
			
			<tr><td style="height:5px"></td></tr>
			<tr><td colspan="2" style="padding-top:10px;height:45" class="labelmedium line">
			
			<table><tr><td>
			<img src="#SESSION.root#/Images/userfilter.png" alt="" width="32" height="32" border="0" align="absmiddle">
			</td>
			<td class="labelmedium" style="padding-top:15px;padding-left:7px">Filter on specific user activity</td>
			</tr></table>
			</td></tr>
			
			<tr><td height="8"></td></tr>
			
			<cfif session.userselect[2] neq "group">			
			   <cfset ena = "yes">		
			   <cfset cl = "regular">	   
			<cfelse>			
			   <cfset ena = "no">	
			   <cfset cl = "hide">		  
			</cfif>  
			
						
			<!--- ----------------- --->
			<!--- ---- MODULE ----- --->
			<!--- ----------------- --->
			
			<cfparam name="session.userselect[10]" default="">
			
			<TR>
			<TD class="labelmedium"><cf_tl id="Module Accessed">:</TD>
			<TD class="labelmedium">
			
				<cfquery name="AccessModule" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				
				    SELECT     A.Description, R.SystemModule, R.Description AS Expr1
					FROM         Ref_SystemModule R INNER JOIN
					                      Ref_ApplicationModule AM ON R.SystemModule = AM.SystemModule INNER JOIN
					                      Ref_Application A ON AM.Code = A.Code
					WHERE     (A.[Usage] = 'System') AND (R.Operational = 1)
					ORDER BY A.ListingOrder
	
				</cfquery>
				
				<cfselect name="SystemModule"	         
				  style="width:150px"
		          queryposition="below"
				  group="Description"
		          query="AccessModule"
		          value="SystemModule"
		          display="SystemModule"
				  selected="#session.userselect[10]#"
		          visible="Yes"
		          enabled="Yes"
		          class="regularxl enterastab">		
					 <option value="">Any</option>
				</cfselect> 		
							
						
			</TD>
			</TR>	
			
			<!--- ----------------- --->
			<!--- ----- ROLE ------ --->
			<!--- ----------------- --->
			
			<cfparam name="session.userselect[11]" default="">
			
			<TR>
			<TD class="labelmedium"><cf_tl id="Role assigned">:</TD>
			<TD class="labelmedium">
						
			<cfdiv bind="url:getRole.cfm?selected=#session.userselect[11]#&systemmodule={SystemModule}">
			
			</TD>
			</TR>				
			
			<cfparam name="session.userselect[6]" default="">
							
			<TR id="fmission" class="#cl#">
			<TD class="labelmedium"><cf_tl id="Entity accessed">:</TD>
			<TD class="labelmedium">
						
			<cfquery name="AccessMission" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT   DISTINCT M.MissionOwner, U.Mission
	            FROM     UserActionModule AS U INNER JOIN
	                     Organization.dbo.Ref_Mission AS M ON U.Mission = M.Mission
			    ORDER BY M.MissionOwner, U.Mission
			</cfquery>
			
			<cfif ena eq "Yes">
			
				<cfselect name="MissionAccess"
		          group="MissionOwner"
		          queryposition="below"
		          query="AccessMission"
		          value="Mission"
		          display="Mission"
		          selected="#session.userselect[6]#"
		          visible="Yes"
		          enabled="no"	          
		          id="MissionAccess"
		          style="width:150px"
		          class="regularxl enterastab">		
					 <option value="">Any</option>
				</cfselect>
			
			<cfelse>
								
				<cfselect name="MissionAccess"
		          group="MissionOwner"
		          queryposition="below"
		          query="AccessMission"
		          value="Mission"
		          display="Mission"
		          selected="#session.userselect[6]#"
		          visible="Yes"
		          disabled="yes"	          
		          id="MissionAccess"
		          style="width:150px"
		          class="regularxl enterastab">		
					 <option value="">Any</option>
				</cfselect>
			
			</cfif> 		
						
			</TD>
			</TR>	
			
			<cfparam name="session.userselect[9]" default="">
							
			<TR id="fhost" class="#cl#">
			<TD class="labelmedium"><cf_tl id="Host Used">:</TD>
			<TD class="labelmedium">
						
			<cfquery name="AccessHost" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT DISTINCT HostName
				FROM   UserActionModule
				WHERE  ActionTimeStamp >= GETDATE() - 45
			</cfquery>
			
			<cfif ena eq "Yes">
			
			<cfselect name="HostAccess"	id="HostAccess"         
			  style="width:150px"
	          queryposition="below"
	          query="AccessHost"
	          value="HostName"
	          display="HostName"
			  selected="#session.userselect[9]#"
	          visible="Yes"	          			
	          class="regularxl enterastab">		
				 <option value="">Any</option>
			</cfselect> 
			
			<cfelse>
					
			<cfselect name="HostAccess"	id="HostAccess"         
			  style="width:150px"
	          queryposition="below"
	          query="AccessHost"
	          value="HostName"
	          display="HostName"
			  selected="#session.userselect[9]#"
	          visible="Yes"	          
			  disabled="yes"
	          class="regularxl enterastab">		
				 <option value="">Any</option>
			</cfselect> 
			
			</cfif>		
						
			</TD>
			</TR>	
										
			<cfparam name="session.userselect[7]" default="">
			<cfparam name="session.userselect[8]" default="#Dateformat(now()-300, CLIENT.DateFormatShow)#">
			
			<cf_calendarscript>
			
			<TR id="fdate" class="#cl#">
			<TD class="labelmedium"><cf_tl id="Last Session">:</TD>
			<TD class="labelmedium">
			
				<table cellspacing="0" cellpadding="0"><tr><td>
			
					
				<SELECT onchange="seldate(this.value)" name="Session_Operator" id="Session_Operator" style="width:98px" class="regularxl enterastab">
					
					<OPTION value="" <cfif session.userselect[7] eq "">selected</cfif>>n/a			
					<OPTION value="later" <cfif session.userselect[7] eq "later">selected</cfif>>After
					<OPTION value="before" <cfif session.userselect[7] eq "before">selected</cfif>>Before
								
				</SELECT>
				
				<script>
					function seldate(val) {
					
					if (val = "") {
					  document.getElementById("datebox").className = "hide"
					} else {
					  document.getElementById("datebox").className = "regular"
					}
					
					}
				</script>
				
				</td>
				
				<cfif session.userselect[7] eq "">
				    <cfset cl = "hide">
				<cfelse>
					<cfset cl = "regular">
				</cfif>
				
				<td style="padding-left:4px" class="#cl#" id="datebox">
				
				 <cf_intelliCalendarDate9
					FieldName="Session_Value" 				
					class="regularxl enterastab"
					Default="#session.userselect[8]#"
					DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"
					AllowBlank="False">	
					
				</td></tr></table>	
							
			</TD>
			</TR>	
				
									
			<tr class="line"><td colspan="2" height="6"></td></tr>
			
			<tr><td height="10"></td></tr>
			<tr><td colspan="2" align="center" height="35">
			<input type="submit" value="Find" class="button10g" style="font-size:14px;height:29;width:160px">
			</td></tr>
			
			<tr><td height="5"></td></tr>
		
		</TABLE>
			
		</td>
		</tr>
			
		</table>
			
		</cfoutput>

</cfform>

</tr>

</table>