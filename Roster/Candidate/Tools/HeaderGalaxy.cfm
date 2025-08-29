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
	 <TITLE>Roster management</TITLE> <LINK REL="STYLESHEET" HREF="../<cfoutput>#client.style#</cfoutput>">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" content="-1">
 </HEAD> 
   
  <BODY TOPMARGIN="0" LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0"
	LINK="#000066" VLINK="#000066" ALINK="#FF0000"> 
	
	<!---
	<script LANGUAGE="Javascript">
	<!-- Begin
	function NewWindow(mypage, myname, w, h, scroll) {
	var winl = (screen.width - w) / 2;
	var wint =    (screen.height -
	h)  /2;winprops='height='+h+',width='+w+',top='+wint+',left='+winl+',scrollbars='+scroll+',resizable=no'
	win = window.open(mypage, myname, winprops)
	if (parseInt(navigator.appVersion) >= 4) { win.window.focus(); }
	}
	//  End -->
	
	</script> 
	--->
		
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0"> 
		<TR> 
		  <td colspan="2" bgcolor="#6098FF"> 
			 <TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0" BACKGROUND="Images/bg.gif"> 
				<TR> 
				  <td height="21" class="top4n"><b>&nbsp;Skills inventory</b>
				  <!---
				  <IMG SRC="images/0001.gif" BORDER="0" ALIGN="TOP" WIDTH="200" HEIGHT="26">
				  --->
				  </td> 
				  <TD ALIGN="RIGHT" class="top4n">
				  <b>Help&nbsp;|</b>
				  <!---
				  <a HREF="help/help.htm" ONCLICK="NewWindow(this.href,'name','330','450','yes');return false;">
				   <IMG SRC="images/help.gif" BORDER="0" WIDTH="42" HEIGHT="17"></a>
				   --->
				   <b>&nbsp;<a href="../login/Default.cfm" target="_top">Logout</a>&nbsp;</b>
				  
				  </TD> 
				</TR> 
				<tr><td height="2" colspan="2" class="topn"></td></tr>
			 </TABLE></td> 
		</TR><TR><TD BGCOLOR="6098FF"><IMG SRC="<cfoutput>#SESSION.root#</cfoutput>/Images/pic1.gif" BORDER="0" WIDTH="70" HEIGHT="45" ALIGN="ABSBOTTOM"></TD><TD BGCOLOR="6098FF" ALIGN="RIGHT" VALIGN="BOTTOM">
		<IMG SRC="<cfoutput>#SESSION.root#</cfoutput>/Images/logo1.gif" WIDTH="169" HEIGHT="33" BORDER="0"></TD></TR> 
		<TR> 
		  <TD BGCOLOR="#323464" VALIGN="TOP" HEIGHT="15">
		  <IMG SRC="<cfoutput>#SESSION.root#</cfoutput>/Images/pic2.gif" WIDTH="70" HEIGHT="21" BORDER="0" ALIGN="ABSMIDDLE">
		  </TD><TD BGCOLOR="#323464" VALIGN="TOP" HEIGHT="15" ALIGN="RIGHT">
		  
		  <IMG SRC="<cfoutput>#SESSION.root#</cfoutput>/Images/logo2.gif" WIDTH="169" HEIGHT="21" BORDER="0">
		  </TD> 
		</TR> 
	 </TABLE>
	 
	 <cfoutput>
	 <table width="99%" align="center">
	 <tr><td height="2"></td></tr>
	 <tr>
	 <td class="regular">
		 <b>Name: #SESSION.first# #SESSION.last#</b>
	 </td>
	 <td align="right" class="regular">Applicant data as of: #DateFormat(now()-1,CLIENT.DateFormatShow)#</td>
	 </tr>
	  <tr><td height="2"></td></tr>
	 </table>
	 
	 </cfoutput>