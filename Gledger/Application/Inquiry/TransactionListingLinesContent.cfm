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
<table class="navigation_table" style="width:98.5%" height="100%">
	
	<tr class="labelmedium line fixrow">
	    <TD width="2%"></TD>
		<TD width="90" style="padding-right:10px"><cf_tl id="TransNo"></TD>
	    <TD colspan="2" style="min-width:160px"><cf_tl id="Account"></TD>		
		<TD style="width:100%"><cf_tl id="Details"></TD>
	    <TD style="min-width:120px"><cf_tl id="Date"></TD>
	    <TD style="min-width:60px;padding-left:3px;padding-right:3px"><cf_tl id="Curr"></TD>
		<td style="min-width:100px" align="right"><cf_tl id="Debit"></td>
		<td style="min-width:100px" align="right"><cf_tl id="Credit"></td>
	    <td style="min-width:100px;padding-right:4px" align="right"><cf_tl id="Base Debit"></td>
		<td style="min-width:100px;padding-right:4px" align="right"><cf_tl id="Base Credit"></td>	
	</TR>		
	
	<cfoutput query="SearchResult" group="Currency">
	
	<cfset amtDT = 0>
	<cfset amtCT = 0>
				
	<cfoutput group="#URL.grouping#">
	
		<cfset amtD = 0>
		<cfset amtC = 0>
			
	    <cfif pages gte "1">
		
		<cfif currrow gte first and currrow lte last or first eq "1">
				
		   <cfswitch expression = URL.Grouping>
			     <cfcase value = "Journal">
			    	 <td colspan="11"  style="height:34" class="labellarge">#Journal# #JournalName#</td>
			     </cfcase>
			     <cfcase value = "AccountGroup">
				     <td colspan="11"  style="height:34" class="labellarge">#AccountGroup# #AccountGroupName#</td> 
			     </cfcase>	 
				 <cfcase value = "Posted">
				     <td colspan="11"  style="height:34" class="labellarge">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			     </cfcase>
			     <cfcase value = "TransactionDate">
				     <td colspan="11"  style="height:34" class="labellarge">#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</td>
			     </cfcase>
			     <cfdefaultcase>
			     	<td colspan="11" style="height:34" class="labellarge">#Journal# #JournalName#<b></td>
			     </cfdefaultcase>
		   </cfswitch>
		   
		   </tr>
		   
	   </cfif>	   
	   
	   </cfif>
	     
	<CFOUTPUT>
	
	    <cfif pages eq "1">
		
		     <cfset currrow = currrow + 1>
			 
	   		 <cfif currrow gte first and currrow lte last>
	
				<cfinclude template="TransactionListingLinesDetail.cfm">
			
			 <cfelseif currrow gt last>
			 		     				 
				 <tr><td height="14" colspan="11">
								 
					 <cfinclude template="Navigation.cfm">
								 
				 </td></tr>
	
				<cfset AjaxOnLoad("doHighlight")>	
				
				<script>
					parent.Prosis.busy('no')
				</script>
				
				<cfabort>
				
		     </cfif> 
			 
		<cfelse>
		
		    <cfinclude template="TransactionListingLinesDetail.cfm">
					
		</cfif>	
				
	</CFOUTPUT>
	
	   <cfif currrow gte first and currrow lte last>	
	
		   <cfif pages gte "1">
		  
		   <tr bgcolor="f6f6f6" class="line labelmedium">
		    <td></td>
		    <td colspan="8" align="right" style="padding-right:5px"><cf_tl id="Subtotal">:</td>
			<td style="padding-right:4px" align="right"><b>#NumberFormat(AmtD,',.__')#</b></td>	
			<td style="padding-right:4px" align="right"><b>#NumberFormat(AmtC,',.__')#</b></td>	
		   </TR>
		  
		   </cfif>
	   
	   </cfif>
	  
	</CFOUTPUT>
	
	   <cfif currrow gte first and currrow lte last or currrow eq "0">
	
	   <cfif embed eq "0">
	      
		   <TR bgcolor="f1f1f1" class="line labelmedium">
		    <td></td> 
		    <td colspan="8" align="right"><cf_tl id="Total"> #currency#:</td>
			<td style="padding-right:4px" align="right"><b>#NumberFormat(AmtDT,',.__')#</b></td>	
			<td style="padding-right:4px" align="right"><b>#NumberFormat(AmtCT,',.__')#</b></td>	
		   </TR>
		     
	   <cfelse>
	   
	   	<tr><td colspan="11" class="line"></td></tr>
	   
	   </cfif> 
	   
	   </CFIF>
	   	   
	</CFOUTPUT>
	
	</TABLE>