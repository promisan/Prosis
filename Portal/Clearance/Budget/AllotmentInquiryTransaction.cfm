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
<cf_screentop html="no">

<cf_DialogREMProgram>
<cfset No = 0>

<form action="AllotmentClearanceTransactionSubmit.cfm" method="post" name="clear" target="detail">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" bgcolor="ffffff" class="formpadding">

<tr>
  <td width="47%" height="22" class="bannerN">&nbsp;<b>Description</b></td> 
   
  <cfquery name="Edit" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT     *
   FROM       Ref_AllotmentEdition
   WHERE      EditionId = '#URL.Edition#'	   
  </cfquery>
  <td width="47%" height="22" align="right" class="bannerN"><cfoutput><b>#Edit.Period# #Edit.Description#&nbsp;</b></cfoutput>
  </td>
  <td width="10" class="bannerN"></td>
  
</tr> 
 
<tr><td class="topN">
 <input type="submit" value="Submit" class="button7">

</td>
  
  <td align="right" class="topN">($'000)&nbsp;</td>
  <td class="topN"></td>
  
</tr>    

</table>

<cf_tabletop size="100%" omit="true">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="002350" bgcolor="ffffff" class="formpadding">

<cfquery name="SearchResult" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM #SESSION.acc#Allotment
ORDER BY CategoryOrder, ListingOrder, Code 		   
</cfquery>

<cfoutput>

<tr>
  <td width="47%" class="regular"><b>Expenditure</b></td>
  
     <cfquery name="Subtotal" dbtype="query">
      SELECT  sum(Edition_#URL.Edition#) as amount
      FROM    Searchresult
      </cfquery>
      
    <td width="47%" align="right" class="regular">
    	 <b><u>#NumberFormat(subtotal.amount,"___,___._")#</u></b>
	</td>
   <td width="10"></td>
</tr> 

</cfoutput>

<cfset CLIENT.ObjectNo = 0>

<cfoutput query="SearchResult" group="Category">
<tr>
  <td height="10" colspan="3"></td>
</tr>
<tr bgcolor="FFFFA6">
  <td class="regular"><b>#Category#</b></td>
  
    <cfquery name="Subtotal" dbtype="query">
      SELECT  sum(Edition_#URL.Edition#) as amount
      FROM    Searchresult
      WHERE   Category = '#Category#'
	</cfquery>
      
    <td align="right" class="regular">
    	 <b><u>#NumberFormat(subtotal.amount,"___,___._")#</u></b>
	</td>
	<td></td>
</tr> 

<tr>
  <td height="5" colspan="3"></td>
</tr>
 
<cfoutput group="ListingOrder">

<cfoutput group="Code">

 <cfquery name="Parent" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       Ref_Object
WHERE      ParentCode = '#Code#'	   
</cfquery>

<cfif #Parent.recordCount# eq "0">

   <cfif #ParentCode# eq "">

   <tr>
     <td class="regular">&nbsp;&nbsp;#Description#</td>
	 
     <td align="right" class="regular">
    	 <cfset val = evaluate("Edition_"&#URL.Edition#)>
		 
		<cfquery name="Prior" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT     SUM(Amount/1000) AS Amount
			    FROM       ProgramAllotmentDetail
				WHERE      Status = '1' 
				AND		   ProgramCode = '#URL.Program#'	   
			 	AND        EditionId = '#URL.Edition#'
				AND        ObjectCode = '#Code#'
		</cfquery> 
	  	       
      <cfset diff = "0">			 
      <cfif #Prior.Amount# neq #val#>	  
	      <cfif #Prior.Amount# eq "">		  
		     <cfset diff = #val#>			 
		  <cfelse>	  
		      <cfif #val# neq "">	
		   		 <cfset diff = #val#-#Prior.Amount#> 		  
			  </cfif>
		  </cfif>	  
	   </cfif>

	     #NumberFormat(evaluate(val),"___,___._")#
	     </td>
			<td align="center">
			<cfif #diff# neq "0">
				<cfset CLIENT.ObjectNo = #CLIENT.ObjectNo# + 1>
				<input type="checkbox" name="Check_#CLIENT.ObjectNo#" value="1" checked>
				<input type="hidden" name="Object_#CLIENT.ObjectNo#" value="#Code#">
				<input type="hidden" name="Amount_#CLIENT.ObjectNo#" value="#diff#">
			</cfif>
		</td>
	 </tr> 
	 
	 <tr><td colspan="3">
	    <cfinclude template="AllotmentInquiryTransactionLine.cfm">
	 </td></tr>

   <cfelse>

   <tr>
     <td class="regular"><img src="../../../../Images/join.gif" alt="" width="19" height="10" border="0">
	 &nbsp;&nbsp;<font color="gray">#Description#</font></td>
	 
	  <td align="right" class="regular">
   	   <cfset val = "Edition_"&#URL.Edition#><font color="gray">
	   #NumberFormat(evaluate(val),"___,___._")#</font>
	  </td>
	  <td></td>
    </tr> 
	
	 <tr><td colspan="3">
	    <cfinclude template="AllotmentInquiryTransactionLine.cfm">
	 </td></tr>

   </cfif>

<cfelse>

  <tr bgcolor="ffffcf">
  <td class="regular">&nbsp;&nbsp;#Description#</td>
    
    <cfquery name="Subtotal" dbtype="query">
      SELECT  sum(Edition_#URL.Edition#) as amount
      FROM    Searchresult
      WHERE   (ParentCode = '#Code#' or Code = '#Code#')
	</cfquery>
      
    <td align="right" class="regular">
    	 <u>#NumberFormat(subtotal.amount,"___,___._")#</u>
	</td>
	<td></td>
  </tr> 
  
   <tr><td colspan="3">
	    <cfinclude template="AllotmentInquiryTransactionLine.cfm">
	 </td></tr>

</cfif>

</cfoutput>
</cfoutput>
</cfoutput>

<tr><td height="6"></td></tr>

</table>

<cf_tablebottom size="100%">

<cfoutput>
   <input type="hidden" name="Program"     value="#URL.Program#">
   <input type="Hidden" name="Edition"     value="#URL.Edition#">
   <input type="Hidden" name="No"     value="#No#">
</cfoutput>   

</form>