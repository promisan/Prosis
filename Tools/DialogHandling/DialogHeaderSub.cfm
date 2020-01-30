
<cfoutput>

<cfparam name="Attributes.closebutton" default="Yes">
<cfparam name="Attributes.closebutton" default="Yes">
<cfparam name="Attributes.ExcelFile" default="No">

<script>

var root = "#SESSION.root#";

function reload() {
	parent.window.opener.history.go(); 
	parent.window.close()
}

</script>

<cfinclude template="DialogMail.cfm">

<cfparam name="Attributes.MailTo" default="">
<cfparam name="Attributes.MailSubject" default="">
<cfparam name="Attributes.MailAttachment" default="">
<cfparam name="Attributes.MailFilter" default="">
<cfparam name="Attributes.reload" default="No">
<cfparam name="Attributes.Style" default="button1">

<button class="#Attributes.Style#" name="Print" id="Print" value="Print" onClick="javascript:window.print()">&nbsp;Print&nbsp;</button>
<cfif Attributes.MailSubject neq ''>
<button class="#Attributes.Style#" name="eMail" id="eMail" value="eMail" onClick="javascript:email('#Attributes.MailTo#','#Attributes.MailSubject#','#Attributes.MailAttachment#','#Attributes.MailFilter#')">&nbsp;eMail&nbsp;</button>
</cfif>
<cfif Attributes.ExcelFile neq "">
<button class="#Attributes.Style#" name="Excel" id="Excel" value="Excel" onClick="javascript:excel('#Attributes.ExcelFile#')">&nbsp;Excel&nbsp;</button>
</cfif>
<cfif attributes.closebutton eq "Yes" and attributes.reload eq "No">
<button class="#Attributes.Style#" name="Close" id="Close" value="Close" onClick="parent.window.close()">&nbsp;Close&nbsp;</button>&nbsp;
</cfif>
<cfif attributes.closebutton eq "Yes" and attributes.reload eq "Yes">
<button class="#Attributes.Style#" name="Close" id="Close" value="Close" onClick="reload()">&nbsp;Close&nbsp;</button>&nbsp;
</cfif>

</cfoutput>
