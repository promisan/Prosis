
<cf_screentop height="100%" html="No" scroll="no" layout="webapp" user="No" banner="green" line="no" label="Batch Extension">

<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	   FROM Ref_Mandate
	   WHERE Mission = '#URL.Mission#'
	   AND MandateNo = '#URL.MandateNo#' 
  </cfquery>

<cfoutput>

<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td class="labellarge" style="padding-top:20px;font-size:29px;height:40px"><b>#URL.Mission#</b></td></tr>
<tr><td height="25"></td></tr>
<tr><td class="labellarge" style="color:green" align="center">This function will extend all incumbents that still have a valid assignment at the end of this period as per: <b>#DateFormat(Mandate.DateExpiration, CLIENT.DateFormatShow)#</b> as as such a candidate to be extended into the next staffing period.</td></tr>
<tr><td height="20px;"></td></tr>
<tr><td class="labellarge" style="color:green" align="center">All requests for extension will be issued under your name : <b>#SESSION.first# #SESSION.last#</b> </td></tr>
<tr><td height="20px;"></td></tr>
<tr><td class="labellarge" style="color:green" align="center">Issued extension requests for incumbents are identified with an icon : <img src="#SESSION.root#/Images/reminder.png" alt="" width="15" height="12" border="0"> </td></tr>
<tr><td height="20px;"></td></tr>
<tr><td class="linedotted"></td></tr>
<tr><td align="center" style="padding-top:10px">
  <input type="button" onclick="extendnow('#url.mission#','#url.mandateno#')" style="font-size:18px;width:200;height:34" class="button10g" name="Extend" value="Extend Now"></td></tr>
</table>

</td></tr>  
<tr><td id="processextension"></td></tr>
</table>


</cfoutput>
