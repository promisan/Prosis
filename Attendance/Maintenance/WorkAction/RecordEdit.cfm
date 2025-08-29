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
<cfparam name="url.idmenu" default="">

<cfset vOpt = "Maintain Action - #url.id1#">
<cfif url.id1 eq "">
	<cfset vOpt = "Create Action">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Time Sheet Action" 			
			  banner="yellow"
			  menuAccess="Yes" 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	A.*
		FROM 	Ref_WorkAction A
		WHERE 	A.ActionClass = '#URL.ID1#'
</cfquery>

<cfoutput>
	<cf_colorScript>

	<script language="JavaScript">
	
		function addMission(id1) {
		   var vWidth = 500;
		   var vHeight = 250;    
		   
		   ProsisUI.createWindow('mydialog', 'Entities', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    		   				
		   ptoken.navigate("WorkActionMissionListing.cfm?idmenu=#url.idmenu#&id1=" + id1 + "&ts=" + new Date().getTime(),'mydialog');
		}
		
		function selectMission(idMission, mission, color) {
			var control = document.getElementById('mission_'+idMission);
			var action = 0;

			if (control.checked) {
				document.getElementById('td_'+idMission).style.backgroundColor = color;
				action = 1;
			}else{
				document.getElementById('td_'+idMission).style.backgroundColor = '';
				action = 0;
			}
			
			ptoken.navigate('WorkActionMissionSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&mission='+mission+'&action='+action,'missionSubmit');
		}
	
	</script>

</cfoutput>


<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#" method="POST" name="dialog">

<table width="95%" class="formpadding formspacing" align="center">
	
	<tr><td height="10"></td></tr>
	
    <cfoutput>
    <TR class="labelmedium2">
    <TD width="35%"><cf_tl id="Action">:</TD>
    <TD>
  	   <cfif url.id1 eq "">
	   
	   		<cfinput type="text" 
		       name="ActionClass" 
			   value="#get.ActionClass#" 
			   message="Please enter a code"
			   required="yes" 
			   size="10" 
		       maxlength="10" 
			   class="regularxxl">
	   	
	   <cfelse>
	   
	   		#get.ActionClass#
	   		<input type="Hidden" name="ActionClass" id="ActionClass" value="#get.ActionClass#">
			
	   </cfif>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Parent Action">:</TD>
    <TD>
  	   <cfquery name="GetParent" 
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_TimeClass
				ORDER BY ListingOrder ASC
		</cfquery>
		
		<cfselect name="ActionParent" 
		     class="regularxxl" query="GetParent" 
			 display="Description" value="TimeClass" 
			 required="Yes" 
			 selected="#get.ActionParent#" 
			 message="Please select a parent action">
		</cfselect>
		
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>
  	   
	    <cfinput type="text" 
	       name="ActionDescription" 
		   value="#get.ActionDescription#" 
		   message="Please enter a description"
		   required="yes" 
		   size="30" 
	       maxlength="50" 
		   class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Order">:</TD>
    <TD>
  	   
	    <cfinput type="text" 
	       name="ListingOrder" 
		   value="#get.ListingOrder#" 
		   message="Please enter a numeric order" 
		   validate="integer"
		   required="yes" 
		   size="1" 
	       maxlength="3" 
		   class="regularxxl" style="text-align:center;">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Color">:</TD>
    <TD>
  	   
		<cf_color 	name="ViewColor" 
					value="#get.ViewColor#"
					style="cursor: pointer; font-size: 0; border: 1px solid gray; height: 20; width: 20; ime-mode: disabled; layout-flow: vertical-ideographic;">			
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Program Lookup">:</TD>
    <TD>
	   <table><tr>
	    <td><input type="radio" class="radiol" name="ProgramLookup" id="ProgramLookup" value="1" <cfif get.ProgramLookup eq "1">checked</cfif>></td>
		<td class="labelmedium" style="padding-left:5px">Yes</td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="ProgramLookup" id="ProgramLookup" value="0" <cfif get.ProgramLookup eq "0" or url.id1 eq "">checked</cfif>></td>
		<td class="labelmedium" style="padding-left:5px">No</td>
		</tr>
		</table>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Operational">:</TD>
    <TD>
	  <table><tr>
	    <td>
  	   	<input type="radio" class="radiol" name="Operational" id="Operational" value="1" <cfif get.Operational eq "1" or url.id1 eq "">checked</cfif>>
		</td>
		<td class="labelmedium" style="padding-left:5px">Yes</td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif get.Operational eq "0">checked</cfif>></td>
		<td class="labelmedium" style="padding-left:5px">No</td>
		</tr>
		</table>
    </TD>
	</TR>
	
	<cfif url.id1 neq "">
		<TR class="labelmedium2">
	    <TD><cf_tl id="Enabled Entities">:</TD>
	    <TD>
	  	   	<cfdiv id="divMission" bind="url:WorkActionMission.cfm?id1=#url.id1#">
	    </TD>
		</TR>
	</cfif>
		
	</cfoutput>
		
	<tr><td colspan="2" class="line"></td></tr>	
			
	<tr>
		
	<td align="center" colspan="2">	
    	<input class="button10g" type="submit" name="Update" id="Update" value="Save">
	</td>	
	</tr>
		
</TABLE>

</CFFORM>
	
<cf_screenbottom layout="innerbox">
