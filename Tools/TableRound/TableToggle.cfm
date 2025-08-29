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
<cfparam name="Attributes.Id" default="">
<cfparam name="Attributes.Header" default="Option">
<cfparam name="Attributes.TooltipS" default="show #Attributes.Header#">
<cfparam name="Attributes.TooltipH" default="hide #Attributes.Header#">
<cfparam name="Attributes.Height" default="10">
<cfparam name="Attributes.Size" default="100%">
<cfparam name="Attributes.Button" default="">
<cfparam name="Attributes.Scroll" default="0">
<cfparam name="Attributes.Class" default="labelmedium">
<cfparam name="Attributes.Icon" default="">
<cfparam name="Attributes.Mode" default="show">
<cfparam name="Attributes.Color" default="ffffff">
<cfparam name="Attributes.bgimage1" default="">
<cfparam name="Attributes.bgimage2" default="">
<cfparam name="Attributes.border" default="1">
<cfparam name="Attributes.line" default="1">
<cfparam name="Attributes.bordercolor" default="e4e4e4">

<cfoutput>
<script language="JavaScript">

function maximize(itm,icon){
	
	 se   = document.getElementById(itm)
	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
	 
	 if (se.className == "regular") {
	 se.className = "hide";
	 icM.className = "hide";
	 icE.className = "regular";
		
	 } else {
	 se.className = "regular";
	 icM.className = "regular";
	 icE.className = "hide";	
	 window.scroll(0,#Attributes.Scroll#)		
	 }
  }  
  
</script> 

<table width="#Attributes.size#" border="#Attributes.border#" align="center" bordercolor="#Attributes.bordercolor#">
  
<tr class="<cfif attributes.line eq "1">line</cfif>">
<td height="#Attributes.height#" class="#Attributes.Class#" bgcolor="#Attributes.Color#">

	<table width="100%" 
	  onclick="javascript: maximize('#Attributes.id#','Exp')" style="cursor: pointer;">
	  <tr>
	   <td style="height:30px" width="10">&nbsp;</td>
	   <td width="20" align="left">
	   
		   <cfif Attributes.id neq "">
		   
			   <cfif Attributes.Mode eq "Show">
			   
			      <img src="#SESSION.root#/Images/icon_expand.gif" alt="#Attributes.TooltipS#" 
					id="#Attributes.id#Exp" border="0" class="hide" 
					align="middle" style="cursor: pointer;">
					
					<img src="#SESSION.root#/Images/icon_collapse.gif" 
					id="#Attributes.id#Min" alt="#Attributes.TooltipH#"  border="0" 
					align="middle" class="show" style="cursor: pointer;">
								   
				<cfelse>
				
				<img src="#SESSION.root#/Images/icon_expand.gif" alt="#Attributes.TooltipS#"  
					id="#Attributes.id#Exp" border="0" class="show" 
					align="middle" style="cursor: pointer;">
					
					<img src="#SESSION.root#/Images/icon_collapse.gif" 
					id="#Attributes.id#Min" alt="#Attributes.TooltipH#"  border="0" 
					align="middle" class="hide" style="cursor: pointer;">
							
				</cfif>	   
				
			<cfelse>
				
				<img src="#SESSION.root#/Images/#Attributes.icon#" alt="" 
					id="#Attributes.id#Exp" border="0" class="show" 
					align="middle">
										
			</cfif>
			
	   </td>	  	  
	   <cfif Attributes.id neq "">
	   <td align="left" class="labelmedium">#Attributes.Header#</font></a></td>
	   <cfelse>
	   <td align="left"  class="labelmedium">#Attributes.Header#</b></td>
	   </cfif>
	  
	   <td align="right" width="40">
	   <cfif Attributes.Button neq "">
             <input type="button" value="#Attributes.Button#" class="button7" onClick="#Attributes.Script#">&nbsp;
        </cfif>			  
	   </td>
	</tr>  
	</table>
	
</td></tr>	

</table>

</cfoutput>   