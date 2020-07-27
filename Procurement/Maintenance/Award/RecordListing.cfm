
<cf_screentop height="100%" 
 			  scroll="Yes" 
			  layout="webapp" 
			  title="Award" 
			  html="No"
			  label="Edit" 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_award
	ORDER BY Code
</cfquery>

<cf_divscroll>

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfset add          = "1">
<cfset Header       = "Award">
<cfinclude template = "../HeaderMaintain.cfm"> 
 
 <cfoutput>
 
<script>

function reloadForm(page) {
     window.location="RecordListing.cfm?Page=" + page; 
}

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=460, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=460, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">
	
	<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
				   
		<tr class="line labelmedium">   
		    <TD width="5%"></TD>
		    <TD width="70">Code</TD>
			<TD>Description</TD>
			<TD>Officer</TD>
		    <TD>Entered</TD>  
		</TR>
		
		<cfoutput query="SearchResult">
			 
		    <TR class="navigation_row line labelmedium">
			<TD HEIGHT="20" align="center" style="padding-top:1px;">
					<cf_img icon="select" navigation="yes" onclick="recordedit('#Code#');">
			</TD>	
			<TD><a href="javascript:recordedit('#Code#')">#Code#</a></TD>
			<TD>#Description#</TD>
			<TD>#OfficerFirstName# #OfficerLastName#</TD>
			<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>	
			
		</CFOUTPUT>
		    
		</TABLE>
		
		</td></tr>
	
	</TABLE>

</cf_divscroll>

<cfset ajaxonload("doHighlight")>