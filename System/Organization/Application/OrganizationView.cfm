
<cfajaximport tags="cfform,cftree">

<cfparam name="url.systemfunctionid" default="">

<cf_tl id="Tree Builder" var="1">

<cfif url.systemfunctionid neq "">
	
	<cf_screenTop height="100%" 
         title="#lt_text# #URL.Mission#"
		 html="No" 		
		 banner="yellow" 
		 border="0" 
		 scroll="no" 
		 jQuery="Yes"
		 menuaccess="Yes"
		 validateSession="Yes"
		 systemfunctionid="#url.systemfunctionid#">	
		 
<cfelse>	

	<cf_screenTop height="100%" 
         title="#lt_text# #URL.Mission#"
		 html="No" 		
		 banner="yellow" 
		 border="0" 
		 scroll="no" 
		 jQuery="Yes"
		 validateSession="Yes"
		 menuaccess="Context">		 
			
</cfif>		

<cf_layoutScript>

<cfoutput>

<cfparam name="url.mode" default="regular">
<cfparam name="url.id2" default="#url.mission#">

<script language="JavaScript1.2">
	
	ie = document.all?1:0
	ns4 = document.layers?1:0					   
	
	if (screen) {
		w = #CLIENT.width# - 80
		h = #CLIENT.height# - 160
	}
	
	function refreshTree() {
	    //ColdFusion.navigate('../Application/OrganizationTree.cfm?mode=#url.mode#&id2=#url.id2#','treebox');
		$('##left').attr('src','../Application/OrganizationTree.cfm?mode=#url.mode#&id2=#url.id2#');	
	}
	
	function unitshow(unit) {
		//ColdFusion.navigate('../Application/OrganizationTree.cfm?unitselect='+unit+'&mode=#url.mode#&id2=#url.id2#','treebox');
		$('##left').attr('src','../Application/OrganizationTree.cfm?unitselect='+unit+'&mode=#url.mode#&id2=#url.id2#');
	}
	
	function orgunit() {
	    //ColdFusion.navigate('../Application/OrganizationTree.cfm?mode=#url.mode#&id2=#url.id2#','treebox');
		$('##left').attr('src','../Application/OrganizationTree.cfm?mode=#url.mode#&id2=#url.id2#');
		parent.right.location = "../Application/OrganizationViewHeader.cfm";
	}
	
	function orgaccess() {
	    window.open("../Access/OrganizationView.cfm","_top")   
	}

</script>
	 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea position="header" name="menu">			  
		 <cfinclude template="OrganizationMenu.cfm">			  
	</cf_layoutarea>		
	
	<cf_layoutarea
	      position="left" 
		  name="treebox"  
		  size="25%"
		  maxsize="28%" 
		  minsize="22%"
		  state="open"		   
		  collapsible="true" 
		  splitter="true">	
		  
			<iframe name="left"
			        id="left"
			        width="100%"
			        height="99%"
			        scrolling="no"
			        frameborder="0"
					src="OrganizationTree.cfm?mode=#url.mode#&id2=#url.id2#">
			</iframe>		
				 
	</cf_layoutarea>		 
	
	<cf_layoutarea 
          position="center"
          name="mainbox"
		  state="open"
          style="height:100%;"
          overflow="hidden">		

			<iframe name="right"
			        id="right"
			        width="100%"
			        height="100%"
			        scrolling="no"
			        frameborder="0"
					src="MissionEdit.cfm?id2=#url.id2#">
			</iframe>					
										
	
	</cf_layoutarea>			
		
</cf_layout>
	
</cfoutput>


