	<cfquery name="Obligation" datasource="AppsQuery"  
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT * 
		FROM Obligation_#Session.ACC#_#SESSION.FileNo#
	</cfquery>
	   
	 <cfif Obligation.recordcount gt "0">
	 <table width="100%" style="border:0px solid silver" class="navigation_table">	 
		 <tr><td class="obligation linedotted labellarge" style="padding-left:5px" colspan="8" align="center"><cf_tl id="Obligated"></td></tr>
			 	
		 <cfoutput query="Obligation"  group="Period">
		 		 
		 	 <cfset oe = replace(URL.ObjectCode,".","","ALL")> 
			 <cfset oe = replace(oe," ","","ALL")>
		 
			 <cfoutput>
				 <tr class="obligation linedotted">
				   <td width="4%" align="center" height="15">				   
				    <cf_img icon="open" onClick="ProcPOEdit('#PurchaseNo#','view')">					
				   </td>
				   <td width="8%" class="labelit"><a href="javascript:ProcPOEdit('#PurchaseNo#','view')"><font color="0080C0">#PurchaseNo#</a></td>
				   <td class="labelit" colspan="5" width="80%">#ItemMasterDescription# - #RequestDescription#</td>
				   <td class="labelit" align="right" style="padding-right:16px">#NumberFormat(ObligationAmount,",__.__")#</td>					 					  
				 </tr>
								
			  </cfoutput>	
			  
			  <cfquery name="Total"
			         dbtype="query">
				SELECT    sum(ObligationAmount) as Amount
				FROM      Obligation
				WHERE     Period = '#Period#'
		       </cfquery>
	 
			  <tr class="obligation">					
			       <td></td>      
				   <td colspan="6" height="18" align="right">#Period#</td>		  		   				    
				   <td align="right" style="padding-right:16px;border-top:1px solid gray"><b>#NumberFormat(Total.Amount,",__.__")#</b></td>				    
			  </tr>
		 	
		  </cfoutput>	
 	</table>
  </cfif>  
  
  
<script>
	Prosis.busy('no')
</script>	

 <cfset ajaxonload("doHighlight")>