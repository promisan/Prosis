

<cfoutput>

 <cfquery name="Release" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT S.DistributionEMail,V.*
	    FROM ParameterSite S ,ParameterSiteVersion V
		WHERE S.ApplicationServer = V.ApplicationServer
		AND VersionId ='#Object.ObjectKeyValue4#'
</cfquery>	

<script language="JavaScript">

function email()
{
	window.open("#SESSION.root#/Tools/Mail/Mail.cfm?"+
	"ID=#Release.DistributionEMail#&"+
	"ID1=Upgrade to release : v#DateFormat(Release.VersionDate,'YYYYMMDD')#&Source=Release&"+
	"Sourceid=#Object.ObjectKeyValue4#",
	"blank", 
	"width=800, height=600, status=yes, toolbar=no, scrollbars=no, resizable=no");
}

</script>


<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td colspan="2" bgcolor="E0E0E0"></td></tr>
 
<tr>
	<td width="18%">&nbsp;&nbsp;&nbsp;<b>Send release package :</b></td>
	<td height="25">
	<button class="buttonFlat" name="aboutreport2" id="aboutreport2" style="height:20,width:120px;" onclick="javascript:email()">
			<img src="#SESSION.root#/Images/sync.gif" alt="About" border="0" align="absmiddle"> 
			Email release
	</button>
	</td>
</tr>

</table>

</cfoutput>

