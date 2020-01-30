
<cfset url.editionid = url.edition>

<script language="JavaScript">

 function apply(ed,per,prg,fd,obj,val,fdlist) {
   ColdFusion.navigate('ApplyAmount.cfm?period='+per+'&editionid='+ed+'&programcode='+prg+'&fund='+fd+'&objectcode='+obj+'&val='+val+'&fdlist='+fdlist,'process')
 }
 
 function more(ed,per,prg,fd,obj,spc,fdlist) { 
    
   se = document.getElementById('crow_'+prg+'__'+obj) 
   rt = document.getElementById('rgt_'+prg+'__'+obj)
   dw = document.getElementById('dwn_'+prg+'__'+obj)
   
   if (se.className == "hide") {      
      se.className = "regular"
	  rt.className = "hide"
	  dw.className = "regular"
      ColdFusion.navigate('AllocationEntryDetailLog.cfm?period='+per+'&editionid='+ed+'&programcode='+prg+'&fund='+fd+'&objectcode='+obj+'&spc='+spc+'&fdlist='+fdlist,'c_'+prg+'__'+obj)
   } else {
      se.className = "hide"
	  rt.className = "regular"
	  dw.className = "hide"
   }  
 
 }

</script>

<cfquery name="Edition"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT E.*, V.ObjectUsage
	FROM   Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE  E.Version    = V.Code
	AND    E.EditionId  = '#url.editionid#'	
</cfquery>

<!--- ------------------------------------------ --->
<!--- create temp tables to support this process --->
<!--- ------------------------------------------ --->
<cfinclude template="AllocationPrepare.cfm">
<!--- ------------------------------------------ --->
<!--- ------------------------------------------ --->

<cf_screentop height="100%" label="Release of funds edition #Edition.description#" option="Planning period: #url.period#"
   scroll="Yes" jquery="Yes" html="Yes" layout="webapp" banner="green" busy="busy10.gif" bannerheight="50">
	
	<cfquery name="FundList"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_AllotmentEditionFund	
		WHERE  EditionId = '#url.editionid#'	
	</cfquery>
	
	<form method="post" style="height:100%" name="fundform" id="fundform">
		
		<table height="100%" align="center" cellspacing="0" cellpadding="0">
		
		<tr class="hide"><td colspan="2" height="14" id="process"></td></tr>
		
		<tr>
		
			<td width="120" height="100%" valign="top" style="padding-top:8px;padding-left:10px;padding-right:10px;">
			
			   <table height="99%" style="border-right: 0px solid silver;">
			   
			   <tr><td height="20" width="100" align="center" class="labelmedium"><cf_tl id="Fund"></td></tr>
			   
			   <tr><td class="line"></td></tr>
			   
			   <tr><td height="100%" width="90" style="padding-bottom:5px" valign="top">
		
				   <table class="formpadding">
				   <cfoutput query="FundList">
				   <tr style="height;35px"><td style="padding-left:4px;padding-right:4px">

					   <input type="checkbox" class="radiol" name="SelectedFund" id="SelectedFund" 
						value="'#Fund#'"
					    onclick="ColdFusion.navigate('AllocationEntry.cfm?editionid=#url.editionid#&period=#url.period#','main','','','POST','fundform')">
						
					   </td>
					   <td class="labellarge" style="padding-left:4px;padding-right:5px">#Fund#</b></td>
				   </tr>			   
				   </cfoutput>
				   </table>
				   
				   <!---				   
				   
					<select name="SelectedFund" 
					  onchange="ColdFusion.navigate('AllocationEntry.cfm?editionid=#url.editionid#&period=#url.period#','main','','','POST','fundform')"		
					  multiple style="height:101%;width:100;font: 18px Calibri; border: 0px dotted silver; background-color: ffffff;">
					<cfloop query="FundList">		    
						<option value="'#Fund#'" style="padding:4px">#Fund#</option>
					</cfloop>
					</select>
				   </cfoutput>	
				   
				   --->
			   
			   </td></tr>
			   
			   </table>
			   
			   <!--- <cfif currentrow eq "1">selected</cfif> --->
		
			</td>
		
		    <td width="95%" style="padding-left:15px;padding-top:10px" valign="top" id="main" height="100%">	  
				<table border="0" style="border:1px dotted silver" cellspacing="0" cellpadding="0" height="100%" width="100%">
				  <tr><td class="labelmedium" align="center">
				        Select one or more funds
				        <!---
					    <cfset form.selectedfund = "'#FundList.Fund#'">		
						<cfinclude template     = "AllocationEntry.cfm">				
						--->
				      </td>
				   </tr>
				</table>	
			</td>
			
		</tr>
		
		</table>
	
	</form>
	
<cf_screenbottom layout="webapp">	