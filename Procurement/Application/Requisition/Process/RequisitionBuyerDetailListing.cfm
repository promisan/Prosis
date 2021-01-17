<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<cf_ListingScript>

<!--- End Prosis template framework --->

<!--- only pending jobs --->

<cfoutput>
<cfsavecontent variable="myquery"> 
  
	SELECT   B.ActorUserId, 
	         B.ActorLastName, 
			 B.ActorFirstName, 
			 R.Period,  
			 R.JobNo, 
			 J.CaseNo,
			 J.Description,
			 COUNT(*) AS Lines, 
			 SUM(R.RequestAmountBase) AS Total
	FROM     RequisitionLine R INNER JOIN
             RequisitionLineActor B ON R.RequisitionNo = B.RequisitionNo INNER JOIN
             Job J ON R.JobNo = J.JobNo
	WHERE    R.ActionStatus IN ('2k', '2q')
	AND      R.Mission      = '#URL.Mission#'
	GROUP BY B.ActorUserId, 
	         B.ActorUserId, 
			 B.ActorLastName, 
			 B.ActorFirstName, 
			 R.Period, 
			 R.JobNo, 
			 J.CaseNo, 
			 J.Description	
     
</cfsavecontent>
</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm="0">

<cfset itm = itm+1>

<cfset fields[itm] = {label      = "Officer",                    
					field      = "ActorLastName",
					filtermode = "2",
					search     = "text"}>
					
<cfset itm = itm+1>					
								
<cfset fields[itm] = {label      = "Period",                   			
					field      = "Period",		
					alias      = "R",					
					searchalias = "R",					
					align      = "center",	
					filtermode = "2",		
					search     = "text"}>		
					
<cfset itm = itm+1>					
					
<cfset fields[itm] = {label      = "Job",                    
					field      = "JobNo",
					alias      = "R",
					searchalias = "R",
					filtermode = "0",
					search     = "text"}>	
					
<cfset itm = itm+1>					
					
<cfset fields[itm] = {label      = "CaseNo",                    
					field      = "CaseNo",
					alias      = "R",
					filtermode = "0",
					search     = "text"}>																
					
<cfset itm = itm+1>					
					
<cfset fields[itm] = {label      = "Description",                  
					field      = "Description",
					filtermode = "0",
					search     = "text"}>
					
<cfset itm = itm+1>					
						
<cfset fields[itm] = {label      = "Lines", 
					width      = "0", 
					align      = "right",
					field      = "Lines"}>		
					
<cfset itm = itm+1>											
					
<cfset fields[itm] = {label      = "Value",    
					width      = "0", 
					align      = "right",
					field      = "Total",										
					formatted  = "numberformat(Total,',.__')"}>
					

<cf_listing
    header        = "myheader"
    box           = "inprocess"
	link          = "#SESSION.root#/Procurement/Application/Requisition/Process/RequisitionBuyerDetailListing.cfm?mission=#url.mission#"	
    html          = "No"
	show          = "100"
	datasource    = "AppsPurchase"
	listquery     = "#myquery#"
	listkey       = "JobNo"
	listgroup     = "ActorLastName"	
	listorder     = "JobNo"	
	listorderalias = "R"
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillmode     = "securewindow"
	drillargument = "940;1240;false;false"			
	drilltemplate = "/Procurement/Application/Quote/QuotationView/JobViewGeneral.cfm?mode=view&ID1="
	drillkey      = "JobNo">		
   
   <!---
     
   <table width="99%" cellspacing="0" cellpadding="0" align="center"><tr><td>
   						
	<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="0"
       align="center"
	   frame="void"
       bordercolor="#d0d0d0"
       bgcolor="#FFFFFF">
	   
			<tr>
		   	  <td width="20%"><cf_tl id="Officer"></td>
			  <td width="10%"><cf_tl id="Period"></td>
			  <td width="10%"><cf_tl id="Job"></td>
			  <td width="30%"><cf_tl id="Description"></td>
			  <td width="10%"><cf_tl id="Lines"></td>
			  <td width="10%" align="right"><cf_tl id="Value">&nbsp;</td>
		  </tr>
		     			
		   <cfoutput query="Buyer" group="ActorUserId">

			   <cfset b = 1>
		   
		   <cfoutput group="Period">
		   <cfoutput group="CaseNo">
		   <cfif b eq "1">
		   <tr><td colspan="6" bgcolor="d3d3d3"></td></tr>
		    <tr>
		      <td colspan="1">&nbsp;#ActorFirstName# #ActorLastName#</td> 
			  <td width="10%">#Period#</td>
			  <td width="10%"><a href="javascript:ProcQuote('#JobNo#','view')"><font color="0080FF">#CaseNo#</font></a></td>
			  <td width="30%">#Description#</td>
			  <td width="10%">#Lines#</td>
			  <td width="10%" align="right">#numberFormat(Total,"_,_.__")#&nbsp;</td>			
		    </tr>
			 <cfset b = 0>
		   <cfelse>
		   <tr><td></td><td colspan="5" bgcolor="d3d3d3"></td></tr>
		   <tr bgcolor="white">
		      <TD></TD>
		      <td width="10%">#Period#</td>
			  <td width="10%"><a href="javascript:ProcQuote('#JobNo#','view')"><font color="0080FF">#CaseNo#</font></a></td>
			  <td width="30%">#Description#</td>
			  <td width="10%">#Lines#</td>
			  <td width="10%" align="right">#numberFormat(Total,"_,_.__")#&nbsp;</td>			
		   </tr>
		   </CFIF>
		  
		   </cfoutput>
		   </cfoutput>
		  
		   </cfoutput>
	</table>
	
	--->
			