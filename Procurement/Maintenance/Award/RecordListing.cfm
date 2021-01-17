
<cf_screentop height="100%" 
 			  scroll="Yes" 
			  layout="webapp" 
			  title="Award" 
			  html="No"			 
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

<table width="100%" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
 
 <cfoutput>
 
<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=490, height=390, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=490, height=390, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">
	
	<cf_divscroll>
	
	<table width="96%" align="center" class="navigation_table">
				   
		<tr class="line labelmedium2">   
		    <TD width="5%"></TD>
		    <TD width="70">Code</TD>
			<TD>Description</TD>
			<TD>Officer</TD>
		    <TD>Entered</TD>  
		</TR>
		
		<cfoutput query="SearchResult">
			 
		    <TR class="navigation_row line labelmedium2">
			<TD HEIGHT="20" align="center" style="padding-top:1px;">
				<cf_img icon="open" navigation="yes" onclick="recordedit('#Code#');">
			</TD>	
			<TD><a href="javascript:recordedit('#Code#')">#Code#</a></TD>
			<TD>#Description#</TD>
			<TD>#OfficerFirstName# #OfficerLastName#</TD>
			<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>	
			
		</CFOUTPUT>
		    
	</TABLE>
	
	</cf_divscroll>
		
	</td></tr>
	
</TABLE>


<cfset ajaxonload("doHighlight")>