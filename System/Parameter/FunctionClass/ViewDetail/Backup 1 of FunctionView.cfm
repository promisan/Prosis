
<cfajaximport tags="cfform, cftextarea,cfdiv, cflayout-tab">

<cf_screenTop height="100%" label="Function editor" band="No" layout="webapp" banner="gray" scroll="no" flush="Yes">

<cfwindow 
          name        = "attributedialog"
          title       = "Attribute Maintenance"
          height      = "420"
          width       = "800"
		  bodystyle   = "background-color:ffffff"
		  headerstyle = "background-color:ActiveCaption"
          minheight   = "420"
          minwidth    = "800"
          center      = "True"
		  modal       = "True"/>	

<cfoutput>


<script language="JavaScript">

function more(bx,act) {
 
	icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	se   = document.getElementById(bx);
			 		 
	if (se.className == "hide" || act == "show") {
	   	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";				 
	 } else {
	   	 icM.className = "hide";
	     icE.className = "regular";
    	 se.className  = "hide"
	 }		 		
  }
  
function showbelow(line,data,id) {
    box  = document.getElementById(line+id);
	if (box.className=="hide") {
			 box.className  = "regular";	
			ColdFusion.navigate(data+'.cfm?ID='+id,data+id)			  
    } else {
	 box.className  = "hide";
    }					
}		 

function editRole(line,data,id,role) {
	  ColdFusion.navigate('FunctionRoles.cfm?Edit=Yes&ID='+id+'&Role='+role,'role')								
}	  

function saveRole(line,data,type,id,old,role) {
	  ColdFusion.navigate('FunctionRoles.cfm?Type='+type+'&Save=Yes&Edit=No&ID='+id+'&old='+old+'&Role='+role,'role')			  					
}

function Browse() {
      w = 500;
      h = 400;
  	  window.open("#SESSION.root#/System/Parameter/FunctionClass/FileManager.cfm", "FM", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=no");
}	
 
function detail(id,compare) {
	  w = #CLIENT.width# - 30;
	  h = #CLIENT.height# - 100;
	  window.open("#SESSION.root#/system/template/TemplateDetail.cfm?id="+id+"&compare="+compare,"_blank","left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes")
	} 
	
function addattribute(id,atr) {	    
	  ColdFusion.Window.show('attributedialog')					
	  ColdFusion.navigate('#SESSION.root#/system/parameter/functionClass/ViewDetail/Attribute.cfm?id='+id+'&AttrName='+atr,'attributedialog') 			
}	 		

function save_general(id) {
	  ColdFusion.navigate('#SESSION.root#/system/parameter/functionClass/ViewDetail/GeneralSubmit.cfm?id='+id,'d_save_box','','','POST','header');
}

function save_text(id,el,f) {
	  ColdFusion.navigate('#SESSION.root#/system/parameter/functionClass/ViewDetail/SaveText.cfm?id='+id+'&elementcode='+el,'d_save_box','','','POST',f);
}
 
</script>  

<cfparam name="URL.ID" default="">
<cfparam name="URL.ID1" default="">

<cfquery name="Delete" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE FROM ClassFunction
    WHERE ClassFunctionCode is null 
	AND   FunctionDescription is null 
	AND   FunctionReference is null
</cfquery>

	
<cfif URL.ID eq "">

	<cf_assignId>
	<cfset ClassId = RowGuid>
	
	<cfquery name="INSERTCLASSFUNCTION" 
	     datasource="AppsControl" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	  	  INSERT INTO ClassFunction
		   (ClassFunctionId,ClassFunctionCode, ClassId, FunctionDescription, FunctionReference)
		  VALUES ('#ClassId#',null, '#URL.ID1#', null, null)
	</cfquery>	
	
<cfelse>

	<cfset ClassId  = URL.ID>
	<cfset FormSubmit="FunctionEditSubmit.cfm">

</cfif>
 
<cfset attrib = {type="Tab",name="Function",tabheight="#client.height-220#",height="#client.height-194#",width="#client.width-102#"}>

<cflayout attributeCollection="#attrib#">

	<cflayoutarea 
    	name="att" 
	    title="Attachments"
	    overflow="hidden">	
		
		<table width="99%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td>	
		
		<cf_filelibraryN 
				DocumentPath="Documentation"
				SubDirectory="#URL.ID#"
				Filter="" 
				Insert="yes"
				Remove="yes"
				width="99%"
				AttachDialog="yes"
				align="left"
				border="100"> 	
				
				</td></tr></table>		
		
	</cflayoutarea>	
	
	<cflayoutarea 
    	name="General" 
	    title="Classification"
	    overflow="hidden"
		source="General.cfm?id=#ClassId#"/>		
	
	<cflayoutarea 
	    name="UseCase" 
	    title="Use Case"
	    overflow="auto"
		source="UseCase.cfm?id=#ClassId#"/>		
	
	<cflayoutarea 
	    name="Role" 
	    title="Associated Roles"
	    overflow="auto"
		source="FunctionRoles.cfm?id=#ClassId#"/>		
	
	<cflayoutarea 
	    name="Template" 
	    title="Associated Templates"
	    overflow="auto"
		source="FunctionTemplate.cfm?id=#ClassId#"/>		
		
</cflayout>	

<cfdiv id="d_save_box">

<cf_screenbottom layout="webapp">

</cfoutput>

