
<cfoutput>
	
	<cfif url.id eq "Loc">
			
		<cfquery name="Requisition" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    userquery.dbo.tmp#SESSION.acc#Requisition#FileNo# L
				WHERE 1=1			
				<cfif url.filter eq "me">		 
				AND   L.OfficerUserId = '#SESSION.acc#'
				<cfelseif url.filter neq "">
				AND   L.OfficerUserId = '#url.filter#'	
				</cfif>
				<cfif url.find neq "">		
				AND   (L.Reference LIKE '%#URL.find#%' OR L.RequisitionNo LIKE '%#URL.find#%' OR L.RequestDescription LIKE '%#URL.find#%') 
				</cfif> 	
				AND L.ActionStatus != '0'	
				ORDER BY #URL.Sort#
		</cfquery>	
				
    <cfelse>
	
		<cfquery name="Requisition" 
		     datasource="AppsQuery" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT   *
			     FROM     tmp#SESSION.acc#Requisition#FileNo# 
				 <cfif URL.ID eq "STA">
		 	     WHERE  ActionStatus='#URL.ID1#' 
				 </cfif>
	    </cfquery>
	
	</cfif>	
	
	<cfoutput>
	    <form method="post" name="formselected" id="formselected">		
		<input type="hidden" name="selectedlines" id="selectedlines" value="#QuotedValueList(requisition.requisitionno)#">
		</form>
	</cfoutput>
	
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
		<TR class="line">
		    <td colspan="5" bgcolor="white">
			
			<table>
			<tr class="labelmedium"><td>
			
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
				  
				  </td></tr>
			 </table>
			
			</td>
		    <td height="21" style="padding-left:20px" width="40" colspan="3"><cf_tl id="Total">:</td>
		    <td colspan="1" align="right"><b>#numberformat(Check.Amount,",.__")#</td>
			<td></td>
		</TR>
		
		</cfoutput>
	
    </cfif>
		
	<cfif Requisition.recordcount eq "0">
	
	 <tr><td height="40" colspan="10" align="center" class="labelmedium">						 
           	<font color="808080">There are no records to show in this view.</font> 			 
         </td>
	 </tr>
		 
	</cfif>	
	
	<cfif url.id eq "Loc">
	
		<cfquery name="Base" 
			     datasource="AppsQuery" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT   *
			     FROM     tmp#SESSION.acc#RequisitionBase#FileNo# 
	    </cfquery>
								
		<cfif Base.total gt Requisition.recordcount>
		
			 <tr><td height="18" colspan="10" align="center" class="labelmedium">						   			    
		           One or more requisitions match your search but you do not have access to these.		 				
	    	     </td>
			 </tr>
			 
		</cfif>	
		
	</cfif>
	<cfset currrowX = currrow + Requisition.recordcount>
    <cfset previous = "">
	<cfset current = "">
		
	<cfif currrowX gte first>	
																
			<cfloop query="Requisition">
												
			     <cfset currrow = currrow + 1>
			     <cfif currrow gte first and currrow lte last>
				        <cfinclude template="ListingDetail.cfm">  
						
				 <cfelseif currrow gt last>         				
				 
					 <tr><td height="14" colspan="10"><cfinclude template="Navigation.cfm"></td></tr>					 
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
        	
		 <tr><td height="14" colspan="10">						 
           	 <cfinclude template="Navigation.cfm">					 
         </td></tr>
			 			 
	</cfif>	
	  
</CFOUTPUT>


