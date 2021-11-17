
<!--- filter by period and group by edition --->

<cfparam name="url.activityid"         default="">
<cfparam name="object.objectkeyvalue4" default="">
<cfparam name="url.mission"            default="">

<cfset access = "EDIT">

<cfif Object.ObjectKeyValue4 neq "">
	
	<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ProgramPeriodReview P
		WHERE     ReviewId =  '#Object.ObjectKeyValue4#' 	
	</cfquery>

	<cfset url.programCode = get.ProgramCode>
	<cfset url.period      = get.Period>
		
<cfelse>

	<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">
		
</cfif>

<cfinclude template="RequestScript.cfm">

<script>

	function togglecontent(bx) {
		   
		se  = document.getElementsByName("l"+bx)		
		se1 = document.getElementById("l"+bx+"_col")		
		se2 = document.getElementById("l"+bx+"_exp")
				
		count = 0
				
		if (se1.className == "regular") { 
		
		    se1.className = "hide";		
		    se2.className = "regular";
			while (se[count])
				{ se[count].className = "navigation_row labelit regular fixlengthlist"; 
				  count++; }
				  
		} else { 		  
		    se1.className = "regular"
			se2.className = "hide"
			while (se[count])
				{ se[count].className = "navigation_row labelit hide fixlengthlist"; 
				  count++; }
		}  
		
		}
		
	function toggleallotment(id,ob,yr) {
	
	 se = document.getElementById('box'+id+'_'+ob+'_'+yr) 
	 if (se.className == "hide") {	  	
	    se.className = "regular"	
		_cf_loadingtexthtml='';	
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/ProgramREM/Application/Budget/Request/getAllotmentDetail.cfm?Year='+yr+'&RequirementIdParent='+id+'&ObjectCode='+ob,'content'+id+'_'+ob+'_'+yr)
	 } else {
	    se.className = "hide"
	 }	
	
	}	
	
	function refreshview(prg,per,edi,obj) {
		Prosis.busy('yes')  
	    _cf_loadingtexthtml='';	
		ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/programrem/Application/Budget/Request/RequestResourceDetail.cfm?programcode='+prg+'&period='+per+'&editionid='+edi+'&objectcode=&cell=resource','boxresource') 		
	}
	
	
</script>

<cf_divscroll>

<table width="100%" align="center" border="0">
	
	<cfif Object.ObjectKeyValue4 eq "">
	<tr>
		<td style="padding-left:10px;padding-right:10px;padding-top:10px"> 
			<cfset url.attach = "0">
			<cfinclude template="../../Program/Header/ViewHeader.cfm">
		</td>
	</tr>
	
	<cfelseif access eq "EDIT" or access eq "ALL">
	
		<cfquery name="getProgram" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      Program
			WHERE     ProgramCode = '#url.ProgramCode#' 	
		</cfquery>
		
		<cfoutput>
		<tr><td style="padding-left:5px" class="labelmedium">
		  <a href="javascript:EditProgram('#url.programcode#','#url.period#','#getProgram.ProgramClass#','Resource')">Open in full view</a>
		  </td>
	    </tr>
		</cfoutput>
	
	</cfif>
	
	<tr>
		<td style="padding-left:10px;padding-right:15px">
		<cf_securediv id="boxresource" 
		  bind="url:#SESSION.root#/programrem/Application/Budget/Request/RequestResourceDetail.cfm?programcode=#url.programCode#&period=#url.period#&objectcode=&cell=resource">
		</td>
	</tr>

</table>

</cf_divscroll>

<input type="hidden" name="savecustom" id="savecustom" value="">

<cfif Object.ObjectKeyValue4 eq "">
	<cf_screenbottom html="No">
</cfif>
	   
   