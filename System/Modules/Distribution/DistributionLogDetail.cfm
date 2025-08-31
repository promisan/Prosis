<!--
    Copyright © 2025 Promisan B.V.

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
	 
	<tr class="line labelmedium2 navigation_row">  
	    <td align="left" style="min-width:25px;padding-top:2px">
		  <cf_img icon="select" onClick="distribution('#distributionid#')">
	   </td> 
	   <td width="40%"><a href="javascript:schedule('#reportid#')">#DistributionSubject#</a></td>
	   <td width="20%"><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#DistributionName#</a></td>
	   <!---
	   <td width="15%">#DistributionEMail#</td>
	   --->
	   <td width="10%">#TimeFormat(PreparationEnd,"HH:MM:SS")#</td>
	   <td style="min-width:60">#FileFormat#</td>
	   <td width="min-width:60;padding-right:4px">#DistributionPeriod#</td>
	</tr>
			
	</cfoutput>

</table>

<cfset ajaxonload("doHighlight")> 
 
 