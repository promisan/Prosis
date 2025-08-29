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
<cfparam name="SESSION.root"  default="">

<cfif SESSION.root eq "">
	<cfquery name="Init" 
	        datasource="AppsInit" 
			maxrows=1>
			SELECT * 
			FROM Parameter
	</cfquery>
	
	<cfset SESSION.rootpath = "#Init.ApplicationRootPath#">
	<cfset SESSION.root = "#Init.ApplicationRoot#">
</cfif>

<cf_waitEnd>

<cfparam name="Attributes.Flush"  default="Yes">
<cfparam name="Attributes.text"   default="Please wait...">
<cfparam name="Attributes.total"  default="">
<cfparam name="Attributes.icon"   default="circle">
<cfparam name="Attributes.color"  default="002350">

<cfoutput>
<table width="70%" align="center" id="busy" name="busy">
  
  <tr><td height="30"></td></tr>
   
  <cfif Attributes.icon neq "Hide">
  
	   <tr><td height="10"></td></tr>
	   <tr>
	   <td align="center" valign="bottom"><b>
	   <cfif Attributes.icon eq "bar">
	       <img src="#SESSION.root#/Images/busy.gif" alt="" border="0" align="middle">
		   <tr><td height="2" bgcolor="silver"></td></tr>
		   <tr><td height="2" bgcolor="gray"></td></tr>
	   <cfelseif Attributes.icon eq "circle">
	       <img src="#SESSION.root#/Images/busy10.gif" alt="" border="0" align="middle">		
	   <cfelseif Attributes.icon eq "ajax">
	       <img src="#SESSION.root#/Images/wait.gif" alt="" border="0" align="middle">			      
	   <cfelseif Attributes.icon eq "clock">
	       <img src="#SESSION.root#/Images/busy10.gif" alt="" border="0" align="middle">	   
	   <cfelseif Attributes.icon eq "line">
	         <img src="#SESSION.root#/Images/busy9.gif" alt="" border="0" align="middle">	   
	   <cfelse>
	       <img src="#SESSION.root#/Images/busy2.gif" alt="" border="0" align="middle">
	   </cfif>
	   </td>
	   </tr>
   
   </cfif> 
   
  <tr><td height="2"></td></tr>
   
    <tr>
    <td align="center" class="labelmedium"><font color="#Attributes.color#">#Attributes.text#</font>
	 <cfif attributes.total eq "">
	    <input type="hidden" name="progress" id="progress"> 
	 <cfelse>
	    <input type="text" class="regular1" name="progress" id="progress" value="0" size="2" maxlength="2" class="message" style="width:17px;text-align: center;"> 
	    of &nbsp;#Attributes.total#
		&nbsp;
		
 	 </cfif>
   </td>
  </tr> 
  
</table>

</cfoutput>

<cfif attributes.flush eq "Force">
	<cftry>
		<cfflush>
	<cfcatch>
		<cfflush interval="1">
	    <cfflush interval="10000000">	
	</cfcatch>	
	</cftry>
 
</cfif>  

