
<cfquery name="Get" 
datasource="AppsInit">
	SELECT *
	FROM Parameter 
	WHERE HostName = '#URL.host#' 
</cfquery>

<cfform method="POST" name="editform"  onsubmit="return false">

	<input type="hidden" name="Form.HostName" id="Form.HostName" value="#get.hostname#">

	<table width="90%" border="0" class="formspacing" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td height="8"></td></tr>
			    
    <TR>
    <td width="160" class="labelmedium">Title:</b></td>
    <TD>
		<table cellspacing="0" cellpadding="0">
		<tr><td>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="SystemTitle" value="#SystemTitle#" message="Please enter a system name" required="Yes" size="20" maxlength="20">
		</cfoutput>
		</td>
		<td style="padding-left:20px" class="labelmedium">Release:</td>
	    <TD style="padding-left:10px">
    	<cfoutput query="get">
			<cfinput class="regularxl" style="background-color:f4f4f4;text-align:center" readonly type="Text" name="ApplicationRelease" value="#ApplicationRelease#" size="10" maxlength="10">
		</cfoutput>
		</TD>
		</tr>
		</table>
	</TR>
		    
    <TR>
    <td width="160" class="labelmedium">Sub title:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="SystemSubTitle" value="#SystemSubTitle#" message="Please enter a subtitle" required="Yes" size="50" maxlength="50">
		</cfoutput>
	</TD>
	</TR>
		    
    <TR>
    <td width="160" class="labelmedium">Note:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="SystemNote" value="#SystemNote#" message="Please enter a note on the system development group" required="Yes" size="80" maxlength="80">
		</cfoutput>
	</TD>
	</TR>
		    
    <TR>
    <td width="160" class="labelmedium">Development:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="SystemDevelopment" value="#SystemDevelopment#" size="50" maxlength="50">
		</cfoutput>
	</TD>
	</TR>
	
	<TR>
    <td width="160" class="labelmedium">Label Banner:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="SystemLabelBanner" value="#SystemLabelBanner#" size="80" maxlength="100">
		</cfoutput>
	</TD>
	</TR>
	
	<TR>
    <td width="160" class="labelmedium">Label Footer:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="SystemLabelFooter" value="#SystemLabelFooter#" size="80" maxlength="100">
		</cfoutput>
	</TD>
	</TR>
	
	<TR>
    <td width="160" class="labelmedium">Release</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput class="regularxl" style="background-color:f4f4f4;text-align:center" readonly type="Text" name="ApplicationRelease" value="#ApplicationRelease#" size="10" maxlength="10">
		</cfoutput>
	</TD>
	</TR>
		
	<TR>
    <td valign="top" class="labelmedium">Theme:</td>
    <TD class="labelit" style="height:25">
	    <input type="radio" class="radiol" name="ApplicationTheme" id="ApplicationTheme" value="Standard" <cfif get.ApplicationTheme eq "Standard">checked</cfif>>Standard	 (Portal/Logon.cfm)
	    <br>			
	    <input type="radio" class="radiol" name="ApplicationTheme" id="ApplicationTheme" value="Cloud" <cfif get.ApplicationTheme eq "Cloud">checked</cfif>>Cloud with custom logon (Custom/Logon/[ApplicationServer]/)
	    <br>	
		<input type="radio" class="radiol" name="ApplicationTheme" id="ApplicationTheme" value="Extended" <cfif get.ApplicationTheme eq "Extended">checked</cfif>>Extended with custom logon (Custom/Logon/[ApplicationServer]/)
    </TD>
	</TR>
	 
	<TR>
    <td width="160" class="labelit" style="padding-left:10px;">Logo:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="ApplicationThemeLogo" id="ApplicationThemeLogo" value="#ApplicationThemeLogo#" size="50" maxlength="100">
		</cfoutput>
	</TD>
	</TR>
	
	<TR>
    <td width="160" class="labelit" style="padding-left:10px;">Background image:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="ApplicationThemeBackground" id="ApplicationThemeBackground" value="#ApplicationThemeBackground#" size="50" maxlength="100">
		</cfoutput>
	</TD>
	</TR>
	  
    <TR>
    <td width="180" class="labelmedium">CF logical name:</td>
    <TD>
    	<cfoutput query="get">		
		<cfinput class="regularxl" type="Text" name="ApplicationServer" value="#ApplicationServer#" message="Please enter a server name" required="Yes" size="30" maxlength="30">
		</cfoutput>
	</TD>
	</TR>
	
	  <TR>
    <td width="180" class="labelmedium">CF admin user:</b></td>
    <TD>
    	<cfoutput query="get">		
		<cfinput class="regularxl"  type="Text" name="CFAdminUser" value="#CFAdminUser#" message="Please enter a CF user" required="Yes" size="30" maxlength="10">
		</cfoutput>
	</TD>
	</TR>
	
	  <TR>
    <td width="180" class="labelmedium">CF admin password:</b></td>
    <TD>
    	<cfoutput query="get">		
		<cfinput class="regularxl"  type="Password" name="CFAdminPassword" value="#CFAdminPassword#" message="Please enter a server name" required="Yes" size="30" maxlength="30">
		</cfoutput>
	</TD>
	</TR>
	
	
    <TR>
    <td width="160" class="labelmedium">Server IP/Hostname:</b></td>
    <TD>
  
     	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="HostName" value="#Hostname#" message="Please enter a server IP or hostname" required="Yes" size="30" maxlength="30">
		</cfoutput>
	
    </TD>
	</TR>
		
	<TR>
    <td width="160" class="labelmedium">Google MAP Id:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput title="To be acquired for the domain for free on www.google.com" class="regularxl" type="Text" name="GoogleMAPId" value="#GoogleMAPId#" size="70" maxlength="100">
		</cfoutput>
	</TD>
	</TR>

	<TR>
    <td width="160" class="labelmedium">Google Signin Key:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput title="To be acquired for the domain for free on www.google.com" class="regularxl" type="Text" name="GoogleSigninKey" value="#GoogleSigninKey#" size="70" maxlength="100">
		</cfoutput>
	</TD>
	</TR>
	
	<TR>
    <td width="160" class="labelmedium">Splash screen Path:</b></td>
    <TD>
    	<cfoutput query="get">
			<cfinput class="regularxl" type="Text" name="TreeAnimationPath" id="TreeAnimationPath" value="#TreeAnimationPath#" size="70" maxlength="100">
		</cfoutput>
	</TD>
	</TR>
			
	<tr><td height="5"></td></tr>	
	<tr><td class="linedotted" colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center" height="37">
	 	<input type="button" style="height:25;width:180;font-size:13px" onclick="validate('settings')" name="Update" id="Update" value="Save" class="button10g">	
	</td></tr>
	
	</table>
	
</cfform>	
	