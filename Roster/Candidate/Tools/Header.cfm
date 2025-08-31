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
   <HEAD> 
	 <TITLE>Roster management</TITLE> <LINK REL="STYLESHEET" HREF="../../<cfoutput>#client.style#</cfoutput>">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" content="-1">
 </HEAD> 
   
   <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
   
  <BODY TOPMARGIN="0" LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0"> 
			
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"> 
	
		<TR> 
		  <td height="2" colspan="2" bgcolor="000000"></td>
  		</TR> 
		
		<TR> 
		  <td colspan="2"> 
			 <TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0"> 
				<TR> 
				  <td height="21" class="top3n"><b>&nbsp;DPKO/PMSS Initiative</b>
				  <!---
				  <IMG SRC="images/0001.gif" BORDER="0" ALIGN="TOP" WIDTH="200" HEIGHT="26">
				  --->
				  </td> 
				  <TD ALIGN="RIGHT" class="top3n">
				  <b>Help&nbsp;|</b>
				  <!---
				  <a HREF="help/help.htm" ONCLICK="NewWindow(this.href,'name','330','450','yes');return false;">
				   <IMG SRC="images/help.gif" BORDER="0" WIDTH="42" HEIGHT="17"></a>
				   --->
				   <cfoutput>
			   	   <b>&nbsp;<a href="../login/UserPassword.cfm?id=#URL.ID#" target="_top">Set password</a>&nbsp;|</b>
  				   </cfoutput>			   				 				   
				   
				   <b>&nbsp;<a href="../../../Default.cfm" target="_top">Nucleus</a>&nbsp;|</b>
								   
				   <b>&nbsp;<a href="../Default.cfm" target="_top">Logout</a>&nbsp;</b>
				  
				  </TD> 
				</TR> 
				
				<TR> 
				  <td height="1" colspan="2" bgcolor="000000"></td>
  				</TR> 
				
			 </TABLE></td></TR>
			 <TR><td height="20" valign="bottom" bgcolor="#DCEDDC">
			 <!---
			 &nbsp;
			 <font face="Georgia, Times New Roman, Times, serif" size="1"><strong> 
			 Skills Inventory</b></font>
			 --->
			 </td>
			 			 
		<TR> 
		  <td height="1" colspan="2" bgcolor="000000"></td>
  		</TR> 
		
		<tr><td height="4"></td></tr>
		
	 </TABLE>
	
	 <cfoutput>
	 	 
	 </cfoutput>