<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" scroll="Yes" html="No" jquery="yes">

<cfparam name="URL.ID" default="Hide">

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  J.*, 
	        (SELECT count(*) 
			 FROM  TransactionHeader 
			 WHERE Journal = J.Journal) as Lines,
			
			 (SELECT TOP 1 GLAccount 
			  FROM  JournalAccount  
			  WHERE Journal = J.Journal
			  AND   Mode = 'Contra'
			  ORDER BY ListDefault DESC) as GLAccount, 
			 
	         T.TransactionCategory as Category, 
			 T.Description as DescriptionCategory,
			 T.OrderListing 
	FROM   Journal J, Ref_transactionCategory T
	WHERE  J.transactionCategory = T.transactionCategory
	AND    J.Mission = '#URL.Mission#'
	ORDER BY J.Mission, T.OrderListing, J.Journal
</cfquery>


<script>

function reloadForm(sel) {
     ptoken.location("RecordListing.cfm?ID=" + sel) 
}

function recordadd(mis) {
     ptoken.open("RecordAdd.cfm?mission="+mis, "Add", "left=80, top=80, width=880, height=700, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id) {
     ptoken.open("RecordEdit.cfm?ID1=" + id, "Edit", "left=80, top=80, width=880, height=800, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

<div style="height:100%" class="clsPrintContent">

	<table width="98%" style="min-width:900px" height="100%" align="right" class="navigation_table">
	
	<tr class="clsNoPrint"><td height="5"></td></tr>
	<tr class="line clsNoPrint">
		<td colspan="4" class="labellarge" style="font-size:43px;font-weight:200;padding-top:9px;padding-left:7px;height:43px"><cfoutput>#url.Mission#</cfoutput><b></td>
		<td colspan="5" class="labelmedium" valign="bottom" align="right" style="padding-bottom:5px;">
			<table>
				<tr>
					<td class="labelmedium" valign="bottom" style="font-size:15px;padding-bottom:3px">
						<a href="javascript:recordadd('<cfoutput>#url.mission#</cfoutput>')">[<cf_tl id="Add Journal">]</a>  
					</td>
					<td valign="top" style="padding-top:4px;padding-left:8px;">
						<cfoutput>
							<span style="display:none;" id="printTitle">#url.Mission# <cf_tl id="Ledger Journal"></span>
							<cf_tl id="Print" var="1">
							<cf_button2 
								type		= "Print"
								mode		= "icon"
								text        = "" 
								id          = "Print"					
								width       = "28px"
								height		= "25px"
								printTitle	= "##printTitle"
								printContent= ".clsPrintContent">
						</cfoutput>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr style="height:20px" class="labelmedium line">
	    <td style="min-width:60px"></td>		
		<td style="min-width:70px"><cf_tl id="Class"></td>		
	    <td style="min-width:70px"><cf_tl id="Code"></td>
		<td style="min-width:60px"><cf_tl id="Curr"></td>			
		<td style="min-width:80px"><cf_tl id="System"></td>		
		<td style="width:50%"><cf_tl id="Name"></td>	
	    <td style="width:50%"><cf_tl id="Contra-account"></td>		
		<td style="min-width:60px"><cf_tl id="No"></td>
		<td style="min-width:60px;padding-left:4px;padding-right:30px">O</td>		
		<td>&nbsp;&nbsp;</td>
	</tr>
	
	<tr>
	<td colspan="10" align="right">
	
	<cf_divscroll>
	
	<table width="100%">
	
	<tr style="height:1px">
	   <td style="min-width:60px"></td>		
		<td style="min-width:70px"></td>		
	    <td style="min-width:70px"></td>
		<td style="min-width:60px"></td>			
		<td style="min-width:80px"></td>		
		<td style="width:50%"></td>	
	    <td style="width:50%"></td>		
		<td style="min-width:60px"></td>
		<td style="min-width:60px;padding-left:4px;padding-right:30px"></td>				
	</tr>
	
		
	<cfoutput query="SearchResult" group="OrderListing">
	
		  <tr>
		    <td colspan="9" style="font-size:23px;height:43;font-weight:200;padding-left:10px" class="labelmedium">#DescriptionCategory#</td>
		  </tr>	
		 
		   <cfoutput group="Journal">	 
		   
		   <cfif GLAccount neq "">
			   
				<cfquery name="GL"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
					FROM   Ref_Account
					WHERE  GLAccount = '#GLAccount#'
				</cfquery>
		
			</cfif>
			
			<cfif glcategory neq "Actuals">
				<cfset cl = "ffffcf">
			<cfelse>
				<cfset cl = "transparent">	
			</cfif>
		    
		    <tr style="height:20px" class="line labelmedium navigation_row">
				<td align="center" bgcolor="#cl#" class="navigation_action" style="height:18;padding-left:25px;padding-right:8px" onClick="recordedit('#Journal#')">
			  		<cf_img icon="edit">		
				</td>				
				<td bgcolor="#cl#">#GLCategory#</td>				
				<td bgcolor="#cl#" style="padding-left:2px;padding-right:2px"><a href="javascript:recordedit('#Journal#')"><font color="0080C0">#Journal#</font></a></td>
				<td bgcolor="#cl#" style="padding-left:2px;padding-right:2px">#Currency#</td>	
				<td bgcolor="#cl#" style="padding-left:2px;padding-right:2px">#left(SystemJournal,7)#..</td>
				<td bgcolor="#cl#" style="padding-left:2px;padding-right:2px">#Description#</td>									
				<td bgcolor="#cl#" style="padding-left:2px;padding-right:2px"><cfif GLAccount neq "">#GLAccount#<font color="808080"> : #GL.Description#</font></cfif></td>				
				<td bgcolor="#cl#" align="right" style="padding-right:4px"><cfif lines eq "0">-<cfelse>#Lines#</cfif></td>
				<td bgcolor="#cl#" align="right" style="padding-right:4px"><cfif Operational eq "1">Y<cfelse>N</cfif></td>
				
		    </tr>
					
		   </cfoutput>
		   
	</cfoutput>    
	
	
	</table>
	
	</cf_divscroll>
	
	</td>
	</tr>
	
	
	</table>
</div>
