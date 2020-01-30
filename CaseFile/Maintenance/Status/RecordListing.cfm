<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<HTML><HEAD><TITLE>Status</TITLE></HEAD>

<cfquery name="SearchResult" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_Status
	ORDER BY StatusClass
</cfquery>

<body>

<cf_divscroll>


<cfset add          = "1">
<cfset Header       = "Award">
<cfinclude template = "../HeaderCaseFile.cfm"> 

<cf_screentop html="no">
 
<cfoutput>
 
<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function statusedit(id1,id2) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1+"&ID2="+id2, "Edit", "left=80, top=80, width= 550, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>
	
<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table" >
	
	<tr class="labelmedium">			   
	    <td width="5%"></td>
	    <td><cf_tl id="Class"></td>
	    <td><cf_tl id="Code"></td>	
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Officer"></td>
	    <td><cf_tl id="Entered"></td>			  
	</tr>
		
	<cfoutput query="SearchResult">
			<tr class="navigation_row">
				<td align="center">
					<cf_img icon="open" navigation="yes" onclick="statusedit('#StatusClass#','#Status#')">
				</td>	
				<td>#StatusClass#</td>
				<td>#Status#</td>	
				<td>#Description#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>				
		    </tr>	 
	</cfoutput>
	

</table>

</cf_divscroll>

