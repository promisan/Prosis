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