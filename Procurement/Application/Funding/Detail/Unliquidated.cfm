
	<cfquery name="Obligation" 
	 datasource="AppsQuery"  
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT O.*, P.FullName
		FROM  Obligation_#Session.ACC#_#SESSION.FileNo# O LEFT OUTER JOIN 
			  Employee.dbo.Person P ON P.PersonNo = O.PersonNo
	</cfquery>
	
	 <cfquery name="Mission" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
			SELECT    *
			FROM      Ref_Mission
			WHERE     Mission = '#Obligation.Mission#'	
  	 </cfquery>	

	 <cfset row = "0">
	
	
<cfif Obligation.recordcount gte "1">

<table width="100%" class="navigation_table">	

	 <tr class="line"><td class="obligation labelmedium" colspan="3"
	    style="height:40px;padding-left:7px;font-size:23px;font-weight:200"><cf_tl id="Unliquidated Obligations"></td>
		
		<td colspan="7">
			<table><tr>
					  
		  		 <cfinvoke component="Service.Analysis.CrossTab"  
						  method         = "ShowInquiry"
						  buttonName     = "Excel"
						  buttonText     = "Export to MS - Excel"
						  buttonClass    = "td"
						  buttonIcon     = "#SESSION.root#/Images/sqltable.gif"
						  scriptfunction = "facttabledetailxls"
						  reportPath     = "Procurement\Application\Funding\Detail\"
						  SQLtemplate    = "UnliquidatedExport.cfm"  <!--- generates the data --->
						  queryString    = ""
						  dataSource     = "appsQuery" 
						  module         = "Program"
						  reportName     = "Budget: Unliquidated"
						  table1Name     = "Export file"
						  data           = "1"					  
						  ajax           = "1"
						  olap           = "0" 
						  excel          = "1"> 				  
						  
		 	  </tr></table>
			  
			 </td> 		   			
		
		</tr>
			 	 	
	 <cfoutput query="Obligation"  group="Period">
	 	 
	 	 <cfset oe = replace(URL.ObjectCode,".","","ALL")> 
		 <cfset oe = replace(oe," ","","ALL")>		 
		   
		<cfquery name="Total"
		     dbtype="query">
			SELECT    sum(ObligationAmount) as Amount
			FROM      Obligation
			WHERE     Period = '#Period#'
		</cfquery>
 
	  	<tr class="obligation linedotted">					      	       
		   <td colspan="8" height="15" style="height:30px;padding-left:8px" class="labellarge">#Period#</td>		  		   				    
		   <td align="right" class="labellarge" style="padding-right:16px">#NumberFormat(Total.Amount,",__.__")#</b></td>					   
	  	</tr>	
		
		<cfif mission.ProcurementMode eq "1">  
	 
			 <cfoutput>
			 
				 <tr class="filterrow navigation_row obligation line">
				   <td width="4%" align="center" style="padding-left:3px">
				    <cf_img icon="open"  onClick="ProcPOEdit('#PurchaseNo#','view')" tooltip="Open Purchase Order">				   
				   </td>
				   <td class="labelit"><a href="javascript:ProcPOEdit('#PurchaseNo#','view')"><font color="0080C0">#PurchaseNo#</a></td>					
				   <td class="labelit" colspan="5">#ItemMasterDescription# - #RequestDescription#</td>
				   <td class="labelit" align="right" style="padding-right:16px">#NumberFormat(ObligationAmount,",__.__")#</td>					 				  
				    <div class="filtercontent hide">#PurchaseNo# #ItemMasterDescription# - #RequestDescription#</div>	
				 </tr>		
				 				 		 
			</cfoutput>	
		
		<cfelse>
							 
			 <cfoutput group="ReferenceNo">		
			 
			 <cfset row = row+1>
	
		     <tr class="obligation line">
			 
			     <td style="padding-left:8px;min-width:50" class="labelit">#row#.</td>
		         <td colspan="8" style="padding-left:4px;width:100%" class="labelit"><font color="808080">#ReferenceName#</td>			     
				 
			 </tr>
			 
				<cfoutput>
				
					 <tr class="navigation_row obligation linedotted labelmedium filterrow">
					   
					   <td width="4%" align="center" height="15" style="padding-top:2px">
					    <cf_img icon="open" navigation="Yes" onclick="ShowTransaction('#Journal#','#journalSerialNo#')">									  
					   </td>
					   <td style="padding-left:4px">#JournalTransactionNo#</td>					
					   <td style="padding-left:4px" width="20%">			   
						   <cfif PersonNo neq "">
							   	<a title="View profile" HREF ="javascript:EditPerson('#PersonNo#')"><font color="0080C0">#FullName#</a>
						   </cfif>
					   </td>						   
					   <td>#dateformat(TransactionDate,CLIENT.DateFormatShow)#</td>
					   <td colspan="4">#Description#</td>				   
					   <td align="right" style="padding-right:16px">#NumberFormat(ObligationAmount,",__.__")#					 				  
					    <div class="filtercontent hide">#JournalTransactionNo# #Description#</div>	
						</td>
					 </tr>						 	
					 
				</cfoutput>	
		
		     </cfoutput>
		
		</cfif>		
	 	
	</cfoutput>	
</table>  
 </cfif>
 
 <script>
	Prosis.busy('no')
</script>	

 <cfset ajaxonload("doHighlight")>
 