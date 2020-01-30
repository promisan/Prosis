
<cfparam name="url.scope" default="portal">

<cfif url.scope neq "website">

	<cfinclude template="ApplyScript.cfm">
	
	<cf_LoginTop FunctionName = "PHP" Graphic="No">
	
	<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr><td valign="top" height="40">		
			<cfinclude template="../PHP/PHPBanner.cfm">	
	</td></tr>
		
	<tr><td>
	
		<cfinclude template="ApplyBucket.cfm">
	 
	</td></tr>
	
	</table>
	
	<cf_LoginBottom FunctionName = "PHP" Graphic="No">

<cfelse>

    <!--- -------------------------------------------- --->
    <!--- script needs to be loaded from source screen --->
	<!--- -------------------------------------------- --->

	<!---
	<cf_screentop height="100%" title="My Application Agent" html="Yes" scroll="Yes" layout="innerbox">
	--->

	<table width="100%" cellspacing="0" cellpadding="0">
	
	<!---
	<tr><td height="5"></td></tr>
	
	<tr><td align="center" height="30" class="top4n">
	<input type="button" name="Close" value="Close" class="button10g" onclick="window.close()">
	</td></tr>
	
	<tr><td height="1" bgcolor="gray"></td></tr>
	
	--->
	
	<tr><td height="8"></td></tr>
	<tr><td valign="top" height="20">		
		<cfinclude template="../PHP/PHPIdentity.cfm">	
	</td></tr>
	
	<tr><td>
		<cfinclude template="ApplyBucket.cfm">
	</td></tr>
	
	</table>
	
	<!---
	<cf_screenbottom layout="Innerbox">
	--->

</cfif>



