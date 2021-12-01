<HTML><HEAD>
    <TITLE>Asset Recording</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<cfparam name="url.mid" default="">

<cfoutput>
	<table width="100%" height="100%">
	<tr>
	<td><iframe src="ReceiptParentSelect.cfm?id=#url.id#&mid=#url.mid#" name="result" id="result" style="width:99.5%;height:99.5%" scrolling="no"></iframe></td>
	</tr>
	</table>
</cfoutput>