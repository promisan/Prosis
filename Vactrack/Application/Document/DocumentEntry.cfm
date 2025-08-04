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
<cfparam name="URL.Caller" default="">
<cfparam name="URL.ID1" default="">

<CFIF url.id1 neq "">
  <cfinclude template="DocumentEntryPosition.cfm">
  <cfabort>
</CFIF>

<cf_dialogPosition>
<cf_calendarscript>

<cfquery name="Mis" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT M.Mission, 
                  M.MissionOwner
  FROM  Ref_Mission M, Ref_MissionModule R
  WHERE M.Mission    = R.Mission
  AND   R.SystemModule = 'Vacancy'
  AND   M.Operational = 1
  AND   M.Mission IN (SELECT Mission 
                      FROM   Ref_Mandate 
					  WHERE  DateExpiration > getDate())  				
  <cfif SESSION.isAdministrator eq "No">				
  AND (
  
      M.Mission IN (SELECT DISTINCT A.Mission
					FROM     OrganizationAuthorization A INNER JOIN
					         Ref_EntityAction R ON A.ClassParameter = R.ActionCode
					WHERE   A.UserAccount = '#SESSION.acc#' 
					AND     R.EntityCode = 'VacDocument'
					AND     R.ActionType = 'Create')  
	  OR M.Mission IN (SELECT DISTINCT Mission 
	                   FROM OrganizationAuthorization
					   WHERE   UserAccount = '#SESSION.acc#' 
					   AND     Role = 'VacOfficer')
	   )
	               				
  </cfif>	
 		
</cfquery>

<cfoutput>

	<script LANGUAGE = "JavaScript">

		function search() {		
			mis = document.getElementById("mission").value
			grd = document.getElementById("postgrade").value
			url = "DocumentEntryFind.cfm?mission="+mis+"&postgrade="+grd
			ptoken.navigate(url,'search')		  
		}
				
		function selected(pos) {	
		    ProsisUI.createWindow('mydialog', 'Recruitment Track', '',{x:100,y:100,height:600,width:640,modal:true,resizable:false,center:true})    					
			ptoken.navigate('#SESSION.root#/Vactrack/Application/Document/DocumentEntryPosition.cfm?ID1=' + pos + '&Caller=entry','mydialog')	
		}
		
		function Selected(no,description) {									
			document.getElementById('functionno').value = no
			document.getElementById('FunctionDescription').value = description					 
			ProsisUI.closeWindow('myfunction')
		 }	
		
	</script>

</cfoutput>

<cfif mis.recordcount eq "0">

	<cf_message Message="Problem, you are <b>NOT</b> authorised to register vactracks" return="back">
	<cfabort>

</cfif>

<cfif url.caller eq "Listing">
  <cfset html = "Yes">
<cfelse>
  <cfset html = "No">  
</cfif>

<cfajaximport tags="cfform">

<cf_screentop html="#html#" height="100%" label="Recruitment Request" layout="innerbox" scroll="Yes" jQuery="Yes">

<table width="94%" height="100%" align="center">

  <tr><td height="10"></td></tr>
  <tr>
    <cfoutput>
    <td class="labelit" width="100%" height="46" align="left" valign="middle" style="height:54px;font-size:28px">
	 <cf_tl id="Initiate Recruitment Request" class="Message">
	</td>
	</cfoutput>
  </tr> 	
     
  <tr style="height:50px">
    <td>
	    <table>
					
		<TR class="labelmedium2">
	    		
	    <td height="20" style="width;auto"><cf_tl id="Tree/Organization">:</td>
		<td style="padding-left:4px">	
			     
			 <select name="mission" id="mission" class="regularxl" style="border:0px;background-color:f1f1f1;font-size:20px;height:34px">
			 
				 <cfoutput query="Mis">
				 <cfinvoke component="Service.Access"  
			          method="vacancytree" 
			    	  mission="#Mission#"
				      returnvariable="accessTree">
		   
		 			 <cfif AccessTree neq "NONE">
						 <option value="#Mission#" class="regularxl">#Mission#</option>
					 </cfif>		 
				 </cfoutput>
			 </select>			 
					 
	    </td>	
			
	    <TD style="padding-left:10px;width;auto"><cf_tl id="Grade/Level">:</TD>
	    <TD style="padding-left;4px">		
		<cf_securediv bind="url:DocumentEntryGrade.cfm?mission={mission}" id="gradebox">				
		</TD>
		
		<td align="center" style="padding-left:10px">
	  		  <cf_tl id="View Positions" var="1">
			  <input class="button10g"
				     type="button" 
				     style="width:220px;font-size:18px;height:34px;border:0px;background-color:f1f1f1;"
					 name="Submit" 
					 value="<cfoutput>#lt_text#</cfoutput>" 
					 onclick="search()">
			</td>
		
		</TR>	
			
		</TABLE>
	   </td>
	</tr>
				
	<tr>
		<td class="line" style="height:100%">
		<cf_divscroll><cfdiv id="search"></cf_divscroll>
		</td>
	</tr>
		
</TABLE>

<cfif url.caller eq "Listing">
  <cfset html = "Yes">
<cfelse>
  <cfset html = "No">  
</cfif>

<cf_screenbottom html="#html#" layout="innerbox">

