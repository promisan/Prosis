
<!--- Create Criteria string for query from data entered thru search form --->
 
<cf_textareascript>
<cfajaximport tags="CFFORM,cfwindow,cfdiv,cfinput-autosuggest">
<cf_calendarscript>
<cf_entityScript>

<cfquery name="SearchResult" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Entity E, Ref_AuthorizationRole R
	WHERE   E.Role = R.Role
	AND     E.EntityCode = '#URL.EntityCode#'
</cfquery>

<cfoutput>
	
<script>
	//ColdFusion.Layout.collapseArea('wfcontainer', 'right')
	<cfset Client.InspectHide = "true">
</script>

<script language="JavaScript">

function objectdialog(ent,code,type) {
    
	parent.ProsisUI.createWindow('mydialog', 'Questionaire Items', '',{x:100,y:100,height:parent.document.body.clientHeight-90,width:parent.document.body.clientWidth-90,modal:true,resizable:false,center:true})    			
	parent.ColdFusion.navigate('#SESSION.root#/System/EntityAction/EntityObject/ObjectElementQuestion.cfm?entitycode='+ent+'&code='+code+'&type='+type,'mydialog') 	
}

function showMailContentEdit(id){
  	
	parent.ProsisUI.createWindow('maildialog', 'Configure Customised Mail', '',{x:100,y:100,height:parent.document.body.clientHeight-90,width:parent.document.body.clientWidth-90,modal:true,resizable:false,center:true})    			
	parent.ColdFusion.navigate('#SESSION.root#/System/EntityAction/EntityObject/ObjectElementMailContent.cfm?documentId=' + id,'maildialog') 	

}

function savemyfield(ent,fld,tpe,id) {
    document.getElementById("myfield").onsubmit()
			
	if( _CF_error_messages.length == 0 ) {          
		ColdFusion.navigate('../../EntityObject/ObjectElementSubmit.cfm?documentid='+id+'&entitycode='+ent+'&id2='+fld+'&type='+tpe,'i'+tpe,'','','POST','myfield')
	 }   
}	 

function detail(box,cde) {

	
	se1 = document.getElementById("i"+box+"_max")
	se2 = document.getElementById("i"+box+"_min")
	
	if (se1.className == "regular") {
		se1.className = "hide"
		se2.className = "regular" 
		try {document.getElementById('boxdetail'+box).className = "hide" } catch(e) {}		
	} else {	
		se2.className = "hide"
		se1.className = "regular" 
		try {document.getElementById('boxdetail'+box).className = "regular" } catch(e) {}	
		ColdFusion.navigate('ActionRecordsPublish.cfm?actioncode='+cde,'detail'+box)			
	}	
}

function object(box,cde) {

	se1 = document.getElementById("d"+box+"_max")
	se2 = document.getElementById("d"+box+"_min")
	
	
	if (se1.className == "regular") {
		se1.className = "hide"
		se2.className = "regular" 
		try {document.getElementById('boxobject'+box).className = "hide" } catch(e) {}	
			
	} else {	
		se2.className = "hide"
		se1.className = "regular" 
		try {document.getElementById('boxobject'+box).className = "regular" } catch(e) {}	

		ColdFusion.navigate('ActionRecordsDocument.cfm?entitycode=#url.entitycode#&actioncode='+cde,'object'+box)			
	}	
}

function objectsave(box,cde) {
     ColdFusion.navigate('ActionRecordsDocumentSubmit.cfm?actioncode='+cde,'embed'+box,'','','POST','action')
	 ColdFusion.navigate('ActionRecordsDocument.cfm?entitycode=&actioncode=0','object'+box)	
} 

function template(file) {  
 	window.open("../EntityAction/TemplateDialog.cfm?path="+file, "Template", "left=40, top=40, width=860, height= 732, toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

function up(val) {
 if (val == "") {		    
    document.getElementById("fieldlookup1").className = "hide"
	document.getElementById("fieldlookup2").className = "hide"
	document.getElementById("fieldlookup3").className = "hide"
 } else {
    document.getElementById("fieldlookup1").className = "regular"
	document.getElementById("fieldlookup2").className = "regular"
	document.getElementById("fieldlookup3").className = "regular"
 }		 
}


function more(bx) {

    icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	se   = document.getElementById(bx)
			
	if (se.className == "hide")	{
	se.className   = "regular";
	icM.className  = "regular";
    icE.className  = "hide";
	} else {
	se.className   = "hide";
    icM.className  = "hide";
    icE.className  = "regular";
	}
}

function toggle(val) {

	switch (val)
	{
	case "text":
	  document.getElementById("text").className = "regular"
	  document.getElementById("date").className = "hide"
	  document.getElementById("list").className = "hide"	  
	  break;
	case "list":
	  document.getElementById("list").className = "regular"
  	  document.getElementById("text").className = "hide"
	  document.getElementById("date").className = "hide"	  
	  break;
	case "date":
	  document.getElementById("date").className = "regular"
 	  document.getElementById("list").className = "hide"
	  document.getElementById("text").className = "hide"	
	  break;
	default:
		document.getElementById("text").className = "hide"
		document.getElementById("list").className = "hide"
		document.getElementById("date").className = "hide"
	}	
}

function clearno() { document.getElementById("find").value = "" }

function searchme() {	 
	if (window.event.keyCode == "13") { 	 
	  document.getElementById("locateme").click() }				  
	}  
	
function searching(cde,val)  {
    _cf_loadingtexthtml='';	
	ptoken.navigate('ActionRecords.cfm?entitycode='+cde+'&search='+val,'actionrecords')
	}		 
	
function search(e) {	  
   se = document.getElementById("locateme");	   
   keynum = e.keyCode ? e.keyCode : e.charCode;	   	 						
   if (keynum == 13) {
      document.getElementById("locateme").click();  }						
   }	
	
function stepedit(id,pub,ent,cls) {
	if (id != "") {
	     ptoken.open("../ClassAction/ActionStepEdit.cfm?action=action&EntityCode="+ent+"&EntityClass="+cls+"&ActionCode="+id+"&PublishNo="+pub, "EditAction", "left=10, top=10, width=990, height=899, toolbar=no, status=yes, scrollbars=no, resizable=yes");
    }
}	

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
		 		 	
	 if (fld != false){	 
		 itm.className = "highLight2";	 
	 }else{
	     itm.className = "regular";		
	 }
  }
  
</script>

</cfoutput>

<cf_screentop height="100%" scroll="Yes" label="Configuration" html="No" jQuery="Yes" layout="innerbox">

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">

  <tr><td height="6"></td></tr>
   
  <cfoutput>
      
  <tr><td colspan="2">
  
   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		<cfloop query="SearchResult">
	
			<TR class="line labelmedium">
		    <td height="24">
			<!---
			&nbsp;
			 <img src="#SESSION.root#/Images/folder_close.gif" alt="" name="img0_#currentrow#" 
				  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/folder_open.gif'" 
				  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/folder_close.gif'"
				  style="cursor: pointer;" alt="" border="0" align="absmiddle" 
				  onClick="recordedit('#EntityCode#')">
				  --->
			</td>
		    <TD style="padding-left:10px">#EntityDescription#</TD>
		    <TD>Code:&nbsp;#EntityCode#</TD>
			<TD>Role:&nbsp;#Description#</TD>
		    <TD align="right" style="padding-right:4px;padding-left:4px">#DateFormat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
					
		</cfloop>
		
	</table>
	</td></tr>	
  
   <tr><td colspan="2">   

   <cfswitch expression="#url.option#">
    				
		<cfcase value="step">	
				   
			 <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			 
				 <tr><td height="3"></td></tr>
				 <tr><td style="height:34px;font-size:20px" class="labelmedium"><cf_tl id="Action Grouping"></td></tr>				
				 <tr><td>  
				 
				 <cfoutput>
				    <iframe id="ipar" src="ActionParent.cfm?entitycode=#URL.EntityCode#" width="100%" height="230" marginwidth="0" marginheight="0" align="left" scrolling="no" frameborder="0"></iframe>
			     </cfoutput>	
				 
				 </td></tr>
				 
				 <tr><td style="height:34px;font-size:20px" class="labelmedium"><cf_tl id="Action Library"></td></tr>				
				 <tr><td>  	   
					   
					 <cfoutput>
					 	<cfdiv id="actionrecords" 
						       bind="url:ActionRecords.cfm?entitycode=#URL.EntityCode#"/> 
					 </cfoutput>	
				 
				 </td></tr>
				  
				 <tr><td height="6"></td></tr>
			 
			 </table>	
			 
		</cfcase>	
		
		<cfcase value="group">
		
			<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
					
			<tr><td height="8"></td></tr>								
			<tr><td style="height:50px;font-size:25px" class="labellarge" colspan="5">
			<img src="#SESSION.root#/images//users2.gif"
					                     alt=""
					                     border="0">&nbsp;&nbsp;Flow Action Workgroup</td></tr>
			
			<tr><td colspan="5" class="line"></td></tr>		
			<tr><td height="4"></td></tr>		
			
			<tr><td height="5" colspan="5">
			 <cfoutput>
				 <cfdiv id="igrp" bind="url:ActionGroup.cfm?entitycode=#URL.EntityCode#"/> 
			 </cfoutput>	
			</td></tr>
			
			<cfif Searchresult.EnableStatus eq "1">
			
				<tr><td height="10"></td></tr>				
				<tr><td height="20" class="labelmedium">
				<img src="#SESSION.root#/images/activity_start.gif"
						                     alt=""
						                     border="0"
						                     align="absmiddle">&nbsp;&nbsp;Document Status</td></tr>
				
				<tr><td colspan="5" class="line"></td></tr>		
				<tr>
					<td>  	   						   
					 <cfoutput>
					 	<cfdiv name="ista" id="ista" bind="url:ObjectStatus.cfm?entitycode=#URL.EntityCode#"/> 
					 </cfoutput>						 
					</td>
				</tr>
				 
			</cfif>	 
					
			</table>
		
		</cfcase>
									
		<cfcase value="class">	
		
		    <table width="97%" align="center" class="formpadding">
				
			<tr><td height="8"></td></tr>		
			<tr><td style="height:50px;font-size:25px;font-weight:200" class="labellarge" colspan="5">
			<img src="#SESSION.root#/images/workflow_manager.gif"
					                     alt=""
					                     border="0">&nbsp;&nbsp;Defined Workflow Classes (Header for actual workflow compositions)</td></tr>
			<tr><td colspan="5" class="line"></td></tr>	
			<tr><td height="4"></td></tr>						 
			
			<tr><td height="5" colspan="5">
			   
				 <cfdiv name="icls" id="icls" bind="url:ActionClass.cfm?entitycode=#URL.EntityCode#"/> 
				
			</td></tr>
											
			</table>
		
		</cfcase>
							
		<cfcase value="dialog">			   
		 
			 <table width="95%" border="0" align="center" class="formpadding">
			 
				 <tr><td height="10"></td></tr>
				 <tr bgcolor="ffffff"><td align="center" style="height:80;width:40">
				 
	 				<cfset l = "dialog">
					
	 				 <img src="#SESSION.root#/Images/Logos/System/Dialog.png"
					id="#l#Exp" border="0" class="show" height="84"
					align="absmiddle" style="cursor: pointer;">
																	
					</td>
					<td width="80%" style="height:50px;font-size:25px;font-weight:200;padding-top:40px" class="labellarge">Embedded Dialogs</td>
					<td width="15%" style="height:40px;padding-top:40px" align="right" class="labellarge">Linked to Workflow</td>
				 </tr>		
									 
				 <tr><td colspan="3" id="#l#">  
				 <cfdiv id="i#l#" name="i#l#" 
				        bind="url:../../EntityObject/ObjectElement.cfm?entitycode=#URL.EntityCode#&type=dialog">
				 
				 </td>
				 </tr>
			 
			 </table>
			 
		  </cfcase>
		  
		  <cfcase value="rule">
		  
		    <table width="95%" border="0" align="center" class="formpadding">
			 
				<tr><td height="8"></td></tr>
			 
				<tr>
				 <td align="center" width="20">				 
				  <cfset l = "report">				
 				  <img src="#SESSION.root#/Images/read.gif"  
				  id="#l#Exp" border="0" class="show" 
				  align="absmiddle" style="cursor: pointer;">												
				  </td>
				  
				  <td  style="height:50px;font-size:25px" class="labellarge">Conditional global rules for object processing</td>				  
				  <td class="labelit" align="right">Used to enforce correct source document</td>
				 </tr>
				 
				 <!--- used for purchase order and for job --->
									 
				 <tr><td colspan="3" class="line"></td></tr>					 
				 <tr><td colspan="3" id="rule">  
				 <cfdiv id="irule" name="irule"
				        bind="url:../../EntityObject/ObjectElement.cfm?entitycode=#URL.EntityCode#&type=rule">
				 
				 </td></tr>
				 
				</table>
		  
		  
		  </cfcase>
			 
		  <cfcase value="document">	
			 
			  <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			 
				<tr><td height="8"></td></tr>
			 
				<tr>
				 <td align="center" width="20">				 
				  <cfset l = "report">				
 				  <img src="#SESSION.root#/Images/read.gif"  
				  id="#l#Exp" border="0" class="show" 
				  align="absmiddle" style="cursor: pointer;">												
				  </td>
				  
				  <td style="height:50px;font-size:25px" class="labellarge">Printable Documents from master Dialog</td>				  
				  <td align="right">Used for master dialog screen</td>
				 </tr>
				 
				 <!--- used for purchase order and for job --->
									 
				 <tr><td colspan="3" class="line"></td></tr>					 
				 
				 <tr><td colspan="3" id="report">  
				 <cfdiv id="idocument" name="idocument"
				        bind="url:../../EntityObject/ObjectElement.cfm?entitycode=#URL.EntityCode#&type=document">
				 
				 </td></tr>
				 
				</table>
				
			 </cfcase>	
			 
			 <cfcase value="report">	
			 
			  <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			 
				<tr><td height="8"></td></tr>
			 
				<tr>
				 <td align="center" width="20">				 
				  <cfset l = "report">				
 				  <img src="#SESSION.root#/Images/read.gif"  
				  id="#l#Exp" border="0" class="show" 
				  align="absmiddle" style="cursor: pointer;">												
				  </td>
				  
				  <td style="height:50px;font-size:25px" class="labellarge">Embedded Documents to be generated by an Action</td>				  
				  <td align="right" class="labelit">Linked to Action</td>
				 </tr>
									 
				 <tr><td colspan="3" class="line"></td></tr>					 
				 <tr><td colspan="3" id="report">  
				 <cfdiv id="ireport" 
				        bind="url:../../EntityObject/ObjectElement.cfm?entitycode=#URL.EntityCode#&type=report">
				 
				 </td></tr>
				 
				</table>
				
			 </cfcase>	
			 
			  <cfcase value="question">	
			 
			  <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			 
				 <tr><td height="8"></td></tr>
			 
				 <tr><td align="center" width="20">
				 
				 <cfset l = "question">
				
 				 <img src="#SESSION.root#/Images/logos/system/questionaire2.png" id="#l#Exp" height="80" border="0" class="show" align="absmiddle" style="cursor: pointer;">								
												
				     </td>
					 <td style="padding-top:40px;height:50px;font-size:25px" class="labellarge">Process evaluation Questions</td>
					 <td align="right">System Dialog</td>
					 
				 </tr>
								 
				 <tr><td colspan="3" id="question">  
				 <cfdiv id="iquestion" 
				        bind="url:../../EntityObject/ObjectElement.cfm?entitycode=#URL.EntityCode#&type=question">
				 
				 </td></tr>
				 
				</table>
				
			 </cfcase>	
			 
			  <cfcase value="attach">	
			 
			  <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			 
				 <tr><td height="8"></td></tr> 
			 
			 	 <tr><td align="center" width="20">
			 
	 				 <cfset l = "attach">
					
	 				 <img src="#SESSION.root#/Images/logos/system/attachment.png" alt="Show assignment history" 
					id="#l#Exp" border="0" class="show" height="80"
					align="absmiddle" style="cursor: pointer;">
							
			          </td>
					  <td style="height:50px;font-size:25px;padding-top:40px;padding-left:10px" class="labellarge">Required Attachments for Object</td>
					  <td align="right">Linked to Object or Action</td>
				 </tr>
			     				 
			     <tr><td colspan="3" id="attach">  
			 	 <cfdiv id="iattach" 
			        bind="url:../../EntityObject/ObjectElement.cfm?entitycode=#URL.EntityCode#&type=attach">
			 
				 </td></tr>		
				 
			</table>
				
			 </cfcase>	
			 
			  <cfcase value="mail">		
			  
			   <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			 
				 <tr><td height="8"></td></tr>  			 
			 			 
				 <tr><td align="center" width="30">
				 
					  <cfset l = "mail">
					
	 				 <img src="#SESSION.root#/Images/logos/system/mail_flow.png" height="84" alt="EMail Object" 
					id="#l#Exp" border="0" class="show" 
					align="absmiddle" style="cursor: pointer;">
								
					 </td>
					 <td style="height:50px;font-size:25px;padding-top:40;padding-left:14px" class="labellarge">Customised Mails</td>
					 <td align="right" style="padding-top:40px">Linked to Workflow</td>
				 </tr>
				 				 
				 <tr><td colspan="3" id="mail">  
				 <cfdiv id="imail" 
				        bind="url:../../EntityObject/ObjectElement.cfm?entitycode=#URL.EntityCode#&type=mail">
				 
				 </td></tr>
				 
			 </cfcase>	
			 
			  <cfcase value="method">		
			  
			   <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			 
				   <tr><td height="8"></td></tr>  			 	 
			 
			 	   <tr><td align="center" width="30">
			 
			 			 <cfset l = "script">
							
			 				 <img src="#SESSION.root#/Images/logos/system/script2.png" alt="Show assignment history" 
							id="#l#Exp" border="0" class="show" height="80"
							align="absmiddle" style="cursor: pointer;">
							
 						</td>
						<td style="padding-top:40px;height:50px;font-size:25px;padding-left:7px" class="labellarge"><cf_tl id="Scripts">/<cf_tl id="Methods"></td>
					    <td style="padding-top:40px;height:50px;" class="labelit" align="right">Linked to Workflow Methods</td>
				  </tr>
							 
						 
				  <tr><td colspan="3" id="script">  
				  <cfdiv id="iscript" 
				        bind="url:../../EntityObject/ObjectElement.cfm?entitycode=#URL.EntityCode#&type=script">
				  </td></tr>
				  
				 <tr><td height="6"></td></tr>
				 </table>	 
			 
			 </cfcase>
			 
			 <cfcase value="field">
			 
			 	 <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			 
					 <tr><td height="8"></td></tr>  			 	 
				 
				 	 <tr><td align="center" width="30">
				 
				 		 <cfset l = "script">
								
		 				 <img src="#SESSION.root#/Images/logos/system/fields.png" alt="Show assignment history" 
							 id="#l#Exp" border="0" class="show" height="84"
							 align="absmiddle" style="cursor: pointer;">
						
		 				 </td>
						 <td style="padding-top:40px;height:50px;font-size:25px;padding-left:10px" class="labellarge"><cf_tl id="Custom Fields"></td>
						 <td style="padding-top:40px;height:50px;padding-left:10px" align="right" class="labelit">Linked to Workflow Steps or Workflow Objects</td>
					 </tr>
									 
									 
					 <tr><td colspan="3">  
					 
					   <cfdiv id="ifield" 
					     bind="url:../../EntityObject/ObjectElement.cfm?entitycode=#URL.EntityCode#&type=field">
									
					  </td></tr>
					  
					 <tr><td height="6"></td></tr>
					 
				 </table>	 								   
				   
			</cfcase>		   
	   
   </cfswitch>
   
   </cfoutput>
   
   </td>
   
   </tr>
   		
</TABLE>

</td>
</tr>

</TABLE>

<cf_screenbottom layout="innerbox">


