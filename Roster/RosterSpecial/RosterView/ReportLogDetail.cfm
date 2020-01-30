

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Log" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     UserReportDistribution UR INNER JOIN
         UserReport U ON UR.ReportId = U.ReportId 
WHERE    (UR.DistributionCategory <> 'ERROR')
AND      RL.ReportId = '#URL.ID#'
ORDER BY Account
</cfquery>

<tr>  
   <td colspan="2"> <table width="100%">
        <cfoutput query="Log" group="Description">
         <tr><td colspan="4">&nbsp;<b>#Description#</td></tr>
		 <cfoutput>
 		 <tr>  
		   <td>&nbsp;
		    <img src="#SESSION.root#/Images/point.jpg" alt="" name="img1_#currentrow#" 
				  onMouseOver="document.img1_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img1_#currentrow#.src='#SESSION.root#/Images/point.jpg'"
				  style="cursor: pointer;" alt="" width="11" height="11" border="0" align="middle" 
				  onClick="javascript:schedule('#reportid#')"	>
		   </td> 
		   <td>&nbsp;#DistributionName#</td>
		   <td>#TimeFormat(DistributionDate,"HH:MM:SS")#</td>
		   <td>#FileFormat#</td>
		   <td>#DistributionPeriod#</td>
		   <td>#DistributioneMail#</td>
		 </tr>
		 <tr><td height="1" colspan="5" bgcolor="E0E0E0"></td></tr>
		 </cfoutput>
	  </cfoutput>	
	  </table> 
   
   </td>
 </tr>