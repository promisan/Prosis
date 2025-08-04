<!--
    Copyright © 2025 Promisan

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
