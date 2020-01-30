
<html>


<cfoutput>
	
	<cfquery name="System" 
		datasource="AppsSystem">
			SELECT *
			FROM   Ref_ModuleControl
			WHERE  SystemModule  = 'SelfService'
			AND   FunctionClass IN ('SelfService','Report')
			AND    FunctionName  = '#URL.ID#'  
	</cfquery>
			
	<script>
	
		function logon() {	
		window.location = "#SESSION.root#/#System.FunctionDirectory#/#System.FunctionPath#?ID=#URL.ID#&#system.FunctionCondition#"
		}
	
	</script>

</cfoutput>


<cfquery name="Get" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   *
  FROM     userNames
  WHERE    account = '#SESSION.acc#'
</cfquery>

<cfparam name="URL.ID" default="change"> 
<CFFORM action="SetPreferencesSubmit.cfm?entitycode=#URL.entityCode#&id=#url.id#&personno=#get.PersonNo#" method="post">

<cfquery name="Check" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   *
  FROM     userEntitySetting
  WHERE    account    = '#SESSION.acc#'
  AND      EntityCode = '#URL.EntityCode#'
</cfquery>

<cfif check.recordcount eq "0">

	<cfquery name="Insert" 
	  datasource="AppsSystem" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  INSERT INTO userEntitySetting
	  (Account,EntityCode,OfficerUserId,OfficerLastName,OfficerFirstName)
	  VALUES
	  ('#SESSION.acc#','#URL.EntityCode#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>

</cfif>

<cfquery name="Get" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   *
  FROM     userNames
  WHERE    account = '#SESSION.acc#'
</cfquery>

<cfquery name="Pref" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   *
  FROM     userEntitySetting
  WHERE    account = '#SESSION.acc#'
  AND      EntityCode = '#URL.EntityCode#'
</cfquery>

<cfquery name="Parameter" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   *
  FROM     Parameter
</cfquery>
		
<cfoutput>

<!--- Entry form --->


<table width="100%" align="left" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td width="50"></td>
<td>

<table width="98%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" class="formpadding">

    <!--- Field: User --->
	
	<tr><td height="13"></td></tr>
	<tr><td height="1" colspan="3" bgcolor="C0C0C0"></td></tr>
		
	<tr><td height="4"></td></tr>	
	<TR>
	
	<td colspan="3">
		<table>
		<tr>
	  	<td width="100">Name:</TD>
		<td><b>#get.FirstName# #get.LastName#</td>
		</tr>
		
		<!--- Field: User --->
	    <TR>
	    <TD>Account:</TD>
		<td><b>#get.Account#</td>
		</tr>
		
		<!--- Field: User 
	    <TR>
	    <TD>#client.indexNoName#:</TD>
		<td><b>#get.IndexNo#</td>
		</tr>
		--->
		
		</table>
	</td></tr>
	
	<tr><td height="6"></td></tr>
	<tr><td height="1" colspan="3" bgcolor="C0C0C0"></td></tr>
	<tr><td height="4"></td></tr>	
		
	<tr><td height="3" colspan="3"><b>Preferences</b></td></tr>	
	
    <TR>
    <td height="18" width="20"><img src="#SESSION.root#/Images/option2.jpg" border="0"></td>
	<td width="120">Preferred eMail Address:</td>
    <TD>
		<table cellspacing="0" cellpadding="0">
		<tr><td>
		    <cfinput type="Text" name="emailaddressexternal" value="#get.emailaddressexternal#" message="Please enter a valid eMail address" validate="email" required="No" size="30" maxlength="40" class="regular">				
			</TD>
			<td width="3"></td>
			<td>
			<cf_helpfile code = "SelfService" 
					 id       = "prefemail" 
					 class    = "General"
					 name     = "Preferred Email Address"
					 color    = "black">
			</td>
		</tr>
		</table>				 
	</td>
	</TR>
	 
    <TR>
    <TD><img src="#SESSION.root#/Images/option2.jpg" border="0"></td>
	<td>Enable Mail Notification: </TD>
	<TD>
		<table cellspacing="0" cellpadding="0">
		<tr><td>
			<input type="checkbox" name="EnableMailHolder" value="1" <cfif pref.enableMailHolder eq "1">checked</cfif>>
		   </TD>
			<td width="3"></td>
			<td>
			<cf_helpfile code = "SelfService" 
					 id       = "prefnotify" 
					 class    = "General"
					 name     = "Mail Notification"
					 color    = "black">
			</td>
		</tr>
		</table>			
	</TD>
	</tr>
	<tr><td height="3"></td></tr>
	<tr>
	
	 <!--- Field: Enable Automated EMail --->
    <TR>
    <td height="140">
	 </td>
	<TD></TD>
	</tr>
	<tr><td height="3"></td></tr>
	<tr>
    
	</TR>
	
	<tr><td height="5"></td></tr>
	<tr><td height="1" colspan="3" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<tr><td colspan="3" align="center">
	   <input class="button10g" type="button" name="Logon" value="Back" onclick="logon()">
	   <input class="button10g" type="submit" name="Process" value="Save">
   </td></tr> 
   
   <tr><td height="5"></td></tr>    

	</TABLE>

</td></tr>
</table>

</cfoutput>
	
</CFFORM>

</BODY></HTML>