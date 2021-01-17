
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

<table width="100%" align="center">
  
  <cfoutput query="log">
	
	
	 <tr class="line">  
	   <td width="2%" style="height:16px"></td>
	   <td width="4%" style="padding-top:2px">
	     <cf_img icon="select" onClick="javascript:schedule('#reportid#')">
	   </td> 
	   <td width="31%">
	      <a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#DistributionName#</a>
	   </td>
	   <td width="10%">#DistributionMode#</td>
	   <td width="10%">#DistributionPeriod#</td>
	   <td width="41%">#DistributioneMail#</td>
	 </tr>	 
	 
  </cfoutput>
	 
</table> 