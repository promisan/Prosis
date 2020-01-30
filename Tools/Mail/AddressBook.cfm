<cf_param name="url.to"  default="" type="string">
<cf_param name="url.cc"  default="" type="string">
<cf_param name="url.bcc" default="" type="string">

<cfoutput>
	<table width="100%" height="100%">
	<tr><td style="height:100%;width:100%">
		<iframe src="#SESSION.root#/tools/mail/AddressBookView.cfm?to=#url.to#&cc=#url.cc#&bcc=#url.bcc#" width="100%" height="100%" frameborder="0"></iframe>
	</td></tr>
	</table>
</cfoutput>