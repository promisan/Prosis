<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="URL.isParent"         default="0">
<cfparam name="URL.resource"         default="">
<cfparam name="URL.mode"             default="list">
<cfparam name="url.ProgramHierarchy" default="">
<cfparam name="url.UnitHierarchy"    default="">
<cfparam name="url.editionid"        default="">

<cfquery name="Object" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Object
	WHERE  Code = '#url.objectcode#'	
</cfquery>	

<cfif url.resource eq "resource">
   <cfset res = Object.Resource>
<cfelse>
   <cfset res = "">  
</cfif>

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Program 
	WHERE    ProgramCode = '#URL.ProgramCode#' 	
</cfquery>

<!--- define expenditire periods --->
<cfquery name="Expenditure" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    DISTINCT Period
FROM      Ref_MissionPeriod
WHERE     Mission = '#Program.Mission#'
<cfif url.editionid eq "">
AND       EditionId IN (SELECT   EditionId
						FROM     Ref_MissionPeriod
						WHERE    Mission = '#Program.Mission#'
						AND      Period  = '#URL.Period#') 
<cfelse>
AND       EditionId = '#url.editionid#'
</cfif>						
</cfquery>

<cfset per = "">

<cfloop query="Expenditure">

  <cfif per eq "">
     <cfset per = "'#Period#'"> 
  <cfelse>
     <cfset per = "#per#,'#Period#'">
  </cfif>
  
</cfloop>

<cfif per eq "">

	<cf_message message="Allotment Edition has not been defined for this period.">

</cfif>

<cfset prghier = url.ProgramHierarchy>
<cfset orghier = url.UnitHierarchy>
<cfif ProgramHierarchy eq "undefined">
	   <cfset prghier = "">
</cfif>
<cfif UnitHierarchy eq "undefined">
	   <cfset orghier = "">
</cfif>

<!--- hide for debugging 7/7/2010 
	<cfoutput>
	<table>
	<tr><td>Mission:</td><td>#Program.mission#</td></tr>
	<tr><td>Period:</td><td>#per#</td></tr>	
	<tr><td>ProgramCode:</td><td>#URL.ProgramCode#</td></tr>
	<tr><td>ProgramHierachy:</td><td>#URL.ProgramHierarchy#</td></tr>
	<tr><td>UnitHierarchy:</td><td>#URL.UnitHierarchy#</td></tr>
	<tr><td>Object:</td><td>#url.ObjectCode#</td></tr>
	</table>
	</cfoutput>
--->	

<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Requisition" 
		   mission          = "#Program.mission#"
		   programhierarchy = "#prghier#"
		   unithierarchy    = "#orghier#"
		   programcode      = "#URL.ProgramCode#"
		   period           = "#per#" 
		   status           = "planned"
		   currency         = "#application.basecurrency#"
		   fund             = "#url.fund#"
		   Resource         = "#res#"
		   Object           = "#url.objectCode#"
		   ObjectParent     = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "View"
		   ReturnVariable   = "Planned">	
		  
<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Requisition" 
		   mission          = "#Program.mission#"
		   programhierarchy = "#prghier#"
		   programcode      = "#URL.ProgramCode#"
		   unithierarchy    = "#orghier#"
		   period           = "#per#" 
		   status           = "cleared"
		   currency         = "#application.basecurrency#"
		   fund             = "#url.fund#"
		   Resource         = "#res#"
		   Object           = "#url.objectCode#"
		   ObjectParent     = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "View"
		   ReturnVariable   = "Reservation">	
		
<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Obligation" 
		   mission          = "#Program.mission#"
		   programhierarchy = "#prghier#"
		   programcode      = "#URL.ProgramCode#"
		   unithierarchy    = "#orghier#"
		   period           = "#per#" 
		   currency         = "#application.basecurrency#"
		   fund             = "#url.fund#"
		   Resource         = "#res#"
		   Object           = "#url.objectCode#"
		   ObjectParent     = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "View"
		   ReturnVariable   = "Obligation">		
		  
<table width="96%" bgcolor="white" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="D1D1D1">
<tr><td>	   	 
	
<table cellpadding="0" width="100%" cellspacing="0">
   
 <cfif Obligation.recordcount eq "0" and Reservation.recordcount eq "0" and Planned.recordcount eq "0">		   
 
	 <tr><td align="center" height="30">There are no records to show in this view.
	 	 
	 <td align="right">
	   
			<cfoutput>
					   
			   	<img src = "#SESSION.root#/Images/close3.gif" 
					alt="hide" 
					border="0" 
					align  = "right" 
					class="regular" 
					style="cursor: pointer;" 
					onClick= "document.getElementById('add#url.box#').className='hide'">
	
			</cfoutput>	
	   
	 </td>			
	 </tr> 
 
 <cfelse>
 
	<tr><td>
	
	<table width="100%"  bgcolor="ffffff" align="right">  
	
	 <tr>
		 
	 <td>
	 
	     <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	     <tr>
		   <td>&nbsp;</td>	  		  
		   <td colspan="1" height="22">
				   		    
		    <cfinvoke component="Service.Analysis.CrossTab"  
				  method      = "ShowInquiry"
				  buttonClass = "td"					  						 
				  buttonText  = "Export&nbsp;Excel"						 
				  reportPath  = "Procurement\Application\Requisition\Requisition\"
				  SQLtemplate = "RequisitionEntryFundingExcel.cfm"
				  queryString = "Mission=#Program.mission#&Period=#url.period#&isParent=1&ObjectCode=#url.ObjectCode#&Fund=#url.fund#&prghier=#prghier#&orghier=#orghier#"
				  dataSource  = "appsPurchase" 
				  module      = "Procurement"						  
				  reportName  = "Execution Report"
				  table1Name  = "Forecast"
				  table2Name  = "Requested"
				  table3Name  = "Obligated"
				  table4Name  = "Unliquidated"
				  table5Name  = "Disbursed"
				  data        = "1"
				  ajax        = "1"
				  filter      = "1"
				  olap        = "0" 
				  excel       = "1"> 	
						  
			</td>	
				
			<td width="90%"></td>
				
			<td align="right">
	   
				   <cfoutput>
		   
				   	<img src = "#SESSION.root#/Images/close3.gif" 
						alt="hide" 
						border="0" 
						align  = "right" 
						class="regular" 
						style="cursor: pointer;" 
						onClick= "document.getElementById('add#url.box#').className='hide'">
	
				  </cfoutput>	
	   
	   		</td>			
						  
		 </tr>
		 </table>
	 </td>
	 
 </tr>
	 
 <tr><td class="line"></td></tr>
	 
 <tr>
		 
	 <td>	 
	
		<table width="100%" 		    
			 bgcolor="ffffff" 	
			 align="right" 
			 class="formpadding formspacing">
			 
				 <cfif Planned.recordcount neq "0">
				    
					 <cfoutput query="Planned" group="Period">
					 
						   <cfquery name="Total" dbtype="query">
							SELECT    sum(ReservationAmount) as Amount
							FROM      Planned
							WHERE     Period = '#Period#'
						  </cfquery>
					 
						  <tr class="labelmedium"> 		      
							   <td width="70%" height="18" colspan="5"><cf_tl id="Planned"> #Period#</td>		  
							   <td align="right"><b>#NumberFormat(Total.Amount,",__")#</b></td>
							   <td width="20"></td>
						 </tr>				 
						
						 <cfset oe = replace(URL.ObjectCode,".","","ALL")> 
						 <cfset oe = replace(oe," ","","ALL")>
						 						 					    
						 <cfoutput>
						 
						 	<cftry>
						 
							 <tr>
							 	<td width="4%" align="center" height="18">
								    <img src="#SESSION.root#/Images/contract.gif" alt="Open Requisition" name="c#oe#_#currentrow#" 
										  onMouseOver="document.c#oe#_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
										  onMouseOut="document.c#oe#_#currentrow#.src='#SESSION.root#/Images/contract.gif'"
										  style="cursor: pointer;" alt="" width="11" height="11" border="0" align="absmiddle" 
										  onClick="ProcReqEdit('#RequisitionNo#','dialog')">
							   </td>
							   <td width="10%"><a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')">#Reference#</font></a></td>
							   <td width="50">#ObjectCode#</td>
							   <td width="70%">#ItemMasterDescription# #RequestDescription#</td>
							   <td></td>			 
							   <td align="right">#NumberFormat(ReservationAmount,",__")#</b></td>
							   <td width="40"></td>
							  
							 </tr>		
							 
							 <cfcatch></cfcatch>						 
							 
							 </cftry>
						 
						 </cfoutput>
						 										 
					 </cfoutput> 
					 
				 </cfif>
			  
			 <cfif Reservation.recordcount neq "0">
			    
				 <cfoutput query="Reservation" group="Period">
				 
					   <cfquery name="Total"
						         dbtype="query">
						SELECT    sum(ReservationAmount) as Amount
						FROM      Reservation
						WHERE     Period = '#Period#'
					  </cfquery>
				 
					  <tr class="labelmedium"> 		      
						   <td width="70%" height="18" colspan="5"><cf_tl id="Pre-encumbered"> #Period#</b></td>		  
						   <td align="right"><b>#NumberFormat(Total.Amount,",__")#</b></td>
						   <td width="20"></td>
					 </tr>
					 		 
					 <cfset oe = replace(URL.ObjectCode,".","","ALL")> 
					 <cfset oe = replace(oe," ","","ALL")>
				    
					 <cfoutput>
					 
						 <tr>
						 	<td width="4%" align="center" height="18">
							    <img src="#SESSION.root#/Images/contract.gif" alt="Open Requisition" name="c#oe#_#currentrow#" 
									  onMouseOver="document.c#oe#_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.c#oe#_#currentrow#.src='#SESSION.root#/Images/contract.gif'"
									  style="cursor: pointer;" alt="" width="11" height="12" border="0" align="absmiddle" 
									  onClick="ProcReqEdit('#RequisitionNo#','dialog')">
						   </td>
						   <td width="10%"><a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')">#Reference#</a></td>
						    <td width="50">#ObjectCode#</td>
						   <td width="70%">#ItemMasterDescription# #RequestDescription#</td>
						   <td></td>			 
						   <td align="right">#NumberFormat(ReservationAmount,",__")#</b></td>
						   <td width="40"></td>					  
						 </tr>								 
					 
					 </cfoutput>				 
					 
				 </cfoutput> 
				 
			 </cfif>
			 
			 <cfif url.mode neq "List">
			 
				 <cfif Obligation.recordcount neq "0">
				 	
					 <cfoutput query="Obligation"  group="Period">
					 
					  <cfquery name="Total"
						         dbtype="query">
						SELECT    sum(ObligationAmount) as Amount
						FROM      Obligation
						WHERE     Period = '#Period#'
					  </cfquery>
				 
					 <tr class="labelmedium">		
					      
						   <td colspan="4" height="18">Obligated #Period#</td>		  		   
						   <td width="125"></td>		   
						   <td align="right"><b>#NumberFormat(Total.Amount,",__")#</b></td>
						   <td width="20"></td>
						   
					 </tr>
					 		 
					 	 <cfset oe = replace(URL.ObjectCode,".","","ALL")> 
						 <cfset oe = replace(oe," ","","ALL")>
					 
						 <cfoutput>
							 <tr class="labelmedium">
							   <td width="4%" align="center" height="18">
							    <img src="#SESSION.root#/Images/contract.gif" alt="Open Purchase order" name="b#oe#_#currentrow#" 
									  onMouseOver="document.b#oe#_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.b#oe#_#currentrow#.src='#SESSION.root#/Images/contract.gif'"
									  style="cursor: pointer;" alt="" width="11" height="12" border="0" align="absmiddle" 
									  onClick="ProcPOEdit('#PurchaseNo#','view')">
							   </td>
							   <td width="10%"><a href="javascript:ProcPOEdit('#PurchaseNo#','view')">#PurchaseNo#</a></td>
							    <td width="50">#ObjectCode#</td>
							   <td>#ItemMasterDescription# - #RequestDescription#</td>
							   <td></td>
							   <td align="right">#NumberFormat(ObligationAmount,",__")#</td>
							  <td width="26"></td>
							  
							 </tr>
							
						  </cfoutput>	
					 	
					  </cfoutput>	
				 
				 </cfif>
			 
			 </cfif>
			   
			</table>
	 
	</td></tr>
	
	</table>
	
	</td></tr>
	
	</cfif>
	
</table>

</td></tr>

</table>	   	
