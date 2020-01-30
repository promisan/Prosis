

11111111

<!---

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Attributes.Status"  default="Notification">
<cfparam name="Attributes.Message" default="Your request could not be processed">
<cfparam name="Attributes.return"  default="">
<cfparam name="Attributes.width"    default="75%">
<cfparam name="Attributes.height"   default="">
<cfparam name="Attributes.location" default="">
<cfparam name="Attributes.report"   default="0">
<cfparam name="Attributes.loc"      default="">
<cfparam name="Attributes.target"   default="">
<cfparam name="Attributes.header"   default="No">
<cfparam name="Attributes.align"    default="Center">
<cfparam name="Attributes.topic"    default="">
<cfparam name="Attributes.subtext"  default="Yes">
<cfparam name="Attributes.buttonText" default="Press to return to the prior page">

<!--- reset abort status --->

<cfset client.abort = "0">

<cfif #Attributes.report# eq "1">

	<script language="JavaScript">
			
			   	{ 
					
				se  = parent.option.document.getElementById("preview");
				if (se)
				{se.className = "button10p"}
					
				se  = parent.option.document.getElementById("buttons");
				if (se)
				{se.className = "top4n"}
					
				se  = parent.option.document.getElementById("buttons2");
				if (se)
				{se.className = "top4n"}
					
				se  = parent.option.document.getElementById("stop");
				if (se)
				{se.className = "hide"}
					
				se  = parent.option.document.getElementById("stopping");
				if (se)
				{se.className = "hide"}
					
				se  = document.getElementById("requestabort");
				if (se)
				{se.className = "hide"}
					
				}
													
			</script> 

 </cfif>
<cfoutput>

<script language="JavaScript">

function locationreturn()

{

<cfif #Attributes.loc# neq "">

   window.open("#attributes.return#","#Attributes.loc#")
   
<cfelseif #Attributes.topic# neq "">

   se = document.getElementById("hide")
   if (se.checked == true)
   {
    window.location = "#attributes.return#&message=#Attributes.topic#&messagehide=hide"
   }
   else
   {
   window.location = "#attributes.return#"
   }
      
<cfelse>

  <cfif #Attributes.target# eq "">
	  window.location = "#attributes.return#"
  <cfelse>
  	  parent.window.location = "#attributes.return#"
  </cfif>
      
</cfif>   

}

</script>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<cfif #Attributes.header# eq "yes">
<table width="100%" border="0" align="center">
<tr>
  <td height="26" colspan="2" class="top3n">&nbsp;<font size="2" face="Georgia, Times New Roman, Times, serif"><b><cfoutput>#SESSION.welcome#</cfoutput></b></td>
</tr>
</table>
</cfif>

<table bgcolor="ffffff" width="100%" height="95%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td colspan="2">

<table width="#Attributes.width#" height="#Attributes.height#" border="1" cellspacing="0" cellpadding="0" align="center" bgcolor="f4f4f4">

<tr><td height="24" align="left" class="regular">
   &nbsp;<b>#SESSION.welcome#</b>
</td></TR>

<tr><td height="100%">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr><td height="14"></td></TR>

<cfif #Attributes.subtext# eq "Yes">
	<tr><td height="100%" colspan="3" align="left" valign="bottom" class="regular">&nbsp;
	<cfif #Attributes.Status# eq "Problem">
	<font face="Verdana" size="5">&nbsp;&nbsp;
	<!---
	<cf_tl id="Notification">
	--->
	Problem:</font>
	<cfelseif #Attributes.Status# eq "Violation">
	<font face="Verdana" size="5">&nbsp;&nbsp;
	<!---
	<cf_tl id="Notification">
	--->
	<font color="804040">
	<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/stop.gif" alt="" border="0" align="absmiddle">
	Violation:</font>
	<cfelse>
	<font face="Verdana" size="5">&nbsp;&nbsp;
	<!--- <cf_tl id="Attention"> 
	--->
	<font color="804040">
	<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/stop.gif" alt="" border="0" align="absmiddle">
	Attention:</font>
	</cfif>
	<br>
	</td></tr>
	<tr><td height="15" colspan="3"></td></tr>
</cfif>
<tr>
  <td width="10"></td>
  <td height="20" class="regular" align="left">
    <table width="95%"
       border="1"
       cellspacing="0"
       cellpadding="0"
       align="center"
       bordercolor="C0C0C0"
       style="border: 1px inset;">
	<tr><td bgcolor="FFFFFF">
    <table width="100%"
       height="65"
       border="0"
       align="center"
       bordercolor="C0C0C0"
       bgcolor="FFFFFF">
    <tr><td align="#Attributes.align#">
	<font face="Verdana">#Attributes.Message#</td></tr>
    </td></tr></table>
	</table>
  </td>
  <td width="10"></td>
</tr>
<tr><td height="6" colspan="3"></td></tr>

<cfif #attributes.topic# neq "">

<tr><td height="30" colspan="3" align="center" valign="bottom">
	<input type="checkbox" name="hide" value="1">
	Check here, if you don't want to see this message in the future.
</tr>

</cfif>

<tr><td height="30" colspan="3" align="center" valign="bottom">

<cfswitch expression="#Attributes.return#">

<cfcase value="No">
	<!--- no option provided --->
</cfcase>

<cfcase value="back">
   <input type="button"
       value="#Attributes.ButtonText#"
       class="button7"
       onClick="history.back()">
</cfcase>

<cfcase value="backgo">
   <input type="button"
       value="#Attributes.ButtonText#"
       class="button7"
       onClick="history.go(-1)">
</cfcase>

<cfcase value="close">
   <input type="button"
       value="#Attributes.ButtonText#"
       class="button7"
       onClick="window.close()">
</cfcase>

<cfcase value="">
   <input type="button"
       value="#Attributes.ButtonText#"
       class="button7"
       onClick="parent.window.close(); opener.history.go()">
</cfcase>

<cfdefaultcase>
   <input type="button"
       value="#Attributes.ButtonText#"
       class="button7"
       onClick="javascript:locationreturn()">
</cfdefaultcase>

</cfswitch>

&nbsp;</td></tr>
<tr><td height="12" colspan="3"></td></tr>
</table>

</td></tr>
</table>

</td></tr>

<TR>
    <tr><td height="40" colspan="2" valign="bottom"></td></tr>
</TR> 

</table>

</body>

</cfoutput>
--->
