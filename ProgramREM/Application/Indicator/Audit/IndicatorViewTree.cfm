<cf_screentop html="no">

<script language="JavaScript">

function refreshTree() {
	location.reload();
}

</script>

<cfset Criteria = ''>

<cfform>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="right">

  <tr><td>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	
		<cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  MIN(R.AuditDate) as AuditDate
		FROM    ProgramIndicatorAudit A INNER JOIN
		        ProgramIndicator I ON A.TargetId = I.TargetId INNER JOIN
		        Ref_Audit R ON A.AuditId = R.AuditId
		WHERE   I.ProgramCode = '#URL.ProgramCode#'
		AND	    I.Period = '#URL.Period#' 
		AND     A.AuditStatus = '0' 
		AND     R.Period =  '#URL.Period#' 
		AND     R.AuditDate <= getDate()
		</cfquery>
				
		<cfoutput> 
		
		<cfif Check.AuditDate neq "">
		
		<cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM Ref_Audit
		WHERE AuditDate = '#DateFormat(Check.AuditDate,CLIENT.DateSQL)#' 
		</cfquery>
		
		<tr><td height="10"></td></tr>		
		<tr>
		
		<td height="20">
			<img src="#SESSION.root#/Images/alert.gif" alt="" border="0"> : 
				<a href="IndicatorAudit.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Mode=Edit&AuditId=#Check.AuditId#" target="right">
				<b>#DateFormat(Check.AuditDate, CLIENT.DateFormatShow)#</b></a>
		</td></tr>
		
		<cfelse>
		
		<tr class="line">
		  <td>
		  <table width="100%">
		    <tr>
		    <td style="padding:5px" class="labelmedium"><img align="absmiddle" src="#SESSION.root#/Images/alert_good.gif" alt="" border="0"> <cf_tl id="No pending audits"></td>   
		    <td align="right" style="padding-right:4px">
		       <a href="javascript:refreshTree()">
          			<cfoutput>
          				<img align="absmiddle" src="#SESSION.root#/Images/refresh.gif" alt="" border="0">
					</cfoutput>						  
				</a>
		    </td>
		    </tr>
		  </table>
		  </td>
        </tr>
				
		</cfif>
		</cfoutput>
	  	      		  
        <tr>
        <td style="padding:5px"> 
				
		<cf_ProgramIndicatorAudit
		mode="audit"
		program = "#URL.programcode#"
		period =  "#URL.Period#">
		
        </td>
        </tr>
      
    </table></td>
  </tr>
</table>

<script language="JavaScript1.2">

{
<cfoutput>
parent.right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
</cfoutput>
}

</script>

</cfform>
