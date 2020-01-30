
<cfoutput>

<cfquery name="get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     UserReport U INNER JOIN
             Ref_ReportControlLayout R ON U.LayoutId = R.LayoutId
	WHERE    ReportId = '#URL.ReportId#'
</cfquery>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<!---
<tr><td>

	<table width="100%"
	   border="0"
       cellspacing="0"
       cellpadding="0"
       align="center">
	   	   
	   <tr><td colspan="6" height="18" align="right"><font color="6688aa"><b>&nbsp;#get.distributionsubject# - #get.LayoutName#&nbsp;&nbsp;</td></tr>
	   
	   <tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr>
	 	 
	</table>
	
</td></tr>
--->

<tr><td valign="top" height="100%">
		
	<iframe id="#url.name#" 	       
			height="100%"
			width="100%"
			scrolling="no"
            frameborder="0" 
			src="../../Tools/cfreport/ReportSQL8.cfm?reportid=#reportid#&mode=link&category=Dashboard&userid=#SESSION.acc#">
	</iframe>				
		
</td></tr>

</table>

</cfoutput>



