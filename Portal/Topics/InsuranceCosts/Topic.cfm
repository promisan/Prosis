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

<!--- --------------------- --->
<!--- designed for INSIGHT only --->
<!--- --------------------- --->

<cfoutput>

<table width="97%" height="100%" frame="hsides" border="1" bordercolor="d1d1d1" cellspacing="0" cellpadding="0" align="center">
<tr valign="top">

<td align="center">

<cfif CLIENT.width lte "800">
	<cfset topics = "400">
<cfelse>
	<cfset topics = "600">
</cfif>

	
	<cfquery name="ClaimCost"
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">

SELECT     S.Status,S.Description AS DescriptionStatus,ISNULL(sum(OAC.InvoiceAmount),0) as Amount
				
FROM         Organization.dbo.OrganizationObject R 
			 INNER JOIN Claim C 
			 ON R.ObjectKeyValue4 = C.ClaimId 
			 INNER JOIN Ref_Status S 
			 ON C.ActionStatus = S.Status 
			 INNER JOIN Ref_ClaimTypeClass D 
			 ON C.ClaimTypeClass = D.Code 
			 INNER JOIN Organization.dbo.Organization OO   
			 ON C.OrgUnitClaimant = OO.OrgUnit and OO.Mission = 'Assured'
		     LEFT OUTER JOIN Organization.dbo.OrganizationObjectActionCost OAC 
			 ON R.ObjectId = OAC.ObjectId  
			 INNER JOIN ClaimOrganization CO 
			 ON CO.ClaimId = C.ClaimId and CO.ClaimRole='LUnderwriter'
<!---
			 INNER JOIN Organization.dbo.Organization OO2 
			 ON CO.OrgUnit = OO2.orgUnit and OO2.Mission='Insight'
--->
			 LEFT JOIN Accounting.dbo.TransactionHeader H ON OAC.ActionID = H.ActionID
			        
WHERE   S.StatusClass = 'clm'
group by S.Status,S.Description
order by S.Description

</cfquery>
	

  <table>

  	<tr>
  	  <td colspan="2" align="center" valign="top">
	    <font size="2"><b>Claim Costs by Status</b></font>
	  </td>
    </tr>
    
    	<tr><td colspan="2" class="line" height="1"></td></tr>
    <tr>
    <td colspan="2" align="center">
			
		<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png" 
	         	chartheight="260" 
			 	chartwidth="#topics-100#" 
				 showxgridlines="yes" 
				 showygridlines="yes"				
				 showborder="no" 
				 fontsize="9" 
				 fontbold="yes" 
				 fontitalic="no" 
				 xaxistitle="" 
				 yaxistitle="" 
				 show3d="yes" 
				 rotated="no" 
				 seriesplacement="default"
				 sortxaxis="no" 
				 tipbgcolor="##FFFFCC" 
		   		 url="javascript:ColdFusion.navigate('#SESSION.root#/portal/topics/InsuranceCosts/TopicDetail.cfm?Status=$ITEMLABEL$','detail')"
				 showmarkers="yes" 
				 markersize="30" 
				 backgroundcolor="##ffffff">

			 
				<cfchartseries
	             type="pie"
	             query="ClaimCost"
	             itemcolumn="DescriptionStatus"
	             valuecolumn="Amount"
				   serieslabel="Status" 
				   seriescolor="##CCCC66" 
				   paintstyle="raise" 
				   markerstyle="circle" 
				   colorlist="##CCCC66,green,blue">
				 
			</cfchart>

  						
                       
						
	</td>
	</tr>

  <!--- box for showing details --->    
  <tr><td colspan="2" id="detail"></td></tr>
	
	</table>
	</td>


</tr>	
		
</table>
	
</cfoutput>	
