
<cfoutput>


<script>

var root = "#SESSION.root#";


function excel(filename) {
    w = #CLIENT.width# - 100;
    h = #CLIENT.height# - 150;
	ptoken.open(filename, "ExcelDialog", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=no");
}

function email(to,subj,att,filter) {
	ptoken.open(root + "Tools/Mail/Mail.cfm?ID=" + to +"&ID1=" + subj + "&ID2=" + att + "&ID3=" + filter, "MailDialog", "width=1000, height=735, status=yes, toolbar=no, scrollbars=no, resizable=no");
}

</script>

<cfparam name="Attributes.MailTo" default="">
<cfparam name="Attributes.MailSubject" default="">
<cfparam name="Attributes.MailAttachment" default="">
<cfparam name="Attributes.MailFilter" default="">
<cfparam name="Attributes.Style" default="button10s">

<button class="#Attributes.Style#" name="Print" value="Print" onClick="javascript:window.print()" class="regular">&nbsp;Print&nbsp;</button>&nbsp;

<button class="#Attributes.Style#" name="eMail" value="eMail" onClick="javascript:email('#Attributes.MailTo#','#Attributes.MailSubject#','#Attributes.MailAttachment#','#Attributes.MailFilter#')" class="regular">&nbsp;eMail&nbsp;</button>&nbsp;

<cfif Attributes.ExcelFile neq "">
<button class="#Attributes.Style#" name="Excel" value="Excel" onClick="javascript:excel('#Attributes.ExcelFile#')" class="regular">&nbsp;Excel&nbsp;</button>&nbsp;
</cfif>


</cfoutput>
