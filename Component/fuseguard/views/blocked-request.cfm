<cfparam name="session.root" default="/default.cfm">
<cfparam name="session.welcome" default="">

<div style="width:70%; text-align:center; margin-left:15%; margin-top:10%; padding-top:30px; padding-bottom:30px; color:#FFFFFF; font-size:30px; font-family:Verdana; background-color:#E08283; border-radius:10px;">
	<cf_tl id="This request violates the defined security rules">
	<br>
	<font size="4"><cf_tl id="The request information has been logged"></font>
	<br><br>
	<cfoutput>
		<a style="color:##FFFFFF; font-size:17px; font-family:Calibri;" href="#session.root#">Back to Login</a>
		<br><br>
		<span style="font-size:14px;">#session.welcome#</span>
	</cfoutput>
</div>