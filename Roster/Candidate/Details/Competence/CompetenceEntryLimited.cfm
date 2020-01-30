
<script>
  
ie = document.all?1:0
ns4 = document.layers?1:0

function hl(bx,itm,fld,cnt){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 	 	 		 	
	 if (fld != false){
			 	 
	 sel  = document.getElementById("clCount");
	 var x = new Number();
	 x = parseInt(sel.value);
	 if (cnt == 1) {
		 x = x+1
		   if (x >= 4) {
		   	<cf_tl id="You exceeded the maximum number of selections" var="1">
			<cfoutput>
		     alert("#lt_text#")
			 </cfoutput>
			 bx.checked = false
			 } else {
			 sel.value = x;
			 itm.className = "highLight4";
			 }
		 }
		else { itm.className = "highLight4"; }
		 
	 } else {
		 
     itm.className = "header";		
	 if (cnt == 1) {
		 sel  = document.getElementById("clCount");	
		 var x = new Number();
		 x = parseInt(sel.value);
		 x = x-cnt
		 if (x < 0) {x=0}
		 sel.value = x;
		 }
	 }
  }
  
</script>

 <cfoutput>
     <input type="hidden" id="PersonNo" name="PersonNo" value = "#URL.ID#">
  </cfoutput>
  
<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td height="4"></td></tr>

<cfquery name="Master" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT distinct C.CompetenceCategory
  FROM Ref_Competence C
  WHERE C.Operational = 1
</cfquery>

<cfset cnt = 0>
<cfset x = 0>

<cfloop query="Master">

        <cfset ar = Master.CompetenceCategory>
		
		<cfquery name="GroupAll" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    R.*, S.ApplicantNo, C.CompetenceId as Selected
		FROM      ApplicantSubmission S INNER JOIN
                  ApplicantCompetence C ON S.ApplicantNo = C.ApplicantNo RIGHT OUTER JOIN
                  Ref_Competence R ON C.CompetenceId = R.CompetenceId 
				  AND S.PersonNo = '#Get.PersonNo#' 
				  AND S.Source  = '#url.source#'
		WHERE     R.CompetenceCategory = '#ar#'
		 AND      R.Operational = 1
	    ORDER BY  R.ListingOrder		
		</cfquery>	
		
	<tr><td>
					
       <table width="100%" class="regular">
	   	    		
		<cfoutput>
						
		<TR><td align="left" class="labelmedium" style="padding-left:5px">
		 								    		   
			<b>#Ar#</td></TR>
			
			</cfoutput>
							
    		<TR><td width="100%">
								
		    <cfoutput>
						
			<table width="100%" border="0" align="right" id="#Ar#">
			
			<tr>
    			<td width="30" valign="top">&nbsp;<img src="#SESSION.root#/Images/join.gif" alt=""></td>
				<td width="100%">
				
				<table width="100%" border="0" align="left">
			
					</cfoutput>
				
				    <cfset row = 0>
										
					<cfoutput query="GroupAll">
															
					<cfif row eq "3">
					    <TR>
						<cfset row = 0>
						<cfset cnt = cnt+20>
						
					</cfif>
					
					    <cfset row = row + 1>
						<td width="25%">
						<table width="100%">
							<cfif Selected eq "">
							          <TR class="regular">
							<cfelse>  <TR class="highlight4">
							</cfif>
							<td width="90%" class="labelit" style="padding-left:4px">#Description#</font></td>
							<TD width="10%" style="height:22px">
							<cfif Selected eq "">
							<input type="checkbox" id="fieldid" class="radiol" name="fieldid" value="#CompetenceId#" onClick="hl(this,this,this.checked,'1')"></TD>
							<cfelse>
							<input type="checkbox" id="fieldid" class="radiol" name="fieldid" value="#CompetenceId#" checked onClick="hl(this,this,this.checked,'1')"></td>
							<cfset x = x + 1>
						    </cfif>
						</table>
						</td>
						<cfif GroupAll.recordCount eq "1">
    						<td width="25%" class="regular"></td>
						</cfif>
					
					</CFOUTPUT>
												
			    </table>
				
				</td></tr>
				
				</table>
									
			</td></tr>
							
		</table>
		
	</td></tr>
		
</cfloop>		
				
</table>
