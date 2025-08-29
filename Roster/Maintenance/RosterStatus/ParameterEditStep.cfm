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
<cfparam name="attributes.name"    default="content">
<cfparam name="attributes.bgcolor" default="ffffff">
<cfparam name="attributes.font"    default="10pt verdana">
<cfparam name="attributes.height"  default="355">
<cfparam name="attributes.images"  default="exampleimages">
<cfparam name="attributes.border"  default="0">
<cfparam name="url.id"  default="{5815AB7A-3C66-4922-8B0D-2266056E6A9F}">

<cfquery name="Action" 
 datasource="AppsSelection"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM   Ref_StatusCode 		
 WHERE  Owner = '#URL.Owner#' 
 AND    Id = 'Fun'
 AND    Status = '#URL.Status#'
</cfquery>

<cf_textareascript>

<cf_screentop layout="webapp" banner="blue" jQuery="yes" scroll="Yes"
         height="100%" label="#URL.Owner# - #URL.Status#: #Action.Meaning#">

<cfoutput>
	
<cfparam name="URL.Mode" default="View">

<script language="JavaScript">
	
	<cfif #URL.Mode# eq "Print">
		
	{
	  w = #CLIENT.width# - 100;
	  h = #CLIENT.height# - 140;
	  window.open("ActionPrint.cfm?id=#URL.ID#","_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  	}
	
	</cfif>
	
	function ClearRow(row,itm) {		
		rw = document.getElementById(row+"0")
		rw.style.fontWeight='normal';
		rw = document.getElementById(row+"1")
		rw.style.fontWeight='normal';
		rw = document.getElementById(row+itm)
		rw.style.fontWeight='bold';	
	}
	
	function toggle(val) {
		
		if (val == "BATCH") {
			 document.getElementById("delay1").className = "labelit"
			 document.getElementById("delay2").className = "labelit"		  
		} else {
			 document.getElementById("delay1").className = "hide"
			 document.getElementById("delay2").className = "hide"		  
		}	
				
		if (val != "NONE") {
		 	 document.getElementById("mail_a").className = "labelit"
		 	 document.getElementById("mail_b").className = "labelit"
			 document.getElementById("mailSubLabel").className = "labelit"
			 document.getElementById("mailBodyVariables").className = "labelit"
		} else {
		  	 document.getElementById("mail_a").className = "hide"		
		 	 document.getElementById("mail_b").className = "hide"
			 document.getElementById("mailSubLabel").className = "hide"	  
			 document.getElementById("mailBodyVariables").className = "hide"
		}	
		
	}
	
</script>

</cfoutput>

<cfquery name="Denied" 
 datasource="AppsSelection"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	 SELECT *
	 FROM Ref_StatusCode 		
	 WHERE Owner = '#URL.Owner#' 
	 AND   Id = 'Fun'
	 AND   Status != '9'
</cfquery>

<cfoutput query="Action">

	<cfform action="ParameterEditStepSubmit.cfm?Owner=#URL.Owner#&Status=#URL.Status#" 
	        target="result" 
			style="height:98%"
			method="post">	
	
	<table width="95%" height="100%" align="center">	   		
							     	   
	  	   <tr class="hide" colspan="2"><td><iframe name="result" id="result"></iframe></td></tr>
				   			      
		   <tr><td height="40" colspan="2" style="padding-top:2px">
			
					<!--- top menu --->
							
					<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
									
						<cfset ht = "48">
						<cfset wd = "48">
						
						<cf_menuScript>
										
						<tr>					     
									
							<cf_menutab item       = "1" 
						            iconsrc    = "Logos/System/Maintain.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 									
									class      = "highlight1"
									name       = "Authorization and Process Settings">			
													
							<cf_menutab item       = "2" 
						            iconsrc    = "Logos/System/Mail.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 									
									name       = "Mail Notification">												
											 		
								<td width="10%"></td>	
															 		
							</tr>
					</table>
			
				</td>
		   </tr>	
			 
		   <tr><td colspan="2" style="border-top:1px dotted silver"></td></tr> 
	 	  
		   <tr>
		   
		    <td style="height:35" class="labelit">Label:</td>
			
			<td>
				<table>
				<tr><td>
				<cfinput type="Text" class="regularxl" name="Meaning" value="#Meaning#" message="Please enter a description" required="Yes" size="50" maxlength="60">
				</td>
				<td class="labelit" style="padding-left:10px"><cf_UIToolTip tooltip="The roster status assignment routine works as soon as this status is reached.">
					= Pre roster status:
					</cf_UIToolTip>
				</td>
				<td><input type="checkbox" style="width:15px;height:15px" name="PreRosterStatus" value="1" <cfif Prerosterstatus eq "1">checked</cfif>></td>
				</tr>
				</table>
			</td>
		   </tr>
		   	   
	 <tr><td colspan="2" style="border-top:1px dotted silver"></td></tr> 
		
	 <tr><td colspan="2" height="100%" valign="top">  
	 
	 	 <cf_divscroll>
	  		 
			 <table width="100%" height="100%" cellspacing="0" cellpadding="0"> 
				   
			 <cf_menucontainer item="1" class="regular">				   
				   <cfinclude template="ParameterEditStepSettings.cfm">			   
			 </cf_menucontainer>	
			 
			 <cf_menucontainer item="2" class="hide">	   			   
				   <cfinclude template="ParameterEditStepMail.cfm">			   
			 </cf_menucontainer>	
			 
			 </table>
		 
		 </cf_divscroll>
		  
	 </td></tr>    
		     	   
	 <tr>
	 	   <td colspan="2" height="30" style="padding-bottom:10px" align="center">
	       	<input type="button" name="cancel" value="Cancel" class="button10g" onClick="window.close()">
	      	<input type="submit" name="save" value="Submit" class="button10g">
	      </td>
	 </tr>	
		 	
	</table>
					
	</cfform>		
	
<script>toggle('#MailConfirmation#');</script>	
	
</cfoutput>	

<cf_screenbottom layout="webapp">

