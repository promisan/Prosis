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
<cfquery name="Bucket"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT F.*, 
	       O.OrganizationDescription, 
		   G.ListingOrder, 
		   S.EditionShort, 
		   (SELECT Mission FROM Vacancy.dbo.Document WHERE DocumentNo = F.DocumentNo) as Mission		  
	FROM   FunctionOrganization F, 
	       Ref_Organization O, 
		   Ref_SubmissionEdition S, 
		   Ref_GradeDeployment G
	WHERE  S.EnableAsRoster = '1'
    AND    F.FunctionNo = '#URL.FunctionNo#' 
		  <cfif URL.GradeDeployment neq "">
	AND    F.GradeDeployment = '#URL.GradeDeployment#'
		  </cfif>
	AND      F.OrganizationCode = O.OrganizationCode
	AND      F.GradeDeployment = G.GradeDeployment
	AND      F.SubmissionEdition = S.SubmissionEdition 		
	ORDER BY G.ListingOrder
</cfquery>
	
<cfif Bucket.recordCount gt "0">

<table width="100%">

<tr><td style="padding:4px">

  <table class="navigation_table" width="94%" align="center">
 
  <cfoutput query="Bucket">
  <cfif ReferenceNo neq "Direct">
 	<tr bgcolor="fafafa" class="labelmedium line navigation_row" style="height:20px">
  <cfelse>
    <tr bgcolor="ffffdf" class="labelmedium line navigation_row" style="height:20px">
  </cfif>		  
		    		  
	  <td width="4%" align="center" style="padding-top:2px;">	  
			<cf_img icon="select" onclick="bucketedit('#URL.ifrm#','#FunctionId#')">      		 		  
	  </td>
	  
	  <td width="10%">#GradeDeployment#</td>
	  <td width="10%">#OrganizationDescription#</td>
	  <td width="15%">#EditionShort#</td>	 
	  <td align="right" style="padding-top:1px;padding-right:3px">
	  
	   <cfif Bucket.DocumentNo eq "">
	   
	    <cfif Bucket.ReferenceNo neq "Direct"> 
    	
		<!---
			<img src="#SESSION.root#/Images/doc.gif" alt="" 
			width="10" height="10" border="0" 
			align="center" class="regular" style="cursor: pointer;" 
			onClick="javascript:va('#Bucket.FunctionId#');">
			
			--->
			
		</cfif>
		
      <cfelse>
	  <!---
	        <cf_img icon="select" onClick="javascript:showdocument('#Bucket.DocumentNo#')">
			--->
	  			
	  </cfif>	
	  </td>
	  
	  <td width="20%">
	  <cfif Bucket.ReferenceNo neq "Direct">
	  <a href="javascript:va('#Bucket.FunctionId#');">#ReferenceNo#</a>
	  <cfelse>
	  #ReferenceNo#
	  </cfif>
	  </td>	  
	  <td style="padding-left:15px" width="20%">#Mission#</td>
	  <td style="padding-left:2px" width="10%">
	  <cfif DateExpiration eq "">
	     no expiry
	  <cfelse>
	    #dateFormat(DateExpiration, CLIENT.DateFormatShow)#
	  </cfif>	
		</td>
	  
	  </tr>

	  </cfoutput>
	  
	  </table>
	  
  </td></tr>
  
</table>  
 
</cfif>

<cfoutput>

<cfif Bucket.recordCount eq "0">

<table width="100%" border="1">
	<tr><td colspan="2" class="cellcontent" align="center"><b>No roster buckets found</b></td></td>
</table>

</cfif>

</cfoutput>

<cfset ajaxonload("doHighlight")>
