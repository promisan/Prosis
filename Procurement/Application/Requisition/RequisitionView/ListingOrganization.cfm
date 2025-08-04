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
<cfif url.id neq "WHS">

		<cfquery name="Requisition" 
	     datasource="AppsQuery" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT   *
	     FROM     tmp#SESSION.acc#Requisition#FileNo# 	 	  
		 ORDER BY #URL.Lay# 
         </cfquery>
	
		<cfoutput>
		<TR>
		    <td colspan="5" height="24">
			
			<table cellspacing="0" cellpadding="0" class="formpadding"><tr><td>
			 <cf_tl id="Export to Excel" var="vExport">
			 
			  <cfinvoke component="Service.Analysis.CrossTab"  
				  method      = "ShowInquiry"
				  buttonClass = "td"					  						 
				  buttonText  = "#vExport#"						 
				  reportPath  = "Procurement\Application\Requisition\RequisitionView\"
				  SQLtemplate = "RequisitionViewExcel.cfm"
				  queryString = ""
				  dataSource  = "appsQuery" 
				  module      = "Procurement"						  
				  reportName  = "Requisition View"
				  table1Name  = "Requisition"	
				  table2Name  = "Requisition Funding"						 
				  data        = "1"
				  ajax        = "1"
				  filter      = "1"
				  olap        = "0" 
				  excel       = "1"> 	
				  
				  </td></tr></table>
			
			</td>
		    <td height="21" width="40" colspan="3">&nbsp;&nbsp;Total:</td>
		    <td colspan="1" align="right">#numberformat(Check.Amount,",.__")#&nbsp;</td>
			<td></td>
		</TR>
		
		</cfoutput>
	
</cfif>

<cfoutput>

     <form method="post" name="formselected" id="formselected">
		<input type="hidden" name="selectedlines" id="selectedlines" value="#QuotedValueList(requisition.requisitionno)#">
	</form>
</cfoutput>



<cfoutput query="SearchResult" group="HierarchyCode">

	    <cfquery name="Requisition" 
		     datasource="AppsQuery" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   *
		     FROM     tmp#SESSION.acc#Requisition#FileNo# 
	 	     WHERE    OrgUnit = '#OrgUnit#'
			 <!--- disabled 
			 ORDER BY #URL.Lay# 
			 --->
        </cfquery>
		
				
	    <cfset previous = "">
		<cfset current  = "">
		
  		<cfset currrowX = currrow + Requisition.recordcount>
					
		<cfif currrowX gte first>
	  
			<tr bgcolor="e6e6e6" class="line">
		   	<td colspan="10" align="center">
				<font size="3"><b>#OrgUnitName#</b></font> 
			</td>
			</TR>
																	
			<cfloop query="Requisition">
			
			     <cfset currrow = currrow + 1>
				 
			     <cfif currrow gte first and currrow lte last>				
				        <cfinclude template="ListingDetail.cfm">  
				 <cfelseif currrow gt last>
         		     <tr><td height="14" colspan="10">
						 <cfinclude template="Navigation.cfm">
					 </td></tr>
					 					 
					<script>
						Prosis.busy('no')
					</script>
					 <cfset AjaxOnLoad("doHighlight")>	
				     <cfabort> 
					 
		         </cfif> 
	  	     </cfloop>
		     
        <cfelse>
	        <cfset currrow = CurrrowX> 
	     </cfif>		
	
		<cfif currrow gte last>
        	 <tr><td height="14" colspan="10" style="padding-right:10px">
			 <cfinclude template="Navigation.cfm">
		     </td></tr>			 			 
		</cfif>	

</CFOUTPUT>




