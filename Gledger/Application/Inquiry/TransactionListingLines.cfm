<cfparam name="first" default="0">
<cfparam name="pages" default="0">
<cfparam name="embed" default="0">
<cfparam name="header" default="1">
<cfparam name="URL.ID" default="Journal">

<!--- provision --->
<cfif URL.ID eq "PO">
	<cfset url.id = "Journal">
</cfif>

<cfif pages gte "1">

<tr><td colspan="11" class="line"></td></tr>
<tr class="line">
   <td colspan="2" height="20">
		<cfinclude template="Navigation.cfm"> 
   </td>
</tr>

</cfif>

<TR><td colspan="2" valign="top" height="100%">

	<cf_divscroll>
	
	<table class="navigation_table" style="width:98.5%" height="100%">
	
	<cfif header eq "1">
		<tr class="labelmedium line fixrow">
		    <TD width="2%"></TD>
			<TD width="90" style="padding-right:10px"><cf_tl id="TransNo"></TD>
		    <TD colspan="2"><cf_tl id="Account"></TD>		
			<TD><cf_tl id="Details"></TD>
		    <TD width="90"><cf_tl id="Date"></TD>
		    <TD style="padding-left:3px;padding-right:3px"><cf_tl id="Curr"></TD>
			<td style="min-width:100px" align="right"><cf_tl id="Debit"></td>
			<td style="min-width:100px" align="right"><cf_tl id="Credit"></td>
		    <td style="min-width:100px" align="right" style="padding-right:4px"><cf_tl id="Base Debit"></td>
			<td style="min-width:100px" align="right" style="padding-right:4px"><cf_tl id="Base Credit"></td>	
		</TR>	
	<cfelse>
		<tr>
		    <TD width="2%" height="1"></TD>
			<TD width="90"></TD>
		    <TD width="20%" colspan="2"></TD>	
			<TD width="20%"></TD>
		    <TD width="90"></TD>
		    <TD width="40"></TD>
			<td width="9%" align="right"></td>
			<td width="9%" align="right"></td>
		    <td width="9%" align="right"></td>
			<td width="9%" align="right"></td>	
		</TR>
	</cfif>
	
	<cfoutput query="SearchResult" group="Currency">
	
	<cfset amtDT = 0>
	<cfset amtCT = 0>
	
	<cfoutput group="#URL.ID#">
	
		<cfset amtD = 0>
		<cfset amtC = 0>
			
	    <cfif pages gte "1">
		
		<cfif currrow gte first and currrow lte last or first eq "1">
				
		   <cfswitch expression = URL.ID>
			     <cfcase value = "Journal">
			    	 <td colspan="11"  style="height:34" class="labellarge">#Journal# #JournalName#</b></td>
			     </cfcase>
			     <cfcase value = "AccountGroup">
				     <td colspan="11"  style="height:34" class="labellarge">#AccountGroup# #AccountGroupName#</b></td> 
			     </cfcase>	 
				 <cfcase value = "Posted">
				     <td colspan="11"  style="height:34" class="labellarge">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</b></td>
			     </cfcase>
			     <cfcase value = "TransactionDate">
				     <td colspan="11"  style="height:34" class="labellarge">#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</b></td>
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
		  
		   <tr bgcolor="f6f6f6" class="line">
		    <td></td>
		    <td class="labelit" colspan="8" align="right" style="padding-right:5px"><cf_tl id="Subtotal">:</td>
			<td class="labelit" style="padding-right:4px" align="right"><b>#NumberFormat(AmtD,',.__')#</b></td>	
			<td class="labelit" style="padding-right:4px" align="right"><b>#NumberFormat(AmtC,',.__')#</b></td>	
		   </TR>
		  
		   </cfif>
	   
	   </cfif>
	  
	</CFOUTPUT>
	
	   <cfif currrow gte first and currrow lte last or currrow eq "0">
	
	   <cfif embed eq "0">
	      
		   <TR bgcolor="f1f1f1" class="line">
		    <td></td> 
		    <td class="labelit" colspan="8" align="right"><cf_tl id="Total"> #currency#:</td>
			<td class="labelit" style="padding-right:4px" align="right"><b>#NumberFormat(AmtDT,',.__')#</b></td>	
			<td class="labelit" style="padding-right:4px" align="right"><b>#NumberFormat(AmtCT,',.__')#</b></td>	
		   </TR>
		     
	   <cfelse>
	   
	   	<tr><td colspan="11" class="line"></td></tr>
	   
	   </cfif> 
	   
	   </CFIF>
	   
	</CFOUTPUT>
	
	</TABLE>
	
	</cf_divscroll>

</td>

</tr>

 <cfif pages gte "1">	

 	 <tr><td colspan="2" class="line"></td></tr>
	 <tr class="line"><td height="14" colspan="2" class="regular">
			<cfinclude template="Navigation.cfm">
	 </td></tr>
	 
 </cfif> 
  
  