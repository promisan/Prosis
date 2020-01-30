
<cfset client.wrong = 0>

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td valign="middle">
<cfform action="ForgetPasswordMail.cfm?id=#URL.ID#" method="post">

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr>
	<td height="45" >&nbsp;<b>
	<img src="#SESSION.root#/Images/password2_forgot.gif" alt="" border="0">
	<font face="MS Trebuchet" size="3" color="002350">&nbsp;<b><cf_tl id ="Password">
	</td>
	
	<td align="right">
	
	</td>
</tr>

<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
<tr><td height="10" colspan="2"></td></tr>
<tr>
<td height="1" colspan="2">
	<table width="96%" align="center">
	<tr>
	<td  colspan="2" height="1"><b><cf_tl id="ForgetYourPassword"></b>
	<!--- 
	<cf_tl id="NoProblem">. <cf_tl id="WeCanFixThis">
	--->
	</b></td>
	
	</tr>
	
	<tr><td height="15"></td>
	<td>
	<tr><td colspan="2" height="25">
	<cf_tl id="MessageForgetPassword" class="message">
	<p></p>
	</td></tr>
    <cf_tl id="Send eMail" var="1">
	<cfset tSendMail = "#Lt_text#">
	
	<tr><td></td><td align="center"><input type="submit" class="button10g" name="eMail" value="#tSendMail#"></td></tr>
	</table>
</td>
</tr>
<tr><td height="10"></td></tr>
</table>
</td>
</tr>
</table>
</cfform>

</cfoutput>
