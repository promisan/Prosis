
<cfquery name="Log" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     UserReportDistribution  
	WHERE    LayoutName = '#URL.ID#'
	AND      DistributionStatus = '1'
	AND      BatchId = '#URL.BatchId#'
	ORDER BY Account
</cfquery>

<table width="100%" class="navigation_table">
		
	<cfoutput query="log">
	 
	<tr class="line labelmedium navigation_row">  
	    <td align="left" style="min-width:25px;padding-top:3px">
		  <cf_img icon="open" onClick="distribution('#distributionid#')">
	   </td> 
	   <td width="40%"><a href="javascript:schedule('#reportid#')">#DistributionSubject#</a></td>
	   <td width="20%"><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#DistributionName#</a></td>
	   <td width="15%">#DistributionEMail#</td>
	   <td width="10%">#TimeFormat(PreparationEnd,"HH:MM:SS")#</td>
	   <td style="min-width:60">#FileFormat#</td>
	   <td width="min-width:60">#DistributionPeriod#</td>
	</tr>
			
	</cfoutput>

</table>

<cfset ajaxonload("doHighlight")> 
 
 