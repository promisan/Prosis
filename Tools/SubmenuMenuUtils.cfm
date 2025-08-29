<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="align" default="right">
<cfparam name="Module" default="">

<cfoutput>

<script language="JavaScript">

w = 0
h = 0
if (screen) {
w = #CLIENT.width# - 55
h = #CLIENT.height# - 120
}
  
function edituser() {
     window.open("#SESSION.root#/Portal/Preferences/UserEdit.cfm?ID=#SESSION.acc#", "portalright", "width=600, height=600, status=no, toolbar=no, scrollbars=no, resizable=no");
}

function timesheet() {
     window.open("#SESSION.root#/Attendance/Application/Timesheet/Index.cfm?ID=#CLIENT.personNo#", "portalright", "width=600, height=600, status=no, toolbar=no, scrollbars=no, resizable=no");
}

function broadcast(fun,status) {
   window.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastView.cfm?mode=menu&ts="+new Date().getTime(), "portalright", "status=yes, height=715px, width=920px, scrollbars=no, toolbar=no, resizable=no");
}

function qa() {
     window.open("#SESSION.root#/System/Parameter/HelpProject/MenuTopicListing.cfm?id=#module#","right")
}

function dashboard() {
     w = #CLIENT.width# - 50;
     h = #CLIENT.height# - 100;
	 window.open("#SESSION.root#/Portal/Dashboard/Dashboard.cfm?ts="+new Date().getTime(), "_blank", "left=20, top=20, width="+w+", height="+h+", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

function password() {
	 window.open("#SESSION.root#/System/UserPassword.cfm", "portalright", "width=370, height=250, toolbar=no, scrollbars=no, resizable=no");
}

function favorite() {
   	 window.open("#SESSION.root#/System/Modules/Favorite/RecordListing.cfm?ts="+new Date().getTime(), "portalright", "width=370, height=250, toolbar=no, scrollbars=no, resizable=no");
}

function report() {
	 window.open("#SESSION.root#/System/Modules/Subscription/RecordListing.cfm?ts="+new Date().getTime(), "portalright", "width=370, height=250, toolbar=no, scrollbars=no, resizable=no");
}

function clearance() {
	 window.open("../System/EntityAction/EntityView/MyClearances.cfm?time=#now()#", "portalright", "width=370, height=250, toolbar=no, scrollbars=no, resizable=no");
}

function exit() {
	 window.open("#SESSION.root#/Tools/Control/LogoutExit.cfm?time=#now()#", "_top");
}

function languageswitch(lan) {    
     ColdFusion.navigate('#SESSION.root#/Tools/Language/switch.cfm?ID=' + lan + '&menu=yes','lanbox') 
	
}


</script>

<!--- verify if subscription --->

<cfset ht = "18">

<!--- Search form --->

<tr><td>
 <table width="100%" cellspacing="0" cellpadding="0">
   <tr>
   	<td height="18" class="top3n" style="border-top:1px solid ##d4d4d4; border-bottom:1px solid ##d4d4d4;padding-left:5px">
   		<font size="2" style="font-family: Calibri; color: 072d4d"><b>&nbsp;<cf_tl id="Quick Links"><b></font>
	</td>
   </tr>
 </table>
</td></tr>

<tr><td height="3"></td></tr>

<!--- reports --->

<cf_verifyOperational checkmodule="Reporting" Warning="No">

<CFOBJECT ACTION="CREATE"
	TYPE="JAVA"
	CLASS="coldfusion.server.ServiceFactory"
	NAME="factory">

	<CFSET dsService=factory.getDataSourceService()>
				
	<cftry>
	
		<cfif dsService.verifyDatasource("AppsSystem")>		
		
			<cfquery name="QA" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    count(*) as Counted
			FROM      HelpProjectTopic
			WHERE ProjectCode = 'xxxxInsurance'
			<!---
			WHERE     ProjectCode = '#module#' 
			--->
			
			<!---
			AND       TopicClass = 'General'
			--->
			</cfquery>
		
			<cfif moduleEnabled eq "1" and QA.counted gte "1">
			
			    <cfset cnt = cnt+1>
			
				<tr><td align="center">
				      
				  <table bgcolor="e5f2ff" width="100%" height="#ht#" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="E8EFF7" style="border-collapse: 
				  onClick="subselected('mmenu','#cnt#'); qa()" 
				  onMouseOver="h2(this,true,'Q and A')" onMouseOut="h2(this,false,'')" id="mmenu#cnt#">
				     
					  <tr>
					     <td width="50%" align="#Attributes.align#" class="regular" style="padding-left:10px">
						 <cf_tl id="QA">&nbsp;</td>
					  </tr>
				      
				  </table>
				  
				</td></tr>
							 
			</cfif> 
		
		</cfif>	
	
	<cfcatch></cfcatch>	
	
	</cftry>	


<cfquery name="Favorite" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    TOP 1 *
FROM      UserFavorite
WHERE Account = '#SESSION.acc#' 
</cfquery>

<cfif Favorite.recordcount eq "0">
 <cfset cl = "hide">
<cfelse>
 <cfset cl = "regular">
</cfif>  

<cfset cnt = cnt+1>

<tr id="favfunction"><td align="center">
	      
	  <table bgcolor="e5f2ff" width="100%" height="#ht#" border="0" cellspacing="0" cellpadding="0" align="center"  
	   onClick="subselected('mmenu','#cnt#'); favorite()" 
	  onMouseOver="h2(this,true,'Favorite')" onMouseOut="h2(this,false,'')" id="mmenu#cnt#">
	     
	  <tr>
	     <td width="50%" align="#Attributes.align#"  class="regular" style="padding-left:10px">
		 <cf_tl id="Favorite Functions">&nbsp;</td>
	  </tr>
	      
	  </table>
	  
	</td>
</tr>

<cfset cnt = cnt+1>
  
<tr><td align="center">
      
  <table bgcolor="e5f2ff" width="100%" height="#ht#" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="E8EFF7" 
	   onClick="subselected('mmenu','#cnt#'); clearance()" 
       onMouseOver="h2(this,true,'Clearances')" 
	   onMouseOut="h2(this,false,'')" id="mmenu#cnt#">
     
  <tr>
     <td width="50%" align="#Attributes.align#" class="regular" style="padding-left:10px">
	 <cf_tl id="Pending for Actions">&nbsp;</td>
  </tr>
      
  </table>
  
</td></tr>


<cfquery name="Report" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT top 1 *
FROM UserReport
WHERE Account = '#SESSION.acc#' 
</cfquery>

<cfif moduleEnabled eq "1" and Report.recordcount gte "1">

	<cfset cnt = cnt+1>
  
	<tr><td align="center">
	      
	  <table bgcolor="e5f2ff" width="100%" height="#ht#" border="0" cellspacing="0" cellpadding="0" align="center"  
	   onClick="subselected('mmenu','#cnt#'); report()" 
	  onMouseOver="h2(this,true,'Feedback')" onMouseOut="h2(this,false,'')" id="mmenu#cnt#">
	     
	  <tr>
	     <td width="50%" align="#Attributes.align#"  class="regular" style="padding-left:10px">
		 <cf_tl id="Report Subscription">&nbsp;</td>
	  </tr>
	      
	  </table>
	  
	</td></tr>
	
</cfif>

<cfif moduleEnabled eq "1" and  Report.recordcount gte "1">

	<cfset cnt = cnt+1>

	<tr><td align="center">
	      
	  <table bgcolor="e5f2ff" width="100%" height="#ht#" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="E8EFF7" 
	  style="border-collapse:"  onClick="subselected('mmenu','#cnt#'); dashboard()" 
	  onMouseOver="h2(this,true,'Dashboard')" onMouseOut="h2(this,false,'')" id="mmenu#cnt#">
	     
		  <tr>
		     <td width="50%" align="#Attributes.align#" class="regular" style="padding-left:10px">
			 <cf_tl id="Extended Dashboard">&nbsp;</td>
		  </tr>
	      
	  </table>
	  
	</td></tr>
		 
</cfif> 

<cfquery name="check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT top 1 *
FROM   BroadCast
WHERE OfficerUserId = '#SESSION.acc#' 
</cfquery>

<cfif check.recordcount gte "1">

	<cfset cnt = cnt+1>

	<tr><td align="center">
	      
	  <table bgcolor="e5f2ff" width="100%" height="#ht#" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="E8EFF7" 
	   onClick="subselected('mmenu','#cnt#'); broadcast()" 
	  onMouseOver="h2(this,true,'Broadcast')" onMouseOut="h2(this,false,'')" id="mmenu#cnt#">
	     
		  <tr>
		     <td width="50%" align="#Attributes.align#" class="regular" style="padding-left:10px">
			 <cf_tl id="Broadcast Mail">&nbsp;</td>
		  </tr>
	      
	  </table>
	  
	</td></tr>
 
</cfif> 

<!--- ------------ --->
<!--- set password --->
<!--- ------------ --->

<cfset cnt = cnt+1>
  
<tr><td align="center">
      
  <table bgcolor="e5f2ff" width="100%" height="#ht#" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="E8EFF7" 
  onClick="subselected('mmenu','#cnt#'); password()" 
  onMouseOver="h2(this,true,'Set password')" onMouseOut="h2(this,false,'')" id="mmenu#cnt#">
     
  <tr>
     <td width="50%" align="#Attributes.align#" class="regular" style="padding-left:10px">
	 <cf_tl id="Set Password">&nbsp;</td>
  </tr>
      
  </table>
  
</td></tr>

<tr><td height="5"></td></tr>
<tr><td height="1px" bgcolor="silver"></td></tr>
<tr><td height="5"></td></tr>

</cfoutput>

<cfquery name="getAccount" 
    datasource="AppsSystem">
     SELECT *
     FROM   UserNames
     WHERE  Account = '#SESSION.acc#' 	
   </cfquery>  

<cfquery name="Language" 
 datasource="AppsSystem"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_SystemLanguage	 
	 <cfif getAccount.Pref_SystemLanguage neq "">	 
	 WHERE  Code = '#getAccount.Pref_SystemLanguage#'	 
	 <cfelse>
	 WHERE  Operational IN ('1','2')	 
	 </cfif>
</cfquery> 

<tr><td height="15" align="left">&nbsp;&nbsp;
	<select name="language" id="language" onChange="languageswitch(this.value)" style="background: ffffff; font-size : 10px;" >
	  <cfoutput query="Language">
	  <option value="#Code#" 
	      <cfif Code eq "#CLIENT.LanguageId#">selected</cfif>>#LanguageName#</option>
	  </cfoutput>
	</select>
</td></tr>

<tr><td height="5" id="lanbox"></td></tr>

<tr><td style="border-top: 1px solid Silver;"></td></tr>
<tr><td height="5"></td></tr>
<tr><td class="regular">	
	
	<table cellpadding="0" cellspacing="0" border="0">
		<tr>
		
		<cfparam name="URL.ID"  default="">
			
			<cfinvoke component="Service.Access" 
  				method        = "employee" 
  				personno      = "#URL.ID#" 
  				returnvariable= "Officer">
					  
		<cfquery name="Employee" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
    		SELECT *
    		FROM   Person
    		WHERE  PersonNo = '#CLIENT.PersonNo#'
		</cfquery>
							
		  <cfset pad = "10px">
			
	<td style="padding-left:<cfoutput>#pad#</cfoutput>" valign="middle">
	<table cellspacing="0" cellpadding="0" align="center">
		<tr><td><cfoutput>#SESSION.first# #SESSION.last#</cfoutput></td></tr>
		<tr><td>
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
			<tr><td height="5"></td></tr>
	        
			<tr><td class="line" colspan="2"></td></tr>
			<tr>
				<td><font size="-3" color="808080"><cf_tl id="Logon">:&nbsp;</font></td>
				<td><font size="-3" color="808080"><cfoutput>#SESSION.acc#</cfoutput></td>
			</tr>
			
			
			<tr>			
			<td><font size="-3" color="808080"><cf_tl id="Last">:&nbsp;</font></td>
			<td>			
			       <cfquery name="Last" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT TOP 1 ActionTimeStamp
						FROM     UserStatusLog 
						WHERE    Account        = '#SESSION.acc#'
						AND      HostSessionNo <> '#CLIENT.SessionNo#'
						ORDER BY ActionTimeStamp DESC
				  </cfquery>
					
				  <cfoutput><font size="-3" color="808080">#DateFormat(Last.ActionTimeStamp, "MMM, DD")# #DateFormat(Last.ActionTimeStamp, "HH:MM")#</cfoutput>
				  
			</td>
			
			</tr>	
			<tr><td class="line" colspan="2"></td></tr>
				 
			</table>
		 </td></tr>

	</table>
</td></tr></table></td></tr>


<tr><td height="1"></td></tr>
<tr><td ></td></tr>


