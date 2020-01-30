
<cfquery name="Check"
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
	FROM     Ref_Validation
	WHERE Code = '#URL.ID#'
</cfquery>
<cfoutput>

<cfparam name="URL.Mode" default="">

<cfif url.mode eq "">
<cf_screentop height="100%" layout="webapp" banner="gray" scroll="yes" label="#Check.description#">
</cfif>

<cffile action = "read" 
        file = "#SESSION.rootpath#\#Check.ValidationPath#\#Check.ValidationTemplate#" 
		variable = "content">

	<table width="100%" border="0" cellspacing="0" cellpadding="3" bordercolor="C0C0C0" rules="groups">
		<tr><td bgcolor="f4f4f4"><b>&nbsp;Validation:</b></td><td bgcolor="f4f4f4">#Check.Description#</td></tr>
		<tr><td bgcolor="f4f4f4"><b>&nbsp;File name:</b></td><td bgcolor="f4f4f4">#Check.ValidationPath#\#Check.ValidationTemplate#</td></tr>
		<tr><td colspan="2"><table width="100%" cellspacing="2" align="center" cellpadding="2"><tr><td>
		
		<cfinvoke component="Service.Presentation.ColorCode"  
		   method="colorfile" 
		   filename="#SESSION.rootpath#\#Check.ValidationPath#\#Check.ValidationTemplate#" 
		   returnvariable="result">			
           <cfset result = replace(result, "Â", "", "all") />
		   
		   <div style="position:relative;width:100%;height:100%; overflow: auto; scrollbar-face-color: F4f4f4;">
			#result#			
		   </div>		
			
			</td></tr></table>
		</td></tr>
	</table>
	
</cfoutput>
