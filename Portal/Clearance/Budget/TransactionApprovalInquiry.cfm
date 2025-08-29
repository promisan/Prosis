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

<cf_dialogREMProgram> 

<script language="JavaScript">
function clicked(item) {
alert(item)
}
</script>

<cfparam name="URL.Program" default="P001">
<cfparam name="URL.Fund" default="XXXX">
<cfparam name="URL.Width" default="0">

<!--- Program header summary and necessary Params for expand/contract --->
<cfparam name="URL.Verbose" default="#CLIENT.Verbose#">
<cfset #CLIENT.Verbose# = #URL.Verbose#>
<cfset Caller = "AllotmentApprovalInquiry.cfm?Program=#URL.Program#&Fund=#URL.Fund#&Width=#URL.Width#&Period=#URL.Period#">
<cfparam name="URL.ProgramCode" default="#URL.Program#">

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       Ref_AllotmentEdition
WHERE      ControlEdit = '1'	
AND        Fund = '#URL.Fund#'   
</cfquery>

<cfif Edition.recordcount eq "0">

  <cf_message message = "No allotment editions were defined for fund : <cfoutput>#URL.Fund#.</cfoutput>"
  return = "back">
  <cfabort>

</cfif>

<cfset editionList = "">
<cfoutput query="Edition">
	<cfif editionlist eq "">
	    <cfset editionlist = #EditionId#>
	<cfelse>
	    <cfset editionlist = #editionlist#&","&#EditionId#>
	</cfif> 
</cfoutput>

<cfinclude template="AllotmentPrepare.cfm">

<cfform action="TransactionApprovalSubmit.cfm?Caller=External" method="POST" enablecab="Yes" name="entry">

<cfquery name="Class" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       Program
WHERE      ProgramCode = '#URL.Program#'	   
</cfquery>

<cfif Class.ProgramClass eq "Program">
    <cfinclude template="../../../ProgramREM/Application/Program/ProgramViewHeader.cfm">
<cfelse>
    <cfinclude template="../../../ProgramREM/Application/Program/ComponentViewHeader.cfm">
</cfif>	

<cfset InnerWidth = "280">
<cfset No = 0>
<cfloop query="Edition">
  <cfset InnerWidth = #InnerWidth# + 80>
  <cfset No = No+1>
</cfloop>  

<cfset ColNum = (#No#+4)*3>
<cfset ColWidthUnit = 100/#ColNum#>
<cfset DescWidth = #ColWidthUnit#*9>
<cfset ValueWidth = #ColWidthUnit#*2>
<cfset CheckWidth = #ColWidthUnit#>

<cfset OuterWidth = #InnerWidth#+20>

<cfparam name="URL.Width" default="0">

<cfif #InnerWidth# lt #URL.Width#>
  <cfset OuterWidth = "100%">
  <cfset InnerWidth = "100%">
</cfif>


<cfoutput>

<table width="100%" border="1"  cellspacing="0" cellpadding="0" align="center" bordercolor="002350" bgcolor="f6f6f6" class="formpadding">

<tr>
  <td width="#DescWidth#%" height="22" class="bannerXLN"><cfoutput>
  &nbsp;<b>Description</cfoutput></b></td> 
  
  <cfloop index="Edition" list="#EditionList#" delimiters=",">
  
	<cfquery name="Edit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       Ref_AllotmentEdition
	WHERE      EditionId = '#Edition#'	   
	</cfquery>

  <td width="#ValueWidth#%" height="26" align="right" valign="top" class="bannerXLN">
  	<cfoutput><b>#Edit.Period# #Edit.Description#</b></cfoutput>
	</td>
	<td width="#CheckWidth#%"  class="bannerXLN"></td>    
  </cfloop>
  
  <td width="#ValueWidth#%" align="right" valign="top" class="bannerXLN">
    	 <b>Total</b>
	</td>
  <td width="#CheckWidth#%"  class="bannerXLN"></td>
</tr>  
  
<tr><td class="topN"></td>
  
  <cfloop index="Edition" list="#EditionList#" delimiters=",">
  <td align="right" class="topN">($'000)</td>
  <td class="topN"></td>
  </cfloop>
  
  <td align="right" class="topN">
    	 ($'000)
	</td>
  <td class="topN"></td>
</tr>    

</table>

<cf_tabletop size="#OuterWidth#" omit="true">

<table width="#InnerWidth#" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="002350" bgcolor="ffffff" class="formpadding">

<tr>
<td colspan="#No#+2">
</tr>

<tr>

<td colspan="#No#+2">
</cfoutput>

<cfquery name="SearchResult" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM #SESSION.acc#Allotment
ORDER BY CategoryOrder, ListingOrder, Code 		   
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<cfoutput>
<tr>
  <td width="#DescWidth#%" class="regular"><b>Expenditure</b></td>
  
   <cfloop index="Edition" list="#EditionList#" delimiters="' ,">
   
    <cfquery name="Subtotal" dbtype="query">
      SELECT  sum(Edition_#Edition#) as amount, sum(Total) as total
      FROM    Searchresult
      </cfquery>
      
    <td width="#ValueWidth#%" align="right" class="regular">
    	 <b><u>#NumberFormat(subtotal.amount,"___,___._")#</u></b>
	</td>
	<td width="#CheckWidth#%"></td>
	
   </cfloop>
   
    <td width="#ValueWidth#%" align="right" class="regular">
    	 <b><u>#NumberFormat(subtotal.Total,"___,___._")#</u></b>
	</td>
	<td width="#CheckWidth#%"></td>
   
  
</tr> 
</cfoutput>

<cfset CLIENT.ObjectNo = 0>
<cfset NewEdition = "">

<cfoutput query="SearchResult" group="Category">
<tr>
  <td height="10" colspan="2"></td>
</tr>
<tr>
  <td class="regular"><b>#Category#</b></td>
  
   <cfloop index="Edition" list="#EditionList#" delimiters="' ,">
   
    <cfquery name="Subtotal" dbtype="query">
      SELECT  sum(Edition_#Edition#) as amount, sum(Total) as total
      FROM    Searchresult
      WHERE   Category = '#Category#'
	</cfquery>
      
    <td width="100" align="right" class="regular">
    	 <b><u>#NumberFormat(subtotal.amount,"___,___._")#</u></b>
	</td>
	<td></td>
	
   </cfloop>
     
    <td width="100" align="right" class="regular">
    	 <b><u>#NumberFormat(subtotal.total,"___,___._")#</u></b>
	</td>
  
</tr> 

<tr>
  <td height="5"></td>
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
		<td width="250" class="regular">&nbsp;&nbsp;#Description#</td>
		
	<cfloop index="Edition" list="#EditionList#" delimiters="' ,">
		<cfset val = evaluate("SearchResult.Edition_"&#Edition#)> 
	
		<cfquery name="Prior" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT     SUM(Amount/1000) AS Amount
			    FROM       ProgramAllotmentDetail
				WHERE      Status = '1' 
				AND		   ProgramCode = '#URL.Program#'	   
			 	AND        EditionId = '#Edition#'
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

		<td width="100" align="right" class="regular">
		   #NumberFormat(val,"___,___._")#
		</td>
		<td>
			<cfif #diff# neq "0">
				<cfset CLIENT.ObjectNo = #CLIENT.ObjectNo# + 1>
				<input type="checkbox" name="Check_#CLIENT.ObjectNo#" value="1" checked>
				<input type="hidden" name="Edition_#CLIENT.ObjectNo#" value="#Edition#">
				<input type="hidden" name="Object_#CLIENT.ObjectNo#" value="#Code#">
				<input type="hidden" name="Amount_#CLIENT.ObjectNo#" value="#diff#">
			</cfif>
		</td>
	 	</cfloop>

		<td width="100" align="right" class="regular">
    	 <b>#NumberFormat(total,"___,___._")#</b>
		</td>
		
		</tr> 
		
   <cfelse>

   <tr>
     <td width="250" class="regular"><img src="../../../../Images/join.gif" alt="" width="19" height="10" border="0">
	 &nbsp;&nbsp;<font color="gray">#Description#</font></td>
	 
	 <cfloop index="Edition" list="#EditionList#" delimiters="' ,">
   	 <cfset val = evaluate("Edition_"&#Edition#)> 
	 
 	  <cfquery name="Prior" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
        SELECT     SUM(Amount/1000) AS Amount
        FROM       ProgramAllotmentDetail
		WHERE      Status = '1' 
		AND		   ProgramCode = '#URL.Program#'	   
    	AND        EditionId = '#Edition#'
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
	 
     <td width="100" align="right" class="regular">
	   <font color="gray">
	   #NumberFormat(val,"___,___._")#</font>
	  </td>
	 <td>
	  <cfif #diff# neq "0">
		<cfset CLIENT.ObjectNo = #CLIENT.ObjectNo# + 1>
		<input type="checkbox" name="Check_#CLIENT.ObjectNo#" value="" checked>
		<input type="hidden" name="Edition_#CLIENT.ObjectNo#" value="#Edition#">
		<input type="hidden" name="Object_#CLIENT.ObjectNo#" value="#Code#">
		<input type="hidden" name="Amount_#CLIENT.ObjectNo#" value="#diff#">
	  </cfif>
	 </td>
	 </cfloop>
	 
	  <td width="100" align="right" class="regular">
	  <font color="gray">
    	 <b>#NumberFormat(total,"___,___._")#</b></font>
	  </td>
   </tr> 
   </cfif>

<cfelse>

<tr>
  <td class="regular">&nbsp;&nbsp;#Description#</td>
  
  <cfloop index="Edition" list="#EditionList#" delimiters="' ,">
   
    <cfquery name="Subtotal" dbtype="query">
      SELECT  sum(Edition_#Edition#) as amount, sum(Total) as total
      FROM    Searchresult
      WHERE   (ParentCode = '#Code#' or Code = '#Code#')
	</cfquery>
      
    <td width="100" align="right" class="regular">
    	 <u>#NumberFormat(subtotal.amount,"___,___._")#</u>
	</td>
	<td></td>
	
   </cfloop>
   
    <td width="100" align="right" class="regular">
    	 <b><u>#NumberFormat(subtotal.total,"___,___._")#</u></b>
	</td>
  
</tr> 

</cfif>


</cfoutput>

</cfoutput>
</cfoutput>

</table>


</td></tr>

<cfoutput>
<tr><td height="6"></td></tr>
<tr>
	<td height="20" colspan="#No+2#" align="right" class="top3N">
	<input type="submit" class="button7" name="Approve" value="Submit Approval">&nbsp;
	<input type="button" class="button7" name="Cancel" value="Cancel" onClick="window.close()">&nbsp;
	</td>
</tr>
</cfoutput>
</table>

<cf_tablebottom size="#OuterWidth#">

<cfoutput>
   <input type="Hidden" name="Program"     value="#URL.Program#">   
   <input type="Hidden" name="Fund"        value="#URL.Fund#">
   <input type="Hidden" name="Period"      value="#URL.Period#">
</cfoutput>
</cfform>

</body>
</html>
