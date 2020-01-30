
<cfquery name="Log" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   U.*, RL.LayoutName
	FROM     UserReport U, Ref_ReportControlLayout RL
	WHERE    U.LayoutId = RL.LayoutId
	AND      ControlId = '#URL.ID#' 
	AND      Status = '1'
	AND      DateExpiration >= getDate()
	ORDER BY Account
</cfquery>

<table width="90%" align="center" cellspacing="0" cellpadding="0">
  
  <cfoutput query="log">
	 
	 <tr><td height="1" colspan="7" class="linedotted"></td></tr>
	 <tr>  
	   <td width="2%" class="label" style="height:16px"></td>
	   <td width="4%" class="label" style="padding-top:2px">
	     <cf_img icon="open" onClick="javascript:schedule('#reportid#')">
	   </td> 
	   <td width="31%" class="label">
	      <a href="javascript:ShowUser('#URLEncodedFormat(Account)#')"><font color="0080C0">#DistributionName#</font></a>
	   </td>
	   <td width="10%" class="label">#DistributionMode#</td>
	   <td width="10%" class="label">#DistributionPeriod#</td>
	   <td width="41%" class="label">#DistributioneMail#</td>
	 </tr>	 
	 
  </cfoutput>
	 
</table> 