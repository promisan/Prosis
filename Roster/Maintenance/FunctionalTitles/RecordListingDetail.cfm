
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

<table width="100%"  cellspacing="0" cellpadding="0">

<tr><td style="padding:4px">

  <table class="navigation_table" width="94%" style="border:0px dotted silver" cellspacing="0" cellpadding="0" align="center">
 
  <cfoutput query="Bucket">
  <cfif ReferenceNo neq "Direct">
 	<tr bgcolor="fafafa" class="labelit linedotted navigation_row" >
  <cfelse>
    <tr bgcolor="ffffdf" class="labelit linedotted navigation_row">
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
	  <td width="10%">
	  <cfif Bucket.ReferenceNo neq "Direct">
	  <a href="javascript:va('#Bucket.FunctionId#');"><font color="0080C0"><u>#ReferenceNo#</font></a>
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
