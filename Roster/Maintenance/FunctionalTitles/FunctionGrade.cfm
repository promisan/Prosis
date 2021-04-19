<cfparam name="url.mode" default="dialog">
<cfparam name="url.idmenu" default="">

<cfquery name="Grade" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*,
			(SELECT Description FROM Ref_GradeDeployment WHERE GradeDeployment = G.GradeDeployment) as GradeDeploymentDescription
	FROM 	FunctionTitle F, OccGroup O,
	     	FunctionTitleGrade G
	WHERE 	F.FunctionNo = G.FunctionNo
	AND   	F.FunctionNo = '#URL.ID#' 
	AND   	O.OccupationalGroup = F.OccupationalGroup
	AND   	Operational = 1
</cfquery>

<cfajaximport tags="cfdiv,cfform">
<cf_textareascript>
<cf_menuscript>

<cfparam name="URL.ID1" default="#Grade.GradeDeployment#">

<cfif url.mode eq "embed">

	<cf_screentop height="100%" 
				  layout="webapp"  
				  label="Job profile" 
				  scroll="yes" 		
				  html="Yes"  		  
				  jquery="Yes"
				  bannerforce="Yes"> 

<cfelseif url.mode eq "dialog">

	<cf_screentop height="100%" 
				  layout="webapp"  
				  label="Job profile" 
				  scroll="yes" 				  
				  jquery="Yes"
				  bannerforce="Yes"				 
				  menuAccess="Yes" 
				  systemfunctionid="#url.idmenu#"> 
				  
<cfelse>

	<cf_screentop height="100%" 
				  html="No"  
				  title="Job profile" 				  
				  banner="gray"				  				  
				  menuAccess="Yes" 
				  systemfunctionid="#url.idmenu#"> 
</cfif>

<cfoutput>

<cfset selected      = "">	
<cfset mode          = "edit">	
<cfset alias         = "appsSelection">
<cfset table         = "Ref_Experience">
<cfset pk            = "ExperienceFieldId">
<cfset desc          = "Description">	
<cfset order         = "">
<cfset filterstring  = "AND ExperienceClass IN (SELECT ExperienceClass FROM Ref_ExperienceClass WHERE Parent = '@@')">

<script language="JavaScript">

function reload(id1) {
	ptoken.location("FunctionGrade.cfm?idmenu=#url.idmenu#&ID=#URL.ID#&ID1="+id1);
}

function editField(reqid,reqline,par,val,box) {
	document.getElementById('requirementline').value  = reqline	
	document.getElementById('parent').value           = par		
	document.getElementById('box').value              = box	
	
	ColdFusion.Window.create('mydialog', 'builder', '',{x:100,y:100,height:680,width:650,modal:true,center:true});    
	ColdFusion.Window.show('mydialog'); 					
	ColdFusion.navigate("#SESSION.root#/tools/combobox/Combo.cfm?fld=&alias=#alias#&table=#table#&pk=#pk#&desc=#desc#&order=#order#&filterstring=#filterstring#&filtervalue="+par+"&selected="+val+"&script=fieldApply","mydialog") 								
}

function fieldApply(val) {
	id    = document.getElementById('requirementid').value
	line  = document.getElementById('requirementline').value
	par   = document.getElementById('parent').value
	box   = document.getElementById('box').value
	_cf_loadingtexthtml='';	
	ColdFusion.Window.hide('mydialog'); 	
	ptoken.navigate('FunctionBuilder/applyField.cfm?box='+box+'&id='+id+'&line='+line+'&parentcode='+par+'&val='+val,box)	
}

function editTopic(reqid,reqline,par,val,box) {
	document.getElementById('requirementline').value  = reqline	
	document.getElementById('parent').value           = par		
	document.getElementById('box').value              = box	
	
	ColdFusion.Window.create('mytopic', 'builder', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,center:true});    
	ColdFusion.Window.show('mytopic'); 		
    ColdFusion.navigate('FunctionBuilder/Topic/TopicView.cfm?ID=#URL.ID#&ID1=#URL.ID1#&box='+box+'&idmenu=#url.idmenu#&reqid='+reqid+'&reqline='+reqline+'&area='+par,'mytopic')
}

function setReqLineOperational(id, line, ctrl) {
	var vOp = 0;
	if (!!ctrl.checked) {
		vOp = 1;
	}
	_cf_loadingtexthtml='';	
	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/FunctionalTitles/FunctionBuilder/setRequirementLineOperational.cfm?reqId='+id+'&line='+line+'&value='+vOp,'op_'+id+'_'+line);
}


function do_submit(mode,id,id1,idmenu) {
	document.gjp.onsubmit();
	if( _CF_error_messages.length == 0 ) {
		ptoken.navigate('FunctionGradeSubmit.cfm?mode='+mode+'&ID='+id+'&ID1='+id1+'&idMenu='+idmenu,'processVariable','','','POST','gjp');
	}
}

function fprint() {
	ptoken.open("FunctionGradePrint.cfm?idmenu=#url.idmenu#&ID=#URL.ID#&ID1=#URL.ID1#", "_blank", "toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

</script>

</cfoutput>

<table width="95%" height="100%" align="center" cellspacing="0" cellpadding="0">
	
	<tr><td height="5"></td></tr>
	
	<tr>
		<td align="center" valign="top">
		
			<table width="100%" align="center">
				<tr>
				<cfset wd = "48">
				<cfset ht = "48">
				
				<cf_menutab item  = "1" 
			       iconsrc    = "Logos/Procurement/Pending.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   class      = "highlight1"
				   name       = "Minimum Requirements"
				   source     = "FunctionGradeMinimum.cfm?ID=#URL.ID#&ID1=#URL.ID1#&idMenu=#url.idmenu#">
				   
				<cfif url.id1 neq "">
				   
				 <cf_menutab item  = "2" 
			       iconsrc    = "Logos/Roster/Competence.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "Functional Requirements (VA Text)"
				   source     = "FunctionGradeVariable.cfm?ID=#URL.ID#&ID1=#URL.ID1#&idMenu=#url.idmenu#">
				
				</cfif>
				   
				   <td width="10%"></td>
				 </tr>
			 </table>
		
		<td>
	</tr>
	
	<tr>
		<td height="40">
			<table>
				<tr>
				   <td class="labelmedium" height="25" width="100"></td>
				   <td width="94%">
					   <table cellspacing="0" cellpadding="0" class="formpadding">
					   <cfoutput>
					   <tr>
					      <td class="labellarge">#Grade.FunctionDescription# (#Grade.Description#)</b></td>						  
					   	  <td class="labelmedium" style="padding-left:6px" height="25">/</td>
						   <td style="padding-left:4px">
						   <select name="GradeDeployment" class="regularxl" onChange="javascript:reload(this.value)">
						   <cfloop query="Grade">
						     <option value="#GradeDeployment#" <cfif #GradeDeployment# eq "#URL.ID1#">selected</cfif>>#GradeDeployment# - #GradeDeploymentDescription#</option>
						   </cfloop>
						   </select>
						   </td>
					   </tr>
					   </cfoutput>
					   </table>
				   </td>
				   <td>
				   		<input type="button" name="Print" value="Print profile" class="button10g" onclick="javascript:fprint()">
				   </td>
				</tr>
			</table>
					  
		</td>
	</tr>
	
	<tr>
	<td height="100%" valign="top">
	   <cf_divscroll style="height:100%">
	   <table width="100%" height="100%" cellspacing="0" cellpadding="0">
	   
		<cf_menucontainer item="1" class="regular">
			 <cf_securediv bind="url:FunctionGradeMinimum.cfm?ID=#URL.ID#&ID1=#URL.ID1#&idMenu=#url.idmenu#"> 
	 	<cf_menucontainer>	
		
	   </table>	
	   </cf_divscroll>
	</td>
	</tr>
	
</table>

<cfif url.mode eq "embed">
    <cf_screenbottom layout="innerbox" >
<cfelseif url.mode eq "dialog">
	<cf_screenbottom layout="innerbox" > 
<cfelse>
	<cf_screenbottom> 
</cfif>