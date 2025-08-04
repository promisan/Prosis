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

<cf_screentop scroll="yes" 
    height="100%" html="No" MenuAccess="Yes" jquery="Yes" SystemFunctionId="#url.idmenu#">

<cfquery name="Owner"
 	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_AuthorizationRoleOwner
		<cfif SESSION.isAdministrator eq "No">
		WHERE Code IN (SELECT ClassParameter 
		                FROM  OrganizationAuthorization 
						WHERE UserAccount = '#SESSION.acc#'
						AND   Role IN ('AdminSystem','OrgUnitManager'))
		</cfif>
</cfquery>
	
<cfif Owner.recordcount eq "0">

  <cf_message message="Problem you do not have access rights to define tree ownership" return="back">

</cfif>

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){
   	 
	 itm2  = 'MissionParent'
	 fld2 = document.getElementsByName(itm2)
	 
	 itm3  = 'MissionParentOrgUnit'
	 fld3 = document.getElementsByName(itm3)
	 	 	 	 		 	
	 if (fld != false){
		
	     fld2[0].style.visibility = "visible";	
		 fld3[0].style.visibility = "visible";	
		 
	 
	 }else{
		
         fld2[0].style.visibility = "hidden";	
		 fld3[0].style.visibility = "hidden";	
	
	 }
  }

</script>

<cfparam name="URL.ID" default="">
<cfparam name="DocumentNoTrigger" default="#URL.ID#">

<cfform action="MissionEntrySubmit.cfm?idmenu=#url.idmenu#" method="POST" name="missionentry">

	<table width="93%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	  <tr><td height="5"></td></tr>
	  <tr class="line">
	    <td width="100%" height="73" align="left" valign="middle" class="labellarge">
		<cfoutput>
		<img src="#SESSION.root#/Images/tree_large.gif" alt="" width="50" height="50" border="0">
		</cfoutput>
		<font color="b0b0b0" size="6">&nbsp;<cf)tl id="Entity"><cf_tl id="Inception"></b></font>
	    </td>
	  </tr> 	
	  	       
	  <tr>
	    <td width="100%">
	    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
		
		<TR>	    
	    <td width="180" class="labelmedium"><cf_tl id="Name">: <font color="FF0000">*</font></td>
		<td colspan="2">
	      	 <cfinput type="Text"
		       name="MissionName"
		       message="Please enter an organization name"       
		       required="Yes"
		       visible="Yes"
		       enabled="Yes"
		       showautosuggestloadingicon="True"
		       typeahead="No"
		       size="80"
		       maxlength="80"
		       class="regularxl enterastab">
		</td>
		</TR>	
			
		<TR>	    
	    <td class="labelmedium"><cf_tl id="Acronym">: <font color="FF0000">*</font></td>
		<td colspan="2">
	      	 <cfinput type="Text"
		       name="Mission"
		       message="Please enter an acronym (no blanks)"
		       required="Yes"
		       visible="Yes"
		       enabled="Yes"
			   validate="noblanks"
		       showautosuggestloadingicon="True"
		       typeahead="No"
		       size="20"
		       maxlength="20"
		       class="regularxl enterastab">
		</td>
		</TR>	
				
		<TR>
	    <TD class="labelmedium"><cf_tl id="Owner">:<font color="FF0000">*</font></TD>
	    <TD>
			<select name="Owner" id="Owner" class="regularxl enterastab">
	     	   <cfoutput query="Owner">
	        	<option value="#Owner.Code#">#Code#</option>
	         	</cfoutput>
		    </select>
	    </TD>
	   </TR>
		
	   <tr>				
		<td class="labelmedium"><cf_tl id="Tree mode">:</td>     
		<td class="labelmedium">
		   <input type="radio" class="radiol enterastab" name="Status" id="Status" value="1" checked>Static
		   <input type="radio" class="radiol enterastab" name="Status" id="Status" value="0">Dynamic (Check if tree is used as Workforce tree with mandates)
		   	
		</td>
	   </TR>	
	   
	   <tr>	   	
	   <td class="labelmedium" valign="top"><cf_tl id="Type">: <font color="FF0000">*</font></td>	  
	   <td class="labelmedium">
	   
		   <cfquery name="Type" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	       SELECT *
	       FROM  Ref_MissionType
		  </cfquery>
		  
		   <select name="MissionType" id="MissionType" class="regularxl enterastab">
			   <cfoutput query="Type">
			   	  <option value="#MissionType#">#MissionType#</option>
			   </cfoutput>
			  </select>
			  
		   <!---	  
		  
		  <table border="0" cellspacing="0" cellpadding="0">
	
		  <cfset cnt = 0>
	
		  <cfoutput query="Type">
		  
			   <cfset cnt=cnt+1>
			  
			   <cfif cnt eq "1">
		        <TR>			   
			   </cfif>				  
			  
			   <td><input type="radio" class="radiol enterastab" name="MissionType" id="MissionType" value="#MissionType#" <cfif CurrentRow eq "1">checked</cfif>></td>
			   <td class="labelmedium" style="padding-left:3px;padding-right:8px">#MissionType#</td>			
			   
			   <cfif cnt eq "4">
		         </TR>			   
				 <cfset cnt = 0>
			   </cfif>	 	
				
		 </cfoutput>
		  </table>
		  
		  --->
		
		</td>
		</TR>		
			
	    <td class="labelmedium"><cf_tl id="Prefix">: <font color="FF0000">*</font></td>
		<td colspan="2">
		<cfinput type="Text" name="MissionPrefix" message="Please enter a prefix" required="Yes" size="4" maxlength="4" class="regularxl enterastab">
		</td>
		</TR>		
			
		<tr> 		
			<TD class="labelmedium"><cf_tl id="Effective date"> <font color="FF0000">*</font></td>    
			<cf_calendarscript>		
			<td colspan="2"><cfset end = DateAdd("m",  2,  now())> 
		   	   	<cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Default=""
				Message="Please enter an effective date"
				class="regularxl enterastab"
				AllowBlank="False">	
			</td>
		</TR>
			
		<tr> 		
			<TD class="labelmedium"><cf_tl id="Staffing period Expiration"><font color="FF0000">*</font></td>	    
			<td colspan="2"><cfset end = DateAdd("m",  2,  now())> 
		   	   	<cf_intelliCalendarDate9
				Default=""
				class="regularxl enterastab"
				Message="Please enter an expiration date"
				FieldName="DateExpiration" 
				AllowBlank="False">	
			</td>
		</TR>		
		
		<tr class="line"><td height="20" colspan="2" class="labelmedium" style="font-size:21px;padding-top:10px">Custom Fields</td></tr>
		
		<tr>
		<td colspan="2" style="padding-left:20px">		
			<cfdiv bind="url:getMissionType.cfm?mission=&missiontype={MissionType}">						
		</td>
		</tr>
			
		<cfquery name="ModuleAll" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   F.*, '' as SelectedMission
			FROM     Ref_SystemModule F 
			WHERE    F.Operational = '1'
			AND      F.SystemModule NOT IN ('System','Reporting','Portal','Selfservice')
			ORDER BY F.SystemModule 
		</cfquery>
			
		<script language="JavaScript">
	
			ie = document.all?1:0
			ns4 = document.layers?1:0
		
			function sel(itm,fld){
			 	 		 	
			 if (fld != false){		     		
				 document.getElementById(itm+'2').className = "highLight1 labelmedium";
				 document.getElementById(itm+'3').className = "highLight1 labelmedium";			 
			 }else{		 
				 document.getElementById(itm+'2').className = "labelmedium";
				 document.getElementById(itm+'3').className = "labelmedium";
			 }
			}
	
		</script>
		
		<tr><td height="4"></td></tr>
		<tr class="line"><td colspan="2" height="20" class="labelmedium" style="font-size:21px;padding-top:10px"><cf_tl id="Modules"></td></tr>
				
		<tr>
		<td colspan="2">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		
			<tr>	
				<td colspan="1">
				
				  <table width="100%" cellpadding="0" align="left">
				 
					  <tr>
					  <td style="padding-left:20px">
					  
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					 
					    <cfset cnt = 0>
					   
					    <cfoutput query="ModuleAll"> 
						
							 <cfset cnt = cnt+1>				   
						
				   		     <cfif cnt eq "1"><tr style="<cfif currentrow gte "2">border-top:1px solid silver</cfif>"></cfif>
						 				     	
					    	 <TD id="#SystemModule#2" class="labelmedium" style="padding-left:4px">#Description#</TD>
					         <TD align="right" 
							     id="#SystemModule#3" 
								 width="30" 								
								 style="padding-right:10px">
								 
					              <input type="checkbox" 								  
								         class="enterastab radiol" 
										 name="SystemModule" 
										 id="SystemModule" 
										 value="#SystemModule#" 
										 onClick="sel('#SystemModule#',this.checked)">							
										 
					         </TD>
							 
							<cfif cnt eq "3"></tr><cfset cnt = 0></cfif>	 		
							 
					    </cfoutput> 
						
				   	  </table>
					  </td>
				      </tr>
				  
				</table>
				
			</td>
			</tr>		
			</table>
		</td>
		</tr>
			
		<tr><td colspan="2" class="line"></td></tr>
		<tr><td colspan="4" align="center" height="30">		
			<input class="button10g" type="button" name="cancel" id="cancel" value="Cancel" onClick="history.back()">
			<input class="button10g" type="submit" name="Submit" id="Submit" value="Create">	
		</td></tr>
		
	</TABLE>
	</td>
	</tr>
	
</table>


</CFFORM>

