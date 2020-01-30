<cfdiv id="questionListing">

<cfquery name="getHeader"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1
			E.entityDescription, 
			D.documentDescription, 
			D.documentCode,
			D.documentId
	FROM	Ref_EntityDocument D,
			Ref_Entity E
	WHERE	D.entityCode = E.entityCode
	AND		D.entityCode = '#URL.entityCode#'
	AND		D.documentCode = '#URL.code#'
	AND		D.documentType = '#URL.type#'
	ORDER BY D.created desc
</cfquery>

<cf_screentop height="98%" label="Questionaire - #getHeader.entityDescription#" jquery="Yes"
   option="Questions Maintenance - [#getHeader.documentCode#] #getHeader.documentDescription#" user="No" scroll="Yes" layout="webapp" banner="gray">
   
<cfajaximport tags="cfwindow">

<cfquery name="SearchResult"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT	Q.*
	FROM	#CLIENT.LanPrefix#Ref_EntityDocumentQuestion Q,
			Ref_EntityDocument D
	WHERE	Q.documentId = D.documentId
	AND		D.entityCode = '#URL.entityCode#'
	AND		D.documentCode = '#URL.code#'
	AND		D.documentType = '#URL.type#'
	ORDER BY Q.listingOrder
</cfquery>

<cfoutput>

<script>

function questionpurge(id1, id2) {
	ColdFusion.navigate('objectElementQuestionPurge.cfm?entityCode=#URL.entityCode#&code=#URL.code#&type=#URL.type#&ID1=' + id1 + '&ID2=' + id2,'questionListing') 
}

function questionedit(id1, id2) { 
   
	try { ColdFusion.Window.destroy('myeditquestion',true) } catch(e) {}
	ColdFusion.Window.create('myeditquestion', 'Question', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    				
	ColdFusion.navigate('ObjectElementQuestionEditView.cfm?ID1=' + id1 + '&ID2=' + id2,'myeditquestion') 		

}

function questionrefresh() {
  _cf_loadingtexthtml='';		
  ptoken.location('objectElementQuestionList.cfm?entityCode=#URL.entityCode#&code=#URL.code#&type=#URL.type#')	
} 

</script>	

</cfoutput>

<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr><td height="10" colspan="7"></td></tr>

<tr>
	<td align="center" colspan="7">
		<cfoutput>
		<input class="button10g" STYLE="WIDTH:130" type="Button" name="AddRecord" id="AddRecord" value=" Add Question "
		 	onclick="questionedit('#getHeader.documentId#','')">
		</cfoutput>
	</td>
</tr>

<tr><td height="10" colspan="7"></td></tr>

<tr class="labelmedium linedotted">
	<td>Sort</td>
	<td>Code</td>
	<TD width="60%">Label</TD>
    <TD>Mode</TD>
	<td align="center">Att</td>
	<td align="center">Txt</td>
	<td></td>
	<td></td>
</TR>

<cfoutput query="SearchResult">
	  	
    <TR class="labelmedium linedotted navigation_row"> 
	<TD style="padding-left:3px">#listingOrder#</TD>
	<TD>#questionCode#</TD>
	<TD>#questionLabel#</TD>
	<TD>#inputMode#</TD>
	<TD style="padding-top:5px" align="center"><cfif enableinputAttachment eq "1">*</cfif></TD>
	<TD style="padding-top:5px" align="center"><cfif enableinputMemo eq "1">*</cfif></TD>
	
	<td align="center" width="20">
	   <cf_img icon="edit" navigation="Yes"  onclick="questionedit('#documentId#','#questionId#')">	  			
	</td>
	<td align="center" width="20">
		<cfquery name="verifyDelete"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM	OrganizationObjectQuestion
			WHERE 	questionId = '#questionId#'
		</cfquery>
		<cfif verifyDelete.recordCount eq 0>
			<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) questionpurge('#documentId#','#questionId#')">		
		</cfif>
	</td>
    </TR>
	    
</CFOUTPUT>

</table>

</cfdiv>
