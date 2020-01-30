<cfquery name="Pipeline" datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	SELECT * 
	FROM Pipeline_#Session.ACC#_#SESSION.FileNo#
</cfquery>
	
<cfif Pipeline.recordcount neq "0">
<table width="100%" style="border:0px solid silver" class="navigation_table">
		 <tr><td class="pipeline linedotted labellarge" colspan="8" style="padding-left:5px">Forecast</td></tr>
		    
		 <cfoutput query="Pipeline" group="Period">
		 
			   <cfquery name="Total"
				         dbtype="query">
				SELECT    sum(ReservationAmount) as Amount
				FROM      Pipeline
				WHERE     Period = '#Period#'
			  </cfquery>
		 
			 <tr bgcolor="ffffaf" class="pipeline"> 		
			    <td></td>      
				<td class="labelit" height="18" colspan="6">#Period#</td>		  
				<td class="labelit" align="right" style="padding-right:16px"><b>#NumberFormat(Total.Amount,",__.__")#</b></td>					 
			 </tr>				 
			
			 <cfset oe = replace(URL.ObjectCode,".","","ALL")> 
			 <cfset oe = replace(oe," ","","ALL")>
		    
			 <cfoutput>
			 
				 <tr class="pipeline line navigation_row">
				 	<td class="labelit" width="4%" align="center" height="15" style="padding-top:3px">
					  <cf_img icon="open"  onClick="ProcReqEdit('#RequisitionNo#','dialog')" tooltip="Open Requisition">			
				   </td>
				   <td class="labelit" width="10%"><a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')"><font color="0080C0">#Reference#</font></a></td>
				   <td class="labelit" width="80" style="padding-left:3px">#ObjectCode#</td>
				   <td class="labelit" colspan="4" style="padding-left:3px" width="80%">#ItemMasterDescription# #RequestDescription#</td>					   		 
				   <td class="labelit" width="10%"align="right" style="padding-left:3px;padding-right:16px">#NumberFormat(ReservationAmount,",__.__")#</b></td>					 					  
				 </tr>	
				 				 
			 
			 </cfoutput>
							 
		 </cfoutput> 
</table>
 </cfif>
 
<cfset ajaxOnLoad("doHighlight")>
 
<script>
	Prosis.busy('no')
</script>	
